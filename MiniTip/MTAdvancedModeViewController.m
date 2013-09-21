//
//  MTAdvancedModeViewController.m
//  MiniTip
//
//  Created by IFAN CHU on 11/28/12.
//  Copyright (c) 2012 IFAN CHU. All rights reserved.
//

#import "MTAdvancedModeViewController.h"
#import "MTEntryTableViewCell.h"
#import "MTEntryItemStore.h"
#import "MTEntryItem.h"
#import "MTResultsViewController.h"
#import "MTResultItemStore.h"
#import "MTResultItem.h"
#import "ICFormatControl.h"

@interface MTAdvancedModeViewController ()

@end

@implementation MTAdvancedModeViewController
@synthesize tipLabel, tipSlider, taxTextField;

int const TAG_TAX_AMOUNT_UITEXTFIELD = 3;
int const TAG_ENTRY_FOR_NAME = 1;
int const TAG_ENTRY_AMOUNT_IN_DOLLAR=0;

- (id)init
{
    // Call the superclass's designated initializer
    self = [super init];
    if (self) {
//        UIBarButtonItem *btnCalculate = [[UIBarButtonItem alloc] initWithTitle:@"Calculate" style:UIBarButtonItemStyleBordered target:self action:@selector(calculateAndShowResultView:)];
        UIBarButtonItem *btnCalculate = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"math-128.png"] style:UIBarButtonItemStyleDone target:self action:@selector(calculateAndShowResultView:)];

        [[self navigationItem] setRightBarButtonItem:btnCalculate animated:YES];
        [self shouldBtnCalculateEnabled];
    }
    return self;
}

// To determine whether the Calculate button should be enabled
- (void)shouldBtnCalculateEnabled
{
    UIBarButtonItem *btnCalculate = [[self navigationItem] rightBarButtonItem];
    if ([[MTEntryItemStore defaultStore] isAbleToCalculate])
        [btnCalculate setEnabled:YES];
    else
        [btnCalculate setEnabled:NO];
}

- (IBAction)calculateAndShowResultView:(id)sender
{
    NSLog(@"Pressed Calculate");
    [self dismissKeyboard];
    double tipPercent = [[[self tipLabel] text] doubleValue]/100;
    double totalTax = [[ICFormatControl getFromUITextField:self.taxTextField] doubleValue];

    for (MTEntryItem *p in [[MTEntryItemStore defaultStore] allEntries]) {
        if (p.isSharedEntry)
            continue;
        if (p.entryForName.length == 0)     // no name
            continue;
        if ([[MTResultItemStore defaultStore] isEntryExistForName:p.entryForName]) {
            // if the result for name exist, add this entry to personalEntry
            MTResultItem *ri = [[MTResultItemStore defaultStore] getResultItemForName:[p entryForName]];
            [[ri personalEntries] addObject:p];
            NSLog(@"%@", [p description]);
        }else{
            // if does not exist, create a new MTResultItem
            MTResultItem *ri = [[MTResultItem alloc] init];
            [[ri personalEntries] addObject:p];
            [[MTResultItemStore defaultStore] addResultItem:ri];
            NSLog(@"%@", [p description]);
        }
    }

    [[MTResultItemStore defaultStore] setSumOfPeople:[[MTEntryItemStore defaultStore] sumOfPeople]];
    [[MTResultItemStore defaultStore] setSumOfAllEntries:[[MTEntryItemStore defaultStore] sumOfAllEntries]];
    [[MTResultItemStore defaultStore] setSumOfAllSharedEntries:[[MTEntryItemStore defaultStore] sumOfAllSharedEntries]];
    [[MTResultItemStore defaultStore] setTotalTip:[[MTEntryItemStore defaultStore] sumOfAllEntries]*tipPercent];
    [[MTResultItemStore defaultStore] setTotalTax:totalTax];
    [[MTResultItemStore defaultStore] setTipPercent:tipPercent];

    MTResultsViewController *rvc = [[MTResultsViewController alloc] initWithNibName:@"MTResultsViewController" bundle:nil];
    [[self navigationController] pushViewController:rvc animated:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSLog(@"MTAdvancedMode viewDidAppear");
    // clear ResultItemStore's data
    [[MTResultItemStore defaultStore] clearStore];
    [self shouldBtnCalculateEnabled];
}

- (IBAction)addPersonalEntry:(id)sender
{
    NSLog(@"Pressed addPersonalEntry");
    // Create a new Personal EntryItem and add it to the store
    [[MTEntryItemStore defaultStore] createPersonalEntry];
//    MTEntryItemStore *store = [MTEntryItemStore defaultStore];
    [[self entryTableView] reloadData];
    [self shouldBtnCalculateEnabled];
    int idx = [[[MTEntryItemStore defaultStore] allEntries] count] - 10 - 1;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:idx inSection:0];
    MTEntryTableViewCell *cell = (MTEntryTableViewCell *)[[self entryTableView] cellForRowAtIndexPath:indexPath];
    [[cell entryForName] becomeFirstResponder];
    [ICFormatControl formatUITextField:[cell entryAmountInDollar]];
    [ICFormatControl formatUITextField:[cell entryForName]];
    cell.entryAmountInDollar.delegate = self;
    [[cell entryForName] setKeyboardType:UIKeyboardTypeAlphabet];
    [[cell centerButton] setImage:[UIImage imageNamed:@"user_male-128.png"] forState:UIControlStateNormal];
}

