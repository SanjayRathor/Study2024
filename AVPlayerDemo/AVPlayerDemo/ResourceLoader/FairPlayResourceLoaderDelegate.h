//
//  FairPlayResourceLoaderDelegate.h
//  AVPlayerDemo
//
//  Created by Sanjay Rathor on 10/12/24.
//

#import <Foundation/Foundation.h>
#import <AVKit/AVKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FairPlayResourceLoaderDelegate : NSObject <AVAssetResourceLoaderDelegate>

@property (nonatomic, strong) NSURL *certificateURL;
@property (nonatomic, strong) NSURL *licenseURL;

- (instancetype)initWithCertificateURL:(NSURL *)certificateURL licenseURL:(NSURL *)licenseURL;

@end


NS_ASSUME_NONNULL_END

