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

- (id)init
{
    // Call the superclass's designated initializer
    self = [super init];
    if (self) {
        
        // Set this bar button item as the right item in the navigationItem
//        [[self navigationItem] setLeftBarButtonItem:bbi];
        
        UIBarButtonItem *btnCalculate = [[UIBarButtonItem alloc] initWithTitle:@"Calculate" style:UIBarButtonItemStyleBordered target:self action:@selector(calculateAndShowResultView:)];

        [[self navigationItem] setRightBarButtonItem:btnCalculate animated:YES];
        [self shouldBtnCalculateEnabled];
    }
    return self;
}

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
    double totalTax = [[[self taxTextField] text] doubleValue];

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
    [[cell entryAmountInDollar] becomeFirstResponder];
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
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap)];
    [doubleTap setNumberOfTapsRequired:2];
    [self.view addGestureRecognizer:doubleTap];
    
    UINavigationItem *p = [self navigationItem];
    [p setTitle:@"Entry Input"];
    
    // Load Custom cell nib file
    UINib *nib = [UINib nibWithNibName:@"MTEntryTableViewCell" bundle:nil];
    // Register this NIB which contains the cell
    [[self entryTableView] registerNib:nib forCellReuseIdentifier:@"MTEntryTableViewCell"];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [ICFormatControl getBackgroundColor];
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
        [[cell dollarLabel] setHidden:YES];
        [[cell centerButton] setHidden:YES];
//        [[cell imageView] setHidden:YES];
    }else{
        [[cell entryAmountInDollar] setHidden:NO];
        [[cell entryForName] setHidden:NO];
        [[cell dollarLabel] setHidden:NO];
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
    MTEntryTableViewCell *cell = (MTEntryTableViewCell *)[[textField superview] superview];
    NSIndexPath *indexPath = [self.entryTableView indexPathForCell:cell];
    // if tag==0, it is entryAmountInDollar
    // if tag==1, it is entryForName
    switch (textField.tag) {
        case 0:
        {
            NSLog(@"textFieldDidEndEditing for %@, IndexPath %d", @"entryAmountInDollar", [indexPath row]);
            // save entryAmountInDollar into MTEntryItem in IndexPath
            MTEntryItem *p = [[[MTEntryItemStore defaultStore] allEntries] objectAtIndex:[indexPath row]];
            p.entryAmountInDollar = [textField text];
            // move firstResponder to entryForName
//            [[cell entryForName] becomeFirstResponder];
            break;
        }
        case 1:
        {
            NSLog(@"textFieldDidEndEditing for %@, IndexPath %d", @"entryForName", [indexPath row]);
            MTEntryItem *p = [[[MTEntryItemStore defaultStore] allEntries] objectAtIndex:[indexPath row]];
            p.entryForName = [textField text];
            break;
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
    NSIndexPath *indexPath = [self.entryTableView indexPathForCell:(MTEntryTableViewCell *)[[textField superview] superview]];
    
    [[self entryTableView] scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

- (void)updateGrandTotal
{
    double tipPercent = [[[self tipLabel] text] doubleValue]/100;
    double totalTax = [[[self taxTextField] text] doubleValue];
    
    double grandTotal = [[MTEntryItemStore defaultStore] sumOfAllEntries]*(1+tipPercent) + totalTax;
    
    [[self grandTotalLabel] setText:[NSString stringWithFormat:@"Grand Total: $%.2f", grandTotal]];
}

//- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
//{
////    self.entryTableView.frame= CGRectMake(self.entryTableView.frame.origin.x, self.entryTableView.frame.origin.y, self.entryTableView.frame.size.width, 70.0f);
////    NSIndexPath *indexPath =[NSIndexPath indexPathForRow:nIndex inSection:nSectionIndex];
//    NSIndexPath *indexPath = [self.entryTableView indexPathForCell:(MTEntryTableViewCell *)[[textField superview] superview]];
//    [self.entryTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
//    return YES;
//}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self dismissKeyboard];
    return YES;
}

@end
