//
//  SWFPSManager.m
//  AVPlayerDemo
//
//  Created by Sanjay Rathor on 11/12/24.
//
#import "SWFPSManager.h"

@interface SWFPSManager()<AVContentKeySessionDelegate>
@property (nonatomic, strong) NSURL *certificateURL;
@property (nonatomic, strong) NSURL *licenseURL;
@property (nonatomic, strong) AVContentKeySession *keySession;
@property (nonatomic, strong) dispatch_queue_t processingQueue;
@end

@implementation SWFPSManager

//1- Obtain App Certificate Fetch the FairPlay application certificate from a secure server.
//2- Generate SPC(Server playback context) Use the method to generate the SPC based on the certificate and content identifier.
//3- Send SPC to License Server Transmit the SPC to your license server, which should return the CKC.
//4- Provide CKC(Content key context) to Player
//5- Pass the CKC to the player to decrypt and play the content.

/// Initializes the FairPlay Manager with certificate and license URLs.
/// @param certificateURL The URL to fetch the application certificate.
/// @param licenseURL The URL to communicate with the license server.
/// @return An instance of `SWFPSManager` or `nil` if initialization fails.

- (instancetype)initWithCertificateURL:(NSURL *)certificateURL licenseURL:(NSURL *)licenseURL {
    self = [super init];
    if (self) {
        if (!certificateURL || !licenseURL) {
            NSError *error = [self.class errorWithCode:SWFPSErrorCodeInvalidConfiguration
                                           description:@"Certificate or License URL is invalid"];
            [self handleKeyRequestError:error];
            return nil;
        }
        
        _certificateURL = certificateURL;
        _licenseURL = licenseURL;
        _processingQueue = dispatch_queue_create("com.fairplay.drmprocessing", DISPATCH_QUEUE_CONCURRENT);
        [self setupContentKeySession];
    }
    return self;
}


/// Sets up the AVContentKeySession for managing FairPlay Streaming keys.
- (void)setupContentKeySession {
    self.keySession = [AVContentKeySession contentKeySessionWithKeySystem:AVContentKeySystemFairPlayStreaming];
    [self.keySession setDelegate:self queue:dispatch_get_main_queue()];
}

/// Prepares the provided AVURLAsset for FairPlay content key management.
/// @param aAsset The AVURLAsset to be prepared.
- (void)prepareFairPlayAsset:(AVURLAsset *)aAsset {
    if (!aAsset) {
        NSError *error = [self.class errorWithCode:SWFPSErrorCodeInvalidConfiguration
                                       description:@"Invalid asset"];
        [self handleKeyRequestError:error];
        return;
    }
    
    @try {
        [self.keySession addContentKeyRecipient:aAsset];
    } @catch (NSException *exception) {
        NSError *error = [self.class errorWithCode:SWFPSErrorCodeKeyRequestFailed
                                       description:[NSString stringWithFormat:@"Failed to add content key recipient: %@", exception.reason]];
        [self handleKeyRequestError:error];
    }
}

#pragma mark - AVContentKeySessionDelegate
/// Called when a content key request is provided by the AVContentKeySession.
/// @param session The content key session managing the request.
/// @param keyRequest The content key request object.

- (void)contentKeySession:(AVContentKeySession *)session didProvideContentKeyRequest:(AVContentKeyRequest *)keyRequest {
    if (!keyRequest) {
        NSError *error = [self.class errorWithCode:SWFPSErrorCodeKeyRequestFailed
                                       description:@"Received nil key request"];
        [self handleKeyRequestError:error];
        return;
    }
    
    [self handleContentKeyRequest:keyRequest];
}

/// Called when the content key session encounters an error.
/// @param session The content key session.
/// @param error The error encountered.
///
- (void)contentKeySession:(AVContentKeySession *)session
         didFailWithError:(NSError *)error {
    [self handleKeyRequestError:error];
}

