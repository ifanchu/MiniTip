//
//  MTAdvancedModeViewController.h
//  MiniTip
//
//  Created by IFAN CHU on 11/28/12.
//  Copyright (c) 2012 IFAN CHU. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ADBannerView;

@interface MTAdvancedModeViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
{
    
}
@property (weak, nonatomic) IBOutlet UISlider *tipSlider;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UITextField *taxTextField;
@property (weak, nonatomic) IBOutlet UITableView *entryTableView;
@property (weak, nonatomic) IBOutlet UILabel *grandTotalLabel;

- (IBAction)calculateAndShowResultView:(id)sender;
- (IBAction)addPersonalEntry:(id)sender;
- (IBAction)addSharedEntry:(id)sender;
- (IBAction)tipSliderChanged:(id)sender;
// Update the grand total label
- (void)updateGrandTotal;
@end
