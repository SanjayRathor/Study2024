//
//  FandomUtility.m
//  FandomLive
//
//  Created by Sanjay Singh Rathor on 13/01/20.
//  Copyright © 2020 Sanjay Singh Rathor. All rights reserved.
//

#import "FandomUtility.h"

@implementation FandomUtility

- (NSString*)calculatePostTimeFrom:(NSString*)postMinutes {
    
    NSInteger pMins = [postMinutes integerValue];
    if(pMins <= 0)
    {
        return @"a moment ago";
    }
    else
    {
        NSRange daysRange = NSMakeRange (1, 29);
        NSRange monthsRange = NSMakeRange (1, 11);
        
        NSInteger pHours = pMins/60;
        NSInteger pDays = pHours/24;
        NSInteger pMonths = pDays/30;
        
        NSInteger timeValue;
        NSString * timeUnit;
        if (pHours <= 0)
        {
            timeValue = pMins;
            timeUnit = (timeValue == 1) ? @"min ago" : @"mins ago";
        }
        else if (pHours < 24)
        {
            timeValue = pHours;
            timeUnit = (timeValue == 1) ? @"hr ago": @"hrs ago";
        }
        else if (NSLocationInRange(pDays, daysRange))
        {
            timeValue = pHours/24;
            timeUnit = (timeValue == 1) ? @"day ago" : @"days ago";
        }
        else if (NSLocationInRange(pMonths, monthsRange))
        {
            timeValue = pMonths;
            timeUnit = (timeValue == 1) ? @"month ago" : @"months ago";
        }
        else
        {
            timeValue = pMonths/12;
            timeUnit = (timeValue == 1) ? @"year ago" : @"years ago";
        }
        
        return [NSString stringWithFormat:@"%ld %@", (long)timeValue, timeUnit];
    }
}


@end
