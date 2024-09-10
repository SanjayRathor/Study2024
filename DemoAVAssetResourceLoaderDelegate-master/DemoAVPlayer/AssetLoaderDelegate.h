
#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

#define SLPlaylistScheme    @"kPlaylistScheme"
#define SLSegmentScheme     @"kLSegmentScheme"
#define SLHttpScheme        @"http"

OBJC_EXTERN NSString * const SlikeScte35Notification;
OBJC_EXTERN NSString * const kScte35InfoKey;

@interface AssetLoaderDelegate : NSObject <AVAssetResourceLoaderDelegate>
@end

@interface AVAssetResourceLoadingRequest(Redirect)
- (BOOL)redirectToServer;
@end
