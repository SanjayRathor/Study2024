//
//  SCTE35AdsData.m
//  DemoAVPlayer
//
//  Created by Sanjay Singh Rathor on 20/11/23.
//  Copyright © 2023 Wutian. All rights reserved.
//

#import "SCTE35AdsData.h"

@implementation SCTE35AdsData

- (instancetype)init {
    self = [super init];
    _cueType = willStart;
    _time = 0;
    return  self;
}

- (NSDate *)programTime:(NSString *)aTime {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.timeZone = [[NSTimeZone alloc]initWithName:@"UTC"];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    return [dateFormatter dateFromString:aTime];
}

@end