- (IBAction)addSharedEntry:(id)sender
{
    NSLog(@"Pressed addSharedEntry");
    // Create a new Personal EntryItem and add it to the store
    [[MTEntryItemStore defaultStore] createSharedEntry];
    [[self entryTableView] reloadData];
    [self shouldBtnCalculateEnabled];
    int idx = [[[MTEntryItemStore defaultStore] allEntries] count] - 10 - 1;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:idx inSection:0];
    MTEntryTableViewCell *cell = (MTEntryTableViewCell *)[[self entryTableView] cellForRowAtIndexPath:indexPath];
    [[cell entryAmountInDollar] becomeFirstResponder];
    [ICFormatControl formatUITextField:[cell entryAmountInDollar]];
    [ICFormatControl formatUITextField:[cell entryForName]];
    cell.entryAmountInDollar.delegate = self;
    [[cell entryForName] setKeyboardType:UIKeyboardTypeAlphabet];
    [[cell centerButton] setImage:[UIImage imageNamed:@"group-128.png"] forState:UIControlStateNormal];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap)];
    [doubleTap setNumberOfTapsRequired:2];
    [self.view addGestureRecognizer:doubleTap];

    // setup custom UINavigation titleView
    [ICFormatControl setupCustomNavigationItemTitleView:self.navigationItem withCustomText:@"PARTY"];

    // Load Custom cell nib file
    UINib *nib = [UINib nibWithNibName:@"MTEntryTableViewCell" bundle:nil];
    // Register this NIB which contains the cell
    [[self entryTableView] registerNib:nib forCellReuseIdentifier:@"MTEntryTableViewCell"];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    // ui settings
    [ICFormatControl formatUILabel:self.tipLabel];
    [ICFormatControl formatUILabel:self.grandTotalLabel];
    [ICFormatControl formatUITextField:self.taxTextField withLeftVIewImage:@"money-35.png"];
    taxTextField.tag = TAG_TAX_AMOUNT_UITEXTFIELD;
    self.view.backgroundColor = [ICFormatControl getBackgroundColor];
    self.entryTableView.backgroundColor = [ICFormatControl getBackgroundColor];
    self.createIndividualEntryButton.backgroundColor = [UIColor clearColor];
    self.createSharedEntryButton.backgroundColor = [UIColor clearColor];
    [[self entryTableView] reloadData];
}

