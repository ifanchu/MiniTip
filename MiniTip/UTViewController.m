//
//  UTViewController.m
//  UltraTip
//
//  Created by IFAN CHU on 11/23/12.
//  Copyright (c) 2012 IFAN CHU. All rights reserved.
//

#import "UTViewController.h"
#import "ICFormatControl.h"

@interface UTViewController ()

@end

@implementation UTViewController
@synthesize billAmountTextField, taxAmountTextField, peopleSlider, tipSlider, easySplitSegmentedControl, grandTotalLabel, splitAmountLabel, peopleLabel, tipLabel, totalTipLabel;

- (void)viewDidLoad
{
    [super viewDidLoad];
//    UINavigationItem *p = [self navigationItem];
//    [p setTitle:@"BASIC"];
    // setup custom UINavigation titleView
    [ICFormatControl setupCustomNavigationItemTitleView:self.navigationItem withCustomText:@"BASIC"];
    
	// Do any additional setup after loading the view, typically from a nib.
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    UISwipeGestureRecognizer *swipeUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(focusOnBill)];
    [swipeUp setDirection:UISwipeGestureRecognizerDirectionUp];
    UISwipeGestureRecognizer *swipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(focusOnTax)];
    [swipeDown setDirection:UISwipeGestureRecognizerDirectionDown];
    [self.view addGestureRecognizer:swipeUp];
    [self.view addGestureRecognizer:swipeDown];
    [self.view addGestureRecognizer:tap];
    // UI Setting
    [ICFormatControl formatUITextField:self.billAmountTextField withLeftVIewImage:@"bill-35.png"];
    [ICFormatControl formatUITextField:[self taxAmountTextField] withLeftVIewImage:@"money-35.png"];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [ICFormatControl formatUILabel:self.peopleLabel];
    [ICFormatControl formatUILabel:self.tipLabel];
    [ICFormatControl formatUILabel:self.grandTotalLabel];
    [ICFormatControl formatUILabel:self.splitAmountLabel];
    [ICFormatControl formatUILabel:self.totalTipLabel];
    [ICFormatControl formatUILabel:self.totalLabel];
    [ICFormatControl formatUILabel:self.taxLabel];
    self.view.backgroundColor = [ICFormatControl getBackgroundColor];
    [self.myScrollView addSubview:self.contentView];
    self.myScrollView.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    ((UIScrollView *) self.myScrollView).contentSize = self.contentView.frame.size;
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

- (void)focusOnBill
{
    [[self billAmountTextField] becomeFirstResponder];
}

- (void)focusOnTax
{
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
    NSString *newText = [[NSString alloc] initWithFormat:@"%d%@", progressAsInt, @"%"];
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
    double bill = [[ICFormatControl getFromUITextField:billAmountTextField] doubleValue];
    double tax = [[ICFormatControl getFromUITextField:taxAmountTextField] doubleValue];
    double preTax = bill - tax;
    //It doesn't make sense if tax > bill * 0.2
    if (tax > bill * 0.2) {
        taxAmountTextField.textColor = [UIColor redColor];
    }else{
        taxAmountTextField.textColor = [ICFormatControl getCustomColorBlue];
    }
    // 0: no modify, 1: round up, 2: round down
    int selectedEasySplitMode = [[self easySplitSegmentedControl] selectedSegmentIndex];
    // how many ppl
    int people = (int)([[self peopleSlider] value]+0.5f);
    // tip %
    double tip = ([[self tipSlider] value]*0.01);
    // total tip = (bill - tax )* tip
    double fTip = preTax * tip;
    // total paying amount
    double fGrand = preTax * (1 + tip) + tax;
    // splitted amount
    double fSplit = fGrand / people;
    // revisedTip %
    double revisedTip = tip;
    
    if (selectedEasySplitMode == 1) {
        // round up the splitted amount
        fSplit = ceil(fSplit);
        //revised grand total
        fGrand = fSplit * people;
        // revised total tip
        fTip = fGrand - preTax - tax;
        // revised tip %
        revisedTip = (((fGrand - tax)/preTax) - 1);
    }else if (selectedEasySplitMode == 2){
        // round down the splitted amount
        fSplit = floor(fSplit);
        fGrand = fSplit * people;
        fTip = fGrand - preTax - tax;
        revisedTip = (((fGrand - tax)/preTax) - 1);
        // if revisedTip < 0, make it 0
        if (revisedTip < 0) {
            revisedTip = 0;
            fGrand = bill;
            fTip = 0;
            fSplit = (fGrand / people);
        }
    }
    [[self tipLabel] setText:[[NSString alloc] initWithFormat:@"%0.0f%@", (isnan(revisedTip)? 0: revisedTip*100), @"%"]];
    [[self totalTipLabel] setText:[[NSString alloc] initWithFormat:@"$ %0.2f", fTip]];
    [[self grandTotalLabel] setText:[[NSString alloc] initWithFormat:@"$ %0.2f", fGrand]];
    [[self splitAmountLabel] setText:[[NSString alloc] initWithFormat:@"$ %0.2f", fSplit]];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    return [ICFormatControl textField:textField formatUITextFieldForCurrencyInDelegate:range replacementString:string];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [ICFormatControl overrideTextFieldDidBeginEditing:textField];
}

@end
