//
//  SICallInitManager.m
//  Gossip
//
//  Created by Chakrit Wichian on 7/9/12.
//

#import "SICallInitManager.h"
#import "GSAccount.h"
#import "GSAccount.h"
#import "GSCall.h"
#import "GSUserAgent.h"
#import "SICallViewController.h"

@interface SICallInitManager ()
@end

@implementation SICallInitManager {
    
}

@synthesize navigationController = _navigationController;

- (id)init {
    if (self = [super init]) {
        _address = nil;
    }
    return self;
}

- (void)dealloc {
    _address = nil;
}

- (void)makeTheCall {
    GSAccount *account = [GSUserAgent sharedAgent].account;
    _address = @"ashutoshfb@sip.linphone.org:5060";
    
    GSCall *call = [GSCall outgoingCallToUri:_address fromAccount:account];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    SICallViewController *controller =  [storyboard instantiateViewControllerWithIdentifier:@"SICallViewController"];
    controller.call = call;
    [_navigationController pushViewController:controller animated:YES];
}

@end
