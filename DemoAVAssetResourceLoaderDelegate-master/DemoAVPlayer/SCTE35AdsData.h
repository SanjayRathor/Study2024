//
//  SCTE35AdsData.h
//  DemoAVPlayer
//
//  Created by Sanjay Singh Rathor on 20/11/23.
//  Copyright © 2023 Wutian. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, SCTE35CueType) {
  willStart = 0,
  didStarted = 1,
  inContinue = 2,
  ended = 3,
};

@interface SCTE35AdsData : NSObject
@property(nonatomic, strong) NSString *syntax;
@property(nonatomic, strong) NSString *cue;
@property(nonatomic, strong) NSString *identifier;
@property(nonatomic, assign) Float64 time;
@property(nonatomic, assign) Float64 elapsed;
@property(nonatomic, strong) NSString *cueMessage;
@property(nonatomic, assign) SCTE35CueType cueType;

- (NSDate *)programTime:(NSString *)aTime ;

///hls_time = duration = cue_out = cue_in = 0
///
@end

NS_ASSUME_NONNULL_END

