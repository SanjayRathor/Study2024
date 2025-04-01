//
//  ViewController.m
//  AVPlayerDemo
//
//  Created by Sanjay Rathor on 10/12/24.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "PlayerView.h"
#import "FairPlayResourceLoaderDelegate.h"
#import "SWFPSManager.h"

@interface ViewController () {
    BOOL _played;
    NSString *_totalTime;
    NSDateFormatter *_dateFormatter;
}

@property (nonatomic ,strong) AVPlayer *player;
@property (nonatomic ,strong) AVPlayerItem *playerItem;
@property (nonatomic ,weak) IBOutlet PlayerView *playerView;
@property (nonatomic ,weak) IBOutlet UIButton *stateButton;
@property (nonatomic ,weak) IBOutlet UILabel *timeLabel;
@property (nonatomic ,strong) id playbackTimeObserver;
@property (nonatomic ,weak) IBOutlet UISlider *videoSlider;
@property (nonatomic ,weak) IBOutlet UIProgressView *videoProgress;
@property (nonatomic ,strong) FairPlayResourceLoaderDelegate *delegate;


- (IBAction)stateButtonTouched:(id)sender;
- (IBAction)videoSlierChangeValue:(id)sender;
- (IBAction)videoSlierChangeValueEnd:(id)sender;

@property (nonatomic, strong) AVContentKeySession *keySession;
@property (nonatomic ,strong) SWFPSManager *keySessionDelegate;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
 
 ///   NSURL *streamURL = [NSURL URLWithString:@"https://cdnapisec.kaltura.com/p/2215841/playManifest/entryId/1_w9zx2eti/format/applehttp/protocol/https/a.m3u8"];
    
//    NSURL *streamURL = [NSURL URLWithString:@"https://d11d9cu3mpzy0m.cloudfront.net/output/cmfaprod/ezdrm_video.m3u8"];
//    NSURL *certificateURL = [NSURL URLWithString:@"https://d11d9cu3mpzy0m.cloudfront.net/input/cer/fairplay.cer"];
//    NSURL *licenseURL = [NSURL URLWithString:@"https://fps.ezdrm.com/api/licenses/auth?pX=7591c3"];
   
    NSURL *streamURL = [NSURL URLWithString:@"https://times-ott-live.akamaized.net/v1/master/840a24ccd7c75076211d060179b3ad0c64fdc6ca/timesplay_live_DRM_UAT/out/v1/b480296a243a480bbcb2d0f6e91c0235/index.m3u8"];
    NSURL *certificateURL = [NSURL URLWithString:@"https://ottapps.revlet.net/apps/y/countries.cer"];
    NSURL *licenseURL = [NSURL URLWithString:@"https://fp.service.expressplay.com/hms/fp/rights/?ExpressPlayToken=CAAAABgmKbkAJDg0MGQxNTk3LTZlMmUtNDRlZS1hYTgwLWI4ZjhmMWU4MjJjOAAAAHDRXvPWbTU_uWB0AjiYyFX1g37sI7q18TOZku3XThzDceb0X4SySirVjF0PjEvzV3ziKsLbO0UZ0id1izkohSWbiXWXFn2y9myH1J9Xlk0PrVRCIuqKEzZxwzOBWSPUDNiJFY40Kl7N6hGVfz3eKU925n7Q9GCtI7znOkitMUAAX4Uz5HU&id=588560f81720e74c27d87a32244b2ac6a1ab977a"];

    
    
    AVURLAsset *asset = [AVURLAsset assetWithURL:streamURL];
    //self.delegate  = [[FairPlayResourceLoaderDelegate alloc]initWithCertificateURL:certificateURL licenseURL:licenseURL];
   // [asset.resourceLoader setDelegate:_delegate queue:dispatch_get_main_queue()];

    self.playerItem = [AVPlayerItem playerItemWithAsset:asset];
    self.keySessionDelegate = [[SWFPSManager alloc]initWithCertificateURL:certificateURL licenseURL:licenseURL];
    [self.keySessionDelegate prepareFairPlayAsset:asset];
    
    [self.playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    [self.playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
    self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
    self.playerView.player = _player;
    self.stateButton.enabled = NO;

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(moviePlayDidEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:_playerItem];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)monitoringPlayback:(AVPlayerItem *)playerItem {
    
    __weak typeof(self) weakSelf = self;
    self.playbackTimeObserver = [self.playerView.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:NULL usingBlock:^(CMTime time) {
        CGFloat currentSecond = playerItem.currentTime.value/playerItem.currentTime.timescale;//
        [weakSelf.videoSlider setValue:currentSecond animated:YES];
        NSString *timeString = [self convertTime:currentSecond];
        weakSelf.timeLabel.text = [NSString stringWithFormat:@"%@/%@",timeString,self->_totalTime];
    }];
}

// KVO方法
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    AVPlayerItem *playerItem = (AVPlayerItem *)object;
    if ([keyPath isEqualToString:@"status"]) {
        if ([playerItem status] == AVPlayerStatusReadyToPlay) {
            NSLog(@"AVPlayerStatusReadyToPlay");
            self.stateButton.enabled = YES;
            CMTime duration = self.playerItem.duration;// 获取视频总长度
            CGFloat totalSecond = playerItem.duration.value / playerItem.duration.timescale;// 转换成秒
            _totalTime = [self convertTime:totalSecond];// 转换成播放时间
            [self customVideoSlider:duration];// 自定义UISlider外观
            NSLog(@"movie total duration:%f",CMTimeGetSeconds(duration));
            [self monitoringPlayback:self.playerItem];// 监听播放状态
        } else if ([playerItem status] == AVPlayerStatusFailed) {
            NSLog(@"AVPlayerStatusFailed");
        }
    } else if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
        NSTimeInterval timeInterval = [self availableDuration];// 计算缓冲进度
        NSLog(@"Time Interval:%f",timeInterval);
        CMTime duration = _playerItem.duration;
        CGFloat totalDuration = CMTimeGetSeconds(duration);
        [self.videoProgress setProgress:timeInterval / totalDuration animated:YES];
    }
}

