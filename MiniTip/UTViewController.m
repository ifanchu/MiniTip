//
//  UTViewController.m
//  UltraTip
//
//  Created by IFAN CHU on 11/23/12.
//  Copyright (c) 2012 IFAN CHU. All rights reserved.
//

#import "UTViewController.h"

@interface UTViewController ()

@end

@implementation UTViewController
@synthesize billAmountTextField, taxAmountTextField, peopleSlider, tipSlider, easySplitSegmentedControl, grandTotalLabel, splitAmountLabel, peopleLabel, tipLabel, totalTipLabel;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeft)];
    [swipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRight)];
    [self.view addGestureRecognizer:swipeLeft];
    [self.view addGestureRecognizer:swipeRight];
    [self.view addGestureRecognizer:tap];
    // UI Setting
    [[self billAmountTextField] setClearsOnBeginEditing:YES];
    [[self taxAmountTextField] setClearsOnBeginEditing:YES];
    [self calculate];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dismissKeyboard
{
    [[self billAmountTextField] resignFirstResponder];
    [[self taxAmountTextField] resignFirstResponder];
    [self calculate];
}

- (void)swipeLeft
{
    NSLog(@"Received swipe left.");
    [[self billAmountTextField] becomeFirstResponder];
}

- (void)swipeRight
{
    NSLog(@"Received swipe right.");
    [[self taxAmountTextField] becomeFirstResponder];
}

- (IBAction)peopleSliderChanged:(id)sender
{
    UISlider *slider = (UISlider *)sender;
    int progressAsInt = lroundf(slider.value);
    [slider setValue:progressAsInt];
    NSString *newText = [[NSString alloc] initWithFormat:@"%d", progressAsInt];
    [[self peopleLabel] setText:newText];
    [self calculate];
}

- (IBAction)tipSliderChanged:(id)sender
{
    UISlider *slider = (UISlider *)sender;
    int progressAsInt = lroundf(slider.value);
    [slider setValue:progressAsInt];
    NSString *newText = [[NSString alloc] initWithFormat:@"%d", progressAsInt];
    [[self tipLabel] setText:newText];
    [[self easySplitSegmentedControl] setSelectedSegmentIndex:0];
    [self calculate];
}

- (IBAction)easySplitModeChanged:(id)sender
{
    [self calculate];
}

- (void)calculate
{
    double bill = [[[self billAmountTextField] text] doubleValue];
    double tax = [[[self taxAmountTextField] text] doubleValue];
    int selectedEasySplitMode = [[self easySplitSegmentedControl] selectedSegmentIndex];
    
    int people = (int)([[self peopleSlider] value]+0.5f);
    double tip = ([[self tipSlider] value]/100);
    
    double fTip = bill * tip;
    double fGrand = bill * (1 + tip) + tax;
    double fSplit = fGrand / people;
    
    if (selectedEasySplitMode == 1) {
        fSplit = ceil(fSplit);
        fGrand = fSplit * people;
        fTip = fGrand - bill - tax;
        double revisedTip = (((fGrand - tax)/bill) - 1) * 100;
        [[self tipLabel] setText:[[NSString alloc] initWithFormat:@"%0.0f", (isnan(revisedTip)? 0: revisedTip)]];
    }else if (selectedEasySplitMode == 2){
        fSplit = floor(fSplit);
        fGrand = fSplit * people;
        fTip = fGrand - bill - tax;        
        double revisedTip = (((fGrand - tax)/bill) - 1) * 100;
        [[self tipLabel] setText:[[NSString alloc] initWithFormat:@"%0.0f", (isnan(revisedTip)? 0: revisedTip)]];
    }
    [[self totalTipLabel] setText:[[NSString alloc] initWithFormat:@"$ %0.2f", fTip]];
    [[self grandTotalLabel] setText:[[NSString alloc] initWithFormat:@"$ %0.2f", fGrand]];
    [[self splitAmountLabel] setText:[[NSString alloc] initWithFormat:@"$ %0.2f", fSplit]];
}

@end