- (BOOL)contentKeySession:(AVContentKeySession *)session shouldRetryContentKeyRequest:(AVContentKeyRequest *)keyRequest reason:(AVContentKeyRequestRetryReason)retryReason {
    
    BOOL shouldRetry = NO;
    
    /*
     Indicates that the content key request should be retried because the key response was not set soon enough either
     due the initial request/response was taking too long, or a lease was expiring in the meantime.
     */
    if (retryReason == AVContentKeyRequestRetryReasonTimedOut) {
        shouldRetry = YES;
    }
    
    /*
     Indicates that the content key request should be retried because a key response with expired lease was set on the
     previous content key request.
     */
    else if (retryReason == AVContentKeyRequestRetryReasonReceivedResponseWithExpiredLease) {
        shouldRetry = YES;
    }
    
    /*
     Indicates that the content key request should be retried because an obsolete key response was set on the previous
     content key request.
     */
    else if (retryReason == AVContentKeyRequestRetryReasonReceivedObsoleteContentKey) {
        shouldRetry = YES;
    }
    
    return shouldRetry;
}


#pragma mark - Private Helper Methods
/// Generates SPC data and retrieves CKC from the license server.
/// @param appCertificate The application certificate.
/// @param contentIdData The identifier for the content.
/// @param keyRequest The content key request.
///
- (void)makePlaybackContextKeyRequest:(NSData *)appCertificate contentIdData:(NSData *)contentIdData keyRequest:(AVContentKeyRequest *)keyRequest {
    
    if (!appCertificate || !contentIdData || !keyRequest) {
        NSError *error = [self.class errorWithCode:SWFPSErrorCodeInvalidConfiguration
                                       description:@"Invalid parameters for content key request"];
        [self handleKeyRequestError:error];
        return;
    }
    
    [keyRequest makeStreamingContentKeyRequestDataForApp:appCertificate
                                       contentIdentifier:contentIdData
                                                 options:nil
                                       completionHandler:^(NSData * _Nullable spcData, NSError * _Nullable error) {
        if (error || !spcData) {
            NSError *error = [self.class errorWithCode:SWFPSErrorCodeSPCDataFailed
                                           description:@"No SPC data generated"];
            [keyRequest processContentKeyResponseError:error];
            [self handleKeyRequestError:error];
            return;
        }
        
        // Send SPC to the license server to fetch CKC
        [self fetchCKCFromLicenseServerWithSPC:spcData completion:^(NSData * _Nullable ckcData, NSError * _Nullable error) {
            if (error) {
                NSError *wrappedError = [self.class errorWithCode:SWFPSErrorCodeSPCDataFailed
                                                      description:[NSString stringWithFormat:@"CKC fetch failed: %@", error.localizedDescription]];
                [keyRequest processContentKeyResponseError:wrappedError];
                [self handleKeyRequestError:wrappedError];
                return;
            }
            
            if (!ckcData) {
                NSError *error = [self.class errorWithCode:SWFPSErrorCodeSPCDataFailed
                                               description:@"No CKC(content key contex)t data received"];
                [keyRequest processContentKeyResponseError:error];
                [self handleKeyRequestError:error];
                return;
            }
            
            // Provide the CKC to the key request
            AVContentKeyResponse *response = [AVContentKeyResponse contentKeyResponseWithFairPlayStreamingKeyResponseData:ckcData];
            [keyRequest processContentKeyResponse:response];
        }];
    }];
}

/// Processes a content key request.
/// @param keyRequest The content key request to process.
- (void)handleContentKeyRequest:(AVContentKeyRequest *)keyRequest {
    dispatch_async(self.processingQueue, ^{
        [self getCertificateWithCompletion:^(NSData *appCertificate, NSError *error) {
            if (error) {
                [self handleKeyRequestError:error];
                return;
            }
            [self getContentIdentifierForRequest:keyRequest completion:^(NSData * _Nullable contentIdData, NSError * _Nullable error) {
                if (error) {
                    [self handleKeyRequestError:error];
                    return;
                }
                [self makePlaybackContextKeyRequest:appCertificate contentIdData:contentIdData keyRequest:keyRequest];
            }];
        }];
    });
}

