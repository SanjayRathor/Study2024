//
//  NSURL+CustomScheme.h
//  Created by Sanjay Singh Rathor on 09/11/23.
//  Copyright © 2023 Wutian. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSURL (CustomScheme)
- (nonnull instancetype) replaceURLWithScheme:(nonnull NSString *)aScheme;
@end

NS_ASSUME_NONNULL_END
