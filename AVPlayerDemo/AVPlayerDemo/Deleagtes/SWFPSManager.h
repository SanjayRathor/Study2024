//
//  SWFPSManager.h
//  AVPlayerDemo
//
//  Created by Sanjay Rathor on 11/12/24.
//

#import <Foundation/Foundation.h>
#import <AVKit/AVKit.h>

NS_ASSUME_NONNULL_BEGIN

/*
 
 */
typedef NS_ENUM(NSInteger, FairPlayDRMErrorCode) {
    SWFPSErrorCodeInvalidConfiguration = 1000,
    SWFPSErrorCodeKeyRequestFailed,
    SWFPSErrorCodeDecryptionFailed,
    SWFPSErrorCodeCertificateError,
    SWFPSErrorCodeSPCDataFailed
};

@protocol FairPlayDRMManagerDelegate <NSObject>
@optional
- (void)contentKeyRequestFailedWithError:(NSError *)error;
@end

@interface SWFPSManager : NSObject<AVContentKeySessionDelegate>
- (instancetype)initWithCertificateURL:(NSURL *)certificateURL licenseURL:(NSURL *)licenseURL;
- (void)prepareFairPlayAsset:(AVURLAsset *)aAsset;
@property (nonatomic, weak) id<FairPlayDRMManagerDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
