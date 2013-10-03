//
//  MTDetailsViewController.m
//  MiniTip
//
//  Created by IFAN CHU on 11/29/12.
//  Copyright (c) 2012 IFAN CHU. All rights reserved.
//

#import "MTDetailsViewController.h"
#import "MTResultItem.h"
#import "MTEntryItemStore.h"
#import "MTResultItemStore.h"
#import "MTEntryItem.h"
#import "ICFormatHelper.h"

@interface MTDetailsViewController ()

@end

@implementation MTDetailsViewController

int const SECTION_PERSONAL_ENTRIES = 0;
int const SECTION_SHARED_ENTRIES = 1;
int const SECTION_TIP = 2;
int const SECTION_TAX = 3;
int const SECTION_SUBTOTAL = 4;

- (id)initWithResultItem:(MTResultItem *)aResultItem
{
    self = [super init];
    [self setResultItem:aResultItem];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UINavigationItem *p = [self navigationItem];
//    [p setTitle:[NSString stringWithFormat:@"%@'s breakdown", [[self resultItem] getName]]];
    [ICFormatHelper setupCustomNavigationItemTitleView:p withCustomText:TITLE_TEXT_FOR_DETAIL];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [ICFormatHelper getBackgroundColor];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case SECTION_PERSONAL_ENTRIES:
        {
            // Personal Entries section
            int count = [[[self resultItem] personalEntries] count];
            NSLog(@"Personal Entries count: %d", count);
            return (count==0? 1:count);
        }
        case SECTION_SHARED_ENTRIES:
        {
            // shared entries section
            int count = [[[MTEntryItemStore defaultStore] getSharedEntries] count];
            NSLog(@"Personal Entries count: %d", count);
            return (count==0? 1:count);
        }
        case SECTION_TIP:
        {
            // tip section
            return 1;
        }
        case SECTION_TAX:
        {
            //tax section
            return 1;
        }
        case SECTION_SUBTOTAL:
        {
            // subtotal section
            return 1;
        }
        default:
            return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    switch ([indexPath section]) {
        case SECTION_PERSONAL_ENTRIES:
        {
            if ([[[self resultItem] personalEntries] count] == 0) {
                [[cell textLabel] setText:@"No Personal Entry"];
                break;
            }
            int idx = [indexPath row];
            MTEntryItem *entry = (MTEntryItem *)[[[self resultItem] personalEntries] objectAtIndex:idx];
            [[cell textLabel] setText:@""];
            [[cell detailTextLabel] setText: [NSString stringWithFormat:@"$%@", [entry entryAmountInDollar]]];
            break;
        }
        case SECTION_SHARED_ENTRIES:
        {
            if ([[[MTEntryItemStore defaultStore] getSharedEntries] count] == 0) {
                [[cell textLabel] setText:@"No Shared Entry"];
                break;
            }
            int idx = [indexPath row];
            int sumOfPeople = [[MTResultItemStore defaultStore] sumOfPeople];
            MTEntryItem *entry = (MTEntryItem *)[[[MTEntryItemStore defaultStore] getSharedEntries] objectAtIndex:idx];
            double sharedEntryCost = [[entry entryAmountInDollar] doubleValue];
            [[cell textLabel] setText:[NSString stringWithFormat:@"$%.2f / %d", sharedEntryCost, sumOfPeople]];
            [[cell detailTextLabel] setText: [NSString stringWithFormat:@"$%.2f", sharedEntryCost/sumOfPeople]];
            break;
        }
        case SECTION_TIP:
        {
            double totalTip = [[MTResultItemStore defaultStore] totalTip];
            double sumOfAllEntries = [[MTResultItemStore defaultStore] sumOfAllEntries];
            double sumOfPersonalEntries = [[self resultItem] sumOfPersonalEntries];
            double sumOfSharedEntries = [[MTEntryItemStore defaultStore] splitOfAllSharedEntries];
            
            [[cell textLabel] setText:[NSString stringWithFormat:@"$%.2f/$%.2f*($%.2f+$%.2f)", totalTip, sumOfAllEntries, sumOfPersonalEntries, sumOfSharedEntries]];
            [[cell textLabel] setFont:[UIFont systemFontOfSize:15.0]];            
            [[cell detailTextLabel] setAdjustsFontSizeToFitWidth:YES];
            [[cell detailTextLabel] setText:[NSString stringWithFormat:@"$%.2f", (totalTip/sumOfAllEntries*(sumOfPersonalEntries+sumOfSharedEntries))]];
            break;
        }
        case SECTION_TAX:
        {
            double totalTax = [[MTResultItemStore defaultStore] totalTax];
            double sumOfAllEntries = [[MTResultItemStore defaultStore] sumOfAllEntries];
            double sumOfPersonalEntries = [[self resultItem] sumOfPersonalEntries];
            double sumOfSharedEntries = [[MTEntryItemStore defaultStore] splitOfAllSharedEntries];
            
            [[cell textLabel] setText:[NSString stringWithFormat:@"$%.2f/$%.2f*($%.2f+$%.2f)", totalTax, sumOfAllEntries, sumOfPersonalEntries, sumOfSharedEntries]];
            [[cell textLabel] setFont:[UIFont systemFontOfSize:15.0]];            
            [[cell detailTextLabel] setText:[NSString stringWithFormat:@"$%.2f", (totalTax/sumOfAllEntries*(sumOfPersonalEntries+sumOfSharedEntries))]];
            [[cell detailTextLabel] setAdjustsFontSizeToFitWidth:YES];
            break;
        }
        case SECTION_SUBTOTAL:
        {
            [[cell textLabel] setText:[NSString stringWithFormat:@"%@ should pay", [[self resultItem] getName]]];
            [[cell detailTextLabel] setText:[NSString stringWithFormat:@"$%.2f", [[self resultItem] totalForName]]];
            break;
        }
        default:
            assert(NO);
            break;
    }
    
    return cell;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return NO;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [ICFormatHelper formatUILabel:cell.textLabel];
    cell.textLabel.font = [ICFormatHelper getLightFont:20];
    [ICFormatHelper formatUILabelAsBold:cell.detailTextLabel];
    cell.detailTextLabel.font = [ICFormatHelper getBoldFont:20];
}
// create a UILabel, format it and assign it to header
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *aLabel = [[UILabel alloc] init];
    switch (section) {
        case SECTION_PERSONAL_ENTRIES:
            aLabel.text = [[NSString stringWithFormat:@"  %@'s Entries", self.resultItem.getName] uppercaseString];
            break;
        case SECTION_SHARED_ENTRIES:
            aLabel.text = [@"  Shared Entries" uppercaseString];
            break;
        case SECTION_TIP:
//            aLabel.text = [[NSString stringWithFormat:@"  Total Tip: $%.2f x %.0f%% = $%.2f", [[MTResultItemStore defaultStore] sumOfAllEntries], [[MTResultItemStore defaultStore] tipPercent]*100 ,[[MTResultItemStore defaultStore] totalTip]] uppercaseString];
            aLabel.text = [[NSString stringWithFormat:@"  Total Tip: $%.2f",[[MTResultItemStore defaultStore] totalTip]] uppercaseString];
            break;
        case SECTION_TAX:
            aLabel.text = [[NSString stringWithFormat:@"  Total Tax: $%.2f", [[MTResultItemStore defaultStore] totalTax]] uppercaseString];
            break;
        case SECTION_SUBTOTAL:
            aLabel.text = [@"  Subtotal" uppercaseString];
            break;
        default:
            break;
    }
    [ICFormatHelper formatUILabel:aLabel];
    aLabel.font = [ICFormatHelper getLightFont:26];
    aLabel.minimumScaleFactor = 0.5;
    aLabel.numberOfLines = 2;
    return aLabel;
}

// Need to implement this delegate method for viewForHeaderInSection to work properly
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

@end
