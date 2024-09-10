//
//  SCTE35Parser.h
//  DemoAVPlayer
//
//  Created by Sanjay Singh Rathor on 21/11/23.
//  Copyright © 2023 Wutian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCTE35Parser : NSObject

+ (NSDictionary *)parseSCTE35:(NSString *)message;
+ (NSDictionary *)parseSpliceInfoSection:(NSData *)data;
+ (NSData *)dataFromHexString:(NSString *)hexString;
+ (NSString *)decodeBase64SCTE35:(NSString *)base64String;
@end
