//
//  SICallViewController.h
//  Gossip
//
//  Created by Chakrit Wichian on 7/9/12.
//

#import "Gossip.h"


@interface SICallViewController : UIViewController

@property (nonatomic, strong) GSCall *call;

@property (nonatomic, strong) IBOutlet UILabel *statusLabel;
@property (nonatomic, strong) IBOutlet UIButton *hangupButton;

- (IBAction)userDidTapHangUp;

@end