- (NSTimeInterval)availableDuration {
    NSArray *loadedTimeRanges = [[self.playerView.player currentItem] loadedTimeRanges];
    CMTimeRange timeRange = [loadedTimeRanges.firstObject CMTimeRangeValue];// 获取缓冲区域
    float startSeconds = CMTimeGetSeconds(timeRange.start);
    float durationSeconds = CMTimeGetSeconds(timeRange.duration);
    NSTimeInterval result = startSeconds + durationSeconds;// 计算缓冲总进度
    return result;
}

- (void)customVideoSlider:(CMTime)duration {
    self.videoSlider.maximumValue = CMTimeGetSeconds(duration);
    UIGraphicsBeginImageContextWithOptions((CGSize){ 1, 1 }, NO, 0.0f);
    UIImage *transparentImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [self.videoSlider setMinimumTrackImage:transparentImage forState:UIControlStateNormal];
    [self.videoSlider setMaximumTrackImage:transparentImage forState:UIControlStateNormal];
}

- (IBAction)stateButtonTouched:(id)sender {
    if (!_played) {
        [self.playerView.player play];
        [self.stateButton setTitle:@"Stop" forState:UIControlStateNormal];
    } else {
        [self.playerView.player pause];
        [self.stateButton setTitle:@"Play" forState:UIControlStateNormal];
    }
    _played = !_played;
}

- (IBAction)videoSlierChangeValue:(id)sender {
    UISlider *slider = (UISlider *)sender;
    NSLog(@"value change:%f",slider.value);
    
    if (slider.value == 0.000000) {
        __weak typeof(self) weakSelf = self;
        [self.playerView.player seekToTime:kCMTimeZero completionHandler:^(BOOL finished) {
            [weakSelf.playerView.player play];
        }];
    }
}

- (IBAction)videoSlierChangeValueEnd:(id)sender {
    UISlider *slider = (UISlider *)sender;
    NSLog(@"value end:%f",slider.value);
    CMTime changedTime = CMTimeMakeWithSeconds(slider.value, 1);
    
    __weak typeof(self) weakSelf = self;
    [self.playerView.player seekToTime:changedTime completionHandler:^(BOOL finished) {
        [weakSelf.playerView.player play];
        [weakSelf.stateButton setTitle:@"Stop" forState:UIControlStateNormal];
    }];
}

- (void)updateVideoSlider:(CGFloat)currentSecond {
    [self.videoSlider setValue:currentSecond animated:YES];
}


- (void)moviePlayDidEnd:(NSNotification *)notification {
    NSLog(@"Play end");
    
    __weak typeof(self) weakSelf = self;
    [self.playerView.player seekToTime:kCMTimeZero completionHandler:^(BOOL finished) {
        [weakSelf.videoSlider setValue:0.0 animated:YES];
        [weakSelf.stateButton setTitle:@"Play" forState:UIControlStateNormal];
    }];
}

- (NSString *)convertTime:(CGFloat)second{
    NSDate *d = [NSDate dateWithTimeIntervalSince1970:second];
    if (second/3600 >= 1) {
        [[self dateFormatter] setDateFormat:@"HH:mm:ss"];
    } else {
        [[self dateFormatter] setDateFormat:@"mm:ss"];
    }
    NSString *showtimeNew = [[self dateFormatter] stringFromDate:d];
    return showtimeNew;
}

- (NSDateFormatter *)dateFormatter {
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
    }
    return _dateFormatter;
}

- (void)dealloc {
    [self.playerItem removeObserver:self forKeyPath:@"status" context:nil];
    [self.playerItem removeObserver:self forKeyPath:@"loadedTimeRanges" context:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:self.playerItem];
    [self.playerView.player removeTimeObserver:self.playbackTimeObserver];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
  TODO:-
 */

@end
