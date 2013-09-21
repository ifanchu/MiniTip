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
#import "ICFormatControl.h"

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
    [p setTitle:@"MiniTip"];
    
    [ICFormatControl formatUIButton:self.basicButton];
    [ICFormatControl formatUIButton:self.partyButton];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    NSLog(@"MTMain viewDidLoad");
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return [ICFormatControl textField:textField formatUITextFieldForCurrencyInDelegate:range replacementString:string];
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

- (IBAction)showInfoPage:(id)sender
{
    //TODO: implement info page
}

@end
