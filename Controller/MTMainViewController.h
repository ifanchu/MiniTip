//
//  MTMainViewController.h
//  MiniTip
//
//  Created by IFAN CHU on 11/28/12.
//  Copyright (c) 2012 IFAN CHU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MTMainViewController : UIViewController<UITextFieldDelegate>
{
    
}
- (IBAction)showBasicPage:(id)sender;
- (IBAction)showAdvancedPage:(id)sender;
- (IBAction)showInfoPage:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *basicButton;
@property (strong, nonatomic) IBOutlet UIButton *partyButton;
@property (strong, nonatomic) IBOutlet UIButton *showInfoButton;
@property (strong, nonatomic) IBOutlet UILabel *basicLabel;
@property (strong, nonatomic) IBOutlet UILabel *partyLabel;
@end