- (void)doubleTap{
    [self addPersonalEntry:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[self entryTableView] reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dismissKeyboard
{
    [[self taxTextField] resignFirstResponder];
    for (UITableViewCell *cell in [[self entryTableView] visibleCells]) {
        MTEntryTableViewCell *aCell = (MTEntryTableViewCell *)cell;
        [[aCell entryForName] resignFirstResponder];
        [[aCell entryAmountInDollar] resignFirstResponder];
    }
    [self.view endEditing:YES];
}

- (IBAction)tipSliderChanged:(id)sender {
    UISlider *slider = (UISlider *)sender;
    int progressAsInt = lroundf(slider.value);
    [slider setValue:progressAsInt];
    NSString *newText = [[NSString alloc] initWithFormat:@"%d%%", progressAsInt];
    [[self tipLabel] setText:newText];
    [self updateGrandTotal];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Get an item from EntryItemStore
    NSLog(@"MTAdvancedView cellForRowAtIndexPath");
    NSLog(@"%@", [[MTEntryItemStore defaultStore] description]);
    MTEntryItem *p = [[[MTEntryItemStore defaultStore] allEntries] objectAtIndex:[indexPath row]];
    // Get a new or recycled cell
    MTEntryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MTEntryTableViewCell"];
    [[cell entryAmountInDollar] setDelegate:self];
    [[cell entryForName] setDelegate:self];
    // Configure the cell with EntryItem
    [[cell entryForName] setText:[p entryForName]];
    [[cell entryAmountInDollar] setText:[p entryAmountInDollar]];
    [cell setIsSharedEntry:p.isSharedEntry];

    if (p.isInvisible) {
        [[cell entryAmountInDollar] setHidden:YES];
        [[cell entryForName] setHidden:YES];
        [[cell centerButton] setHidden:YES];
//        [[cell imageView] setHidden:YES];
    }else{
        [[cell entryAmountInDollar] setHidden:NO];
        [[cell entryForName] setHidden:NO];
        [[cell centerButton] setHidden:NO];
    }

    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[MTEntryItemStore defaultStore] allEntries] count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        MTEntryItemStore *store = [MTEntryItemStore defaultStore];
        MTEntryItem *p = [[store allEntries] objectAtIndex:[indexPath row]];
        [store removeEntry:p];

        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationRight];
        NSLog(@"Deleted row %d from tableView", [indexPath row]);
    }
    [self shouldBtnCalculateEnabled];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    // get textField's cell's index path
    MTEntryTableViewCell *cell = [ICFormatControl getCellFromTextField:textField];
    NSIndexPath *indexPath = [self.entryTableView indexPathForCell:cell];
    switch (textField.tag) {
        case TAG_ENTRY_AMOUNT_IN_DOLLAR:
        {
            NSLog(@"textFieldDidEndEditing for %@, IndexPath %d", @"entryAmountInDollar", [indexPath row]);
            // save entryAmountInDollar into MTEntryItem in IndexPath
            MTEntryItem *p = [[[MTEntryItemStore defaultStore] allEntries] objectAtIndex:[indexPath row]];
            p.entryAmountInDollar = [ICFormatControl getFromUITextField:textField];
            break;
        }
        case TAG_ENTRY_FOR_NAME:
        {
            NSLog(@"textFieldDidEndEditing for %@, IndexPath %d", @"entryForName", [indexPath row]);
            MTEntryItem *p = [[[MTEntryItemStore defaultStore] allEntries] objectAtIndex:[indexPath row]];
            p.entryForName = [textField text];
//            [[cell entryAmountInDollar] becomeFirstResponder];
            break;
        }
        case TAG_TAX_AMOUNT_UITEXTFIELD:
        {
            // create a personal entry if the tableview has no row
            int count = [[self entryTableView] numberOfRowsInSection:0];
            if (count == 0) {
                [self addPersonalEntry:nil];
            }
        }
        default:
            break;
    }
    [self shouldBtnCalculateEnabled];
    [self updateGrandTotal];
    NSLog(@"%@", [MTEntryItemStore description]);

    [[self entryTableView] scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSLog(@"textFieldDidBeginEditing tag: %d", textField.tag);


    // get textField's cell's index path
    NSIndexPath *indexPath = [self.entryTableView indexPathForCell:[ICFormatControl getCellFromTextField:textField]];

    [[self entryTableView] scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];

    if (textField.tag == 3) {
        textField.text = @"";
    }
}

- (void)updateGrandTotal
{
    double tipPercent = [[[self tipLabel] text] doubleValue]/100;
    double totalTax = [[ICFormatControl getFromUITextField:taxTextField] doubleValue];

    double grandTotal = [[MTEntryItemStore defaultStore] sumOfAllEntries]*(1+tipPercent) + totalTax;

    [[self grandTotalLabel] setText:[NSString stringWithFormat:@"$%.2f", grandTotal]];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    switch (textField.tag) {
        case TAG_ENTRY_FOR_NAME:
        {
            // If name loses focus, move focus to amount
            [[[ICFormatControl getCellFromTextField:textField] entryAmountInDollar] becomeFirstResponder];
            break;
        }
        case TAG_ENTRY_AMOUNT_IN_DOLLAR:
        {
            // do nothing, there is no return button
        }
        default:
            break;
    }
    return YES;
}

// UITextField delegate override: change currency UITextField text on the fly to comform with currency format: $00.00
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.taxTextField || textField.tag == 0) {
        return [ICFormatControl textField:textField formatUITextFieldForCurrencyInDelegate:range replacementString:string];
    }
    return YES;
}

@end
