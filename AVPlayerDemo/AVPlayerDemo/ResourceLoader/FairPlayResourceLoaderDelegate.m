//
//  FairPlayResourceLoaderDelegate.m
//  AVPlayerDemo
//
//  Created by Sanjay Rathor on 10/12/24.
//

#import "FairPlayResourceLoaderDelegate.h"
@implementation FairPlayResourceLoaderDelegate

- (instancetype)initWithCertificateURL:(NSURL *)certificateURL licenseURL:(NSURL *)licenseURL {
    self = [super init];
    if (self) {
        _certificateURL = certificateURL;
        _licenseURL = licenseURL;
    }
    return self;
}

- (BOOL)resourceLoader:(AVAssetResourceLoader *)resourceLoader
shouldWaitForLoadingOfRequestedResource:(AVAssetResourceLoadingRequest *)loadingRequest {

    NSURL *url = loadingRequest.request.URL;
    if (![url.absoluteString containsString:@"skd"]) {
        return NO;
    }
    NSLog(@"AVAsset:::: %@", loadingRequest.request.URL);
    [self handleFairPlayKeyRequest:loadingRequest];
    return YES;
}

- (void)handleFairPlayKeyRequest:(AVAssetResourceLoadingRequest *)loadingRequest {
    [self fetchFairPlayCertificateWithCompletion:^(NSData *certificateData) {
        if (!certificateData) {
            [loadingRequest finishLoadingWithError:[NSError errorWithDomain:@"FairPlay" code:-1 userInfo:nil]];
            return;
        }
        
        NSString *contentId = loadingRequest.request.URL.absoluteString;
        NSData *contentIdData = [contentId dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error;
        NSLog(@"AVAsset:::: %@", contentId);
        NSData *spcData = [loadingRequest streamingContentKeyRequestDataForApp:certificateData
                                                             contentIdentifier:contentIdData
                                                                       options:nil
                                                                         error:&error];
        
        
        if (error || !spcData) {
            [loadingRequest finishLoadingWithError:error];
            return;
        }
        
        [self requestLicenseWithSPCData:spcData completion:^(NSData *ckcData) {
            if (!ckcData) {
                [loadingRequest finishLoadingWithError:[NSError errorWithDomain:@"FairPlay" code:-2 userInfo:nil]];
                return;
            }
            
            [loadingRequest.dataRequest respondWithData:ckcData];
            [loadingRequest finishLoading];
        }];
    }];
}

- (void)fetchFairPlayCertificateWithCompletion:(void (^)(NSData *certificateData))completion {
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithURL:self.certificateURL
                                        completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            NSLog(@"Error fetching certificate: %@", error.localizedDescription);
            completion(nil);
        } else {
            completion(data);
        }
    }];
    [task resume];
}
///Server playback context (SPC)
- (void)requestLicenseWithSPCData:(NSData *)spcData completion:(void (^)(NSData *ckcData))completion {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:self.licenseURL];
    request.HTTPMethod = @"POST";
    request.HTTPBody = spcData;
    [request setValue:@"application/octet-stream" forHTTPHeaderField:@"Content-Type"];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            NSLog(@"Error fetching license: %@", error.localizedDescription);
            completion(nil);
        } else {
            completion(data);
        }
    }];
    [task resume];
}

@end
