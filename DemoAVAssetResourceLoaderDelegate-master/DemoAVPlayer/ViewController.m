//
//  ViewController.m
//  DemoAVPlayer
//
//  Created by 吴天 on 15/10/23.
//  Copyright © 2015年 Wutian. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "AssetLoaderDelegate.h"
#import "NSURL+CustomScheme.h"
#import "SCTE35AdsData.h"
#import "SCTE35Parser.h"

@interface ViewController ()

@property (nonatomic, strong) AssetLoaderDelegate * loaderDelegate;

@end

@implementation ViewController

static AVPlayer * theplayer = nil;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.loaderDelegate = [[AssetLoaderDelegate alloc] init];
    
    NSURL * url = [NSURL URLWithString:@"http://3.111.121.26:80/hlslive/Admin/Px0219323/live/10slikeTNSD/master.m3u8"];
///    NSURL * url = [NSURL URLWithString:@"https://livetv.sli.ke/timesnow/master.m3u8"];
    AVURLAsset * asset = [AVURLAsset assetWithURL:[url replaceURLWithScheme:SLPlaylistScheme]];
    [asset.resourceLoader setDelegate:self.loaderDelegate queue:dispatch_get_main_queue()];
    AVPlayerItem * item = [[AVPlayerItem alloc] initWithAsset:asset];
    AVPlayer * player = [AVPlayer playerWithPlayerItem:item];
    self.player = player;
    theplayer = player;
    [player play];    
  //  [player setMuted:true];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(scte35Notification:) name:SlikeScte35Notification object:nil];
    
    NSString *tag = @"/DA7AAAAAAAA///wDwUAR1Blf/9+AMcgkAAAAAAAGgIAQ1VFSQAAAAB/PwAAAQAwAAABBkNVRUkAALOFLE0=";
    
    NSString *decodeBase6 = [SCTE35Parser decodeBase64SCTE35:tag];
    
    
    NSDictionary *parsedInfo = [SCTE35Parser parseSCTE35:tag];
    NSLog(@"data::::::: %@", parsedInfo);
    
}

- (void)scte35Notification:(NSNotification *)notification {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        SCTE35AdsData *marker =  notification.userInfo[kScte35InfoKey];
        if (marker) {
            
            NSLog(@"\n<======================================================================>\n");
            NSLog(@"Noti=> duration = %f", marker.time);
            NSLog(@"Noti=> elapsed = %f", marker.elapsed);
            NSLog(@"Noti=> cueMessage = %@", marker.cueMessage);
            NSLog(@"Noti=> cueType = %ld", (long)marker.cueType);
           
            if (marker.cueType == willStart) {
                NSLog(@"ADS=> willStart");
            } else if (marker.cueType == didStarted) {
                NSLog(@"ADS=> didStarted");
                
            } else if (marker.cueType == inContinue) {
                NSLog(@"ADS=> inContinue");
            }
            else if (marker.cueType == ended) {
                NSLog(@"ADS=> ended");
            }
        }
    });
}

+ (AVPlayer *)player {
    return theplayer;
}

@end
