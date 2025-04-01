//
//  ipjsuaViewController.m
//  ipjsua
/*
 * Copyright (C) 2013-2014 Teluu Inc. (http://www.teluu.com)
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 */
#import "ipjsuaViewController.h"
#import "GSAccountConfiguration.h"
#import "GSConfiguration.h"
#import "GSUserAgent.h"
#import "SIHomeViewController.h"

@interface ipjsuaViewController ()
@property (weak, nonatomic) IBOutlet UITextField *addressTextField;
@property (weak, nonatomic) IBOutlet UITextField *domainTextField;
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *proxyTextField;
@property (weak, nonatomic) IBOutlet UITextField *portNumberTextField;

@end

@implementation ipjsuaViewController

@synthesize textLabel;

- (void)viewDidLoad {
    [super viewDidLoad];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _addressTextField.text = @"sohamshuklalko@sip.linphone.org";
    _domainTextField.text = @"sip.linphone.org";
    _userNameTextField.text = @"sohamshuklalko";
    _passwordTextField.text = @"Times@123";
    _proxyTextField.text = @"sip.linphone.org";
    _portNumberTextField.text = @"5060";
     
}


- (IBAction)registerDidClicked:(id)sender {
    GSAccountConfiguration *account = [GSAccountConfiguration defaultConfiguration];
    account.address = _addressTextField.text;
    account.username = _userNameTextField.text;
    account.password = _passwordTextField.text;
    account.domain = _domainTextField.text;
    account.proxyServer = _proxyTextField.text;
    
    GSConfiguration *configuration = [GSConfiguration defaultConfiguration];
    configuration.account = account;
    configuration.logLevel = 3;
    configuration.consoleLogLevel = 3;
    
    GSUserAgent *agent = [GSUserAgent sharedAgent];
    [agent configure:configuration];
    [agent start];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    SIHomeViewController *homeVC =  [storyboard instantiateViewControllerWithIdentifier:@"SIHomeViewController"];
    homeVC.account = agent.account;
    [[self navigationController] pushViewController:homeVC animated:YES];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.addressTextField resignFirstResponder];
    [self.userNameTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    [self.domainTextField resignFirstResponder];
    [self.proxyTextField resignFirstResponder];
}


@end
