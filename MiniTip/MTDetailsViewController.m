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

@interface MTDetailsViewController ()

@end

@implementation MTDetailsViewController

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
    [p setTitle:[NSString stringWithFormat:@"%@'s breakdown", [[self resultItem] getName]]];
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
        case 0:
        {
            // Personal Entries section
            int count = [[[self resultItem] personalEntries] count];
            NSLog(@"Personal Entries count: %d", count);
            return (count==0? 1:count);
        }
        case 1:
        {
            // shared entries section
            int count = [[[MTEntryItemStore defaultStore] getSharedEntries] count];
            NSLog(@"Personal Entries count: %d", count);
            return (count==0? 1:count);
        }
        case 2:
        {
            // tip section
            return 1;
        }
        case 3:
        {
            //tax section
            return 1;
        }
        case 4:
        {
            // subtotal section
            return 1;
        }
        default:
            return 0;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
        {
            // Personal Entries section
            return @"Personal Entries";
            break;
        }
        case 1:
        {
            // shared entries section
            return @"Shared Entries";
            break;
        }
        case 2:
        {
            // tip section
            return [NSString stringWithFormat:@"Total Tip: $%.2f x %.0f%% = $%.2f", [[MTResultItemStore defaultStore] sumOfAllEntries], [[MTResultItemStore defaultStore] tipPercent]*100 ,[[MTResultItemStore defaultStore] totalTip]];
            break;
        }
        case 3:
        {
            //tax section
            return [NSString stringWithFormat:@"Total Tax: $%.2f", [[MTResultItemStore defaultStore] totalTax]];
            break;
        }
        case 4:
        {
            // subtotal section
            return @"";
            break;
        }
        default:
            return @"";
            break;
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
        case 0:
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
        case 1:
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
        case 2:
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
        case 3:
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
        case 4:
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


#pragma mark - Table view delegate

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    // Navigation logic may go here. Create and push another view controller.
//    /*
//     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
//     // ...
//     // Pass the selected object to the new view controller.
//     [self.navigationController pushViewController:detailViewController animated:YES];
//     */
//}

@end
