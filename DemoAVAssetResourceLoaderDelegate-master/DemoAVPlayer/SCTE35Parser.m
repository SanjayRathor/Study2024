//
//  SCTE35Parser.m
//  DemoAVPlayer
//
//  Created by Sanjay Singh Rathor on 21/11/23.
//  Copyright © 2023 Wutian. All rights reserved.
//

#import "SCTE35Parser.h"

@implementation SCTE35Parser
+ (NSString *)decodeBase64SCTE35:(NSString *)base64String {
    // Convert the Base64 string to NSData
    NSData *base64Data = [[NSData alloc] initWithBase64EncodedString:base64String options:0];
    
    // Convert the NSData to a UTF-8 encoded string
    NSString *decodedString = [[NSString alloc] initWithData:base64Data encoding:NSUTF8StringEncoding];
    
    return decodedString;
}


+ (NSDictionary *)parseSCTE35:(NSString *)message {
    NSData *data = [self dataFromHexString:message];
    
    if (!data) {
        NSLog(@"Invalid SCTE-35 message");
        return @{};
    }
    
    NSDictionary *spliceInfoSection = [self parseSpliceInfoSection:data];
    
    NSLog(@"Splice Info Section: %@", spliceInfoSection);
    
    return spliceInfoSection;
}

+ (NSDictionary *)parseSpliceInfoSection:(NSData *)data {
    // Implement parsing logic for the Splice Info Section
    // This involves extracting various fields based on the SCTE-35 standard
    // Return the parsed information as a dictionary
    
    // For simplicity, let's return an empty dictionary for now
    return @{};
}

+ (NSData *)dataFromHexString:(NSString *)hexString {
    NSMutableData *data = [NSMutableData data];
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[0-9a-fA-F]{2}" options:0 error:nil];
    NSArray *matches = [regex matchesInString:hexString options:0 range:NSMakeRange(0, hexString.length)];
    
    for (NSTextCheckingResult *match in matches) {
        NSRange range = [match range];
        NSString *byteString = [hexString substringWithRange:range];
        NSScanner *scanner = [NSScanner scannerWithString:byteString];
        
        unsigned int byteValue;
        [scanner scanHexInt:&byteValue];
        
        uint8_t byte = (uint8_t)byteValue;
        [data appendBytes:&byte length:1];
    }
    
    return data;
}

@end
