//
//  NSURL+CustomScheme.m
//  DemoAVPlayer
//
//  Created by Sanjay Singh Rathor on 09/11/23.
//  Copyright © 2023 Wutian. All rights reserved.
//

#import "NSURL+CustomScheme.h"

@implementation NSURL (CustomScheme)

- (instancetype)replaceURLWithScheme:(NSString *)aScheme {
    NSURLComponents *components = [[NSURLComponents alloc]initWithURL:self resolvingAgainstBaseURL:YES];
    components.scheme = aScheme;
    if (components.URL == NULL) {
        return self;
    }
    return components.URL;
}

@end
