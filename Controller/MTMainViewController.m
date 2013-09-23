//
//  MTMainViewController.m
//  MiniTip
//
//  Created by IFAN CHU on 11/28/12.
//  Copyright (c) 2012 IFAN CHU. All rights reserved.
//

#import "MTMainViewController.h"
#import "UTViewController.h"
#import "MTAdvancedModeViewController.h"
#import "MTResultItemStore.h"
#import "MTEntryItemStore.h"
#import "ICFormatHelper.h"

@interface MTMainViewController ()

@end

@implementation MTMainViewController

- (id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UINavigationItem *p = [self navigationItem];
    
    [ICFormatHelper setupCustomNavigationItemTitleView:p withCustomText:TITLE_TEXT_FOR_MAIN];
    
    
    [ICFormatHelper formatUIButton:self.basicButton];
    [ICFormatHelper formatUIButton:self.partyButton];
    [ICFormatHelper formatUILabelAsBold:self.basicLabel];
    [ICFormatHelper formatUILabelAsBold:self.partyLabel];
    [ICFormatHelper formatLabelForButton:self.basicButton withHeight:30 andVerticalOffset:140 andText:ACCESSORY_LABEL_TEXT_FOR_BASIC withFont:[ICFormatHelper getLatoLightFont:18] withFontColor:[ICFormatHelper getCustomLightGray] withTag:0];
    [ICFormatHelper formatLabelForButton:self.partyButton withHeight:30 andVerticalOffset:140 andText:ACCESSORY_LABEL_TEXT_FOR_PARTY withFont:[ICFormatHelper getLatoLightFont:18] withFontColor:[ICFormatHelper getCustomLightGray] withTag:0];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    NSLog(@"MTMain viewDidLoad");
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return [ICFormatHelper textField:textField formatUITextFieldForCurrencyInDelegate:range replacementString:string];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSLog(@"MTMain viewDidAppear");
    // clear two store's data
    [[MTEntryItemStore defaultStore] clearStore];
    [[MTResultItemStore defaultStore] clearStore];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showBasicPage:(id)sender
{
    UTViewController *uvController = [[UTViewController alloc] initWithNibName:@"UTViewController" bundle:nil];
    [[self navigationController] pushViewController:uvController animated:YES];
}

- (IBAction)showAdvancedPage:(id)sender
{
    MTAdvancedModeViewController *advancedController = [[MTAdvancedModeViewController alloc] init];
    [[self navigationController] pushViewController:advancedController animated:YES];
}

@end
