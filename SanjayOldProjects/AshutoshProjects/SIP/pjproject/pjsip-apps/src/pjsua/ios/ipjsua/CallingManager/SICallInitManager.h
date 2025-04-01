//
//  SICallInitManager.h
//  Gossip
//
//  Created by Chakrit Wichian on 7/9/12.
//


@interface SICallInitManager : NSObject
@property(strong, nonatomic)NSString *address;
@property (nonatomic, unsafe_unretained) UINavigationController *navigationController;
- (void)makeTheCall;

@end
