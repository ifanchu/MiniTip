//
//  MTEntryTableViewCell.m
//  MiniTip
//
//  Created by IFAN CHU on 11/28/12.
//  Copyright (c) 2012 IFAN CHU. All rights reserved.
//

#import "MTEntryTableViewCell.h"
#import "ICFormatControl.h"

@implementation MTEntryTableViewCell
@synthesize entryAmountInDollar, entryForName, isSharedEntry;

+ (MTEntryTableViewCell *)getEmptyPersonalEntryCell
{
    MTEntryTableViewCell *cell = [[MTEntryTableViewCell alloc] init];
    [[cell entryAmountInDollar] setText:@""];
    [[cell entryAmountInDollar] setEnabled:YES];
    [[cell entryForName] setText:@""];
    [[cell entryForName] setEnabled:YES];
    cell.isSharedEntry = NO;
    [cell.centerButton setImage:[ICFormatControl getPersonalImage] forState:UIControlStateNormal];
    return cell;
}

+ (MTEntryTableViewCell *)getEmptySharedEntryCell
{
    MTEntryTableViewCell *cell = [[MTEntryTableViewCell alloc] init];
    [[cell entryAmountInDollar] setText:@""];
    [[cell entryAmountInDollar] setEnabled:YES];
    [[cell entryForName] setText:@""];
    [[cell entryForName] setEnabled:NO];
    cell.isSharedEntry = YES;
    [cell.centerButton setImage:[ICFormatControl getGroupImage] forState:UIControlStateNormal];
    return cell;
}

- (void)setIsSharedEntry:(BOOL)aIsSharedEntry
{
    isSharedEntry = aIsSharedEntry;
    [[self entryForName] setEnabled:((aIsSharedEntry)? NO:YES)];
    if (isSharedEntry) {
        [[self entryForName] setText:@""];
        self.entryForName.placeholder = @"";
    }
}

//TODO: action for centerButton,
- (IBAction)moveFirstResponder:(id)sender{
//    [[self entryForName] becomeFirstResponder];
//    if ([self isSharedEntry])
//        [[self entryAmountInDollar] resignFirstResponder];
    if (isSharedEntry) {
        // if the cell is shared, change it to personal
        [[self entryForName] setEnabled:YES];
        self.isSharedEntry = NO;
        [self.centerButton setImage:[ICFormatControl getPersonalImage] forState:UIControlStateNormal];
        [[self entryForName] becomeFirstResponder];
        [[self entryForName] setPlaceholder:@"name"];
    }else{
        // if the cell is personal, change it to shared
        [[self entryForName] setEnabled:NO];
        self.isSharedEntry = YES;
        [self.centerButton setImage:[ICFormatControl getGroupImage] forState:UIControlStateNormal];
        [[self entryAmountInDollar] becomeFirstResponder];
    }
}

@end