/// Retrieves the content identifier for a key request.
/// @param keyRequest The content key request.
/// @param completion Completion block with asset ID data or error.

- (void)getContentIdentifierForRequest:(AVContentKeyRequest *)keyRequest
                         completion:(void(^)(NSData * _Nullable assetIDData, NSError * _Nullable error))completion {
    if (!keyRequest.identifier) {
        NSError *error = [self.class errorWithCode:SWFPSErrorCodeDecryptionFailed
                                       description:@"Key request identifier is nil"];
        completion(nil, error);
        return;
    }
    
    NSLog(@"%@", keyRequest.identifier);
    
    NSData *assetIDData = nil;
    if ([keyRequest.identifier isKindOfClass:[NSString class]]) {
        assetIDData = [(NSString *)keyRequest.identifier dataUsingEncoding:NSUTF8StringEncoding];
    } else if ([keyRequest.identifier isKindOfClass:[NSURL class]]) {
        assetIDData = [[(NSURL *)keyRequest.identifier absoluteString] dataUsingEncoding:NSUTF8StringEncoding];
    }
    if (!assetIDData) {
        NSError *error = [self.class errorWithCode:SWFPSErrorCodeKeyRequestFailed
                                       description:@"Failed to convert identifier to data"];
        completion(nil, error);
        return;
    }
    
    completion(assetIDData, nil);
}

/// Asynchronously loads the application certificate.
/// @param completion Completion block with certificate data or error.
///
- (void)getCertificateWithCompletion:(void (^)(NSData *certificateData, NSError *error))completion {
    
    if (!_certificateURL) {
        NSError *error = [self.class errorWithCode:SWFPSErrorCodeCertificateError
                                       description:@"Certificate URL is not set."];
        completion(nil, error);
        return;
    }
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:_certificateURL
                                            completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            completion(nil, error);
            return;
        }
        
        if (data) {
            completion(data, nil);
        } else {
            NSError *error = [self.class errorWithCode:SWFPSErrorCodeCertificateError
                                           description:@"Failed to fetch certificate data."];
            completion(nil, error);
        }
    }];
    [dataTask resume];
}

/// Fetches CKC data from the license server.
/// @param spcData The SPC data to send to the server.
/// @param completion Completion block with CKC data or error.
///
- (void)fetchCKCFromLicenseServerWithSPC:(NSData *)spcData completion:(void (^)(NSData *ckcData, NSError *error))completion {
    
    if (!spcData) {
        NSError *error = [self.class errorWithCode:SWFPSErrorCodeSPCDataFailed description:@"SPC data is invalid."];
        completion(nil, error);
        return;
    }
    
    // Create the request
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:_licenseURL];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:spcData];
    
    // Perform the request
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request
                                                                 completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            completion(nil,error);
            return;
        }
        if (!data) {
            NSError *error = [self.class errorWithCode:SWFPSErrorCodeSPCDataFailed description:@"No data received from server."];
            completion(nil, error);
            return;
        }
        completion(data, nil);
    }];
    [task resume];
}

#pragma mark - Error Handling
- (void)handleKeyRequestError:(NSError *)error {
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([self.delegate respondsToSelector:@selector(contentKeyRequestFailedWithError:)]) {
            [self.delegate contentKeyRequestFailedWithError:error];
        }
    });
}

#pragma mark - Utility Method
+ (NSError *)errorWithCode:(FairPlayDRMErrorCode)code description:(NSString *)description {
    return [NSError errorWithDomain:@"FairPlayDRMErrorDomain"
                               code:code
                           userInfo:@{NSLocalizedDescriptionKey: description ?: @"Unknown error"}];
}
@end
