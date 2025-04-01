//
//  SIHomeViewController.m
//  ipjsua
//
//  Created by Sanjay Singh Rathor on 05/10/22.
//  Copyright © 2022 Teluu. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "SIHomeViewController.h"
#import "GSAccount.h"
#import "SICallInitManager.h"
#import "GSCall.h"
#import "Gossip.h"
#import "SICallViewController.h"

@interface SIHomeViewController () <GSAccountDelegate>

@end

@implementation SIHomeViewController {
    SICallInitManager *_callInit;
    GSCall *_incomingCall;
}

@synthesize account = _account;
@synthesize statusLabel = _statusLabel;
@synthesize connectButton = _connectButton;
@synthesize disconnectButton = _disconnectButton;
@synthesize makeCallButton = _makeCallButton;

- (void)setAccount:(GSAccount *)account {
    [self willChangeValueForKey:@"account"];
    [_account removeObserver:self forKeyPath:@"status"];
    _account = account;
    _account.delegate = self;
    [_account addObserver:self
               forKeyPath:@"status"
                  options:NSKeyValueObservingOptionInitial
                  context:nil];
    [self didChangeValueForKey:@"account"];
}


- (void)viewDidLoad {
    [[self navigationItem] setHidesBackButton:YES];
    [_account addObserver:self
               forKeyPath:@"status"
                  options:NSKeyValueObservingOptionInitial
                  context:nil];
}


- (IBAction)userDidTapConnect {
    [_account connect];
}

- (IBAction)userDidTapDisconnect {
    [_account disconnect];
}


- (IBAction)userDidTapMakeCall {
    if (!_callInit) {
        _callInit = [[SICallInitManager alloc] init];
        _callInit.navigationController = [self navigationController];
    }
    [_callInit makeTheCall];
}

- (void)statusDidChange {
    switch (_account.status) {
        case GSAccountStatusOffline: {
            [_statusLabel setText:@"Offline."];
            [_connectButton setEnabled:YES];
            [_disconnectButton setEnabled:NO];
            [_makeCallButton setEnabled:NO];
        } break;
            
        case GSAccountStatusConnecting: {
            [_statusLabel setText:@"Connecting..."];
            [_connectButton setEnabled:NO];
            [_disconnectButton setEnabled:NO];
            [_makeCallButton setEnabled:NO];
        } break;
            
        case GSAccountStatusConnected: {
            [_statusLabel setText:@"Connected."];
            [_connectButton setEnabled:NO];
            [_disconnectButton setEnabled:YES];
            [_makeCallButton setEnabled:YES];
            
            
        } break;
            
        case GSAccountStatusDisconnecting: {
            [_statusLabel setText:@"Disconnecting..."];
            [_connectButton setEnabled:NO];
            [_disconnectButton setEnabled:NO];
            [_makeCallButton setEnabled:NO];
        } break;
            
        case GSAccountStatusInvalid: {
            [_statusLabel setText:@"Invalid account info."];
            [_connectButton setEnabled:YES];
            [_disconnectButton setEnabled:NO];
            [_makeCallButton setEnabled:NO];
        } break;
    }
}


#pragma mark - GSAccountDelegate
- (void)account:(GSAccount *)account didReceiveIncomingCall:(GSCall *)call {
    _incomingCall = call;    
    UIAlertView *alert = [[UIAlertView alloc] init];
    [alert setAlertViewStyle:UIAlertViewStyleDefault];
    [alert setDelegate:self];
    [alert setTitle:@"Incoming call."];
    [alert addButtonWithTitle:@"Deny"];
    [alert addButtonWithTitle:@"Answer"];
    [alert setCancelButtonIndex:0];
    [alert show];
}


#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == [alertView cancelButtonIndex]) {
        [self userDidDenyCall];
    } else {
        [self userDidPickupCall];
    }
}

- (void)userDidPickupCall {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    SICallViewController *controller =  [storyboard instantiateViewControllerWithIdentifier:@"SICallViewController"];
    controller.call = _incomingCall;
    [[self navigationController] pushViewController:controller animated:YES];   
}

- (void)userDidDenyCall {
    [_incomingCall end];
    _incomingCall = nil;
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    if ([keyPath isEqualToString:@"status"])
        [self statusDidChange];
}

- (void)dealloc {
    [_account removeObserver:self forKeyPath:@"status"];
    _account = nil;
    _callInit = nil;
    _incomingCall = nil;
    _statusLabel = nil;
    _connectButton = nil;
    _disconnectButton = nil;
    _makeCallButton = nil;
}


@end
