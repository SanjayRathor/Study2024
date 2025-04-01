//
//  SIHomeViewController.h
//  ipjsua
//
//  Created by Sanjay Singh Rathor on 05/10/22.
//  Copyright © 2022 Teluu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GSAccount;

NS_ASSUME_NONNULL_BEGIN

@interface SIHomeViewController : UIViewController
@property (nonatomic, strong) GSAccount *account;

@property (nonatomic, strong) IBOutlet UILabel *statusLabel;
@property (nonatomic, strong) IBOutlet UIButton *connectButton;
@property (nonatomic, strong) IBOutlet UIButton *disconnectButton;
@property (nonatomic, strong) IBOutlet UIButton *makeCallButton;

- (IBAction)userDidTapConnect;
- (IBAction)userDidTapDisconnect;
- (IBAction)userDidTapMakeCall;

@end

NS_ASSUME_NONNULL_END
