//
//  UTViewController.h
//  UltraTip
//
//  Created by IFAN CHU on 11/23/12.
//  Copyright (c) 2012 IFAN CHU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>

@interface UTViewController : UIViewController <UITextFieldDelegate, ADBannerViewDelegate>
{
    
}
@property (weak, nonatomic) IBOutlet UITextField *billAmountTextField;
@property (weak, nonatomic) IBOutlet UITextField *taxAmountTextField;
@property (weak, nonatomic) IBOutlet UISlider *peopleSlider;
@property (weak, nonatomic) IBOutlet UISlider *tipSlider;
@property (weak, nonatomic) IBOutlet UISegmentedControl *easySplitSegmentedControl;
@property (weak, nonatomic) IBOutlet UILabel *grandTotalLabel;
@property (weak, nonatomic) IBOutlet UILabel *splitAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalTipLabel;

@property (weak, nonatomic) IBOutlet UILabel *peopleLabel;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;

- (IBAction)peopleSliderChanged:(id)sender;
- (IBAction)tipSliderChanged:(id)sender;
- (IBAction)easySplitModeChanged:(id)sender;

- (void)calculate;
// TextField Delegate

@end
