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
    [cell.centerButton setImage:[UIImage imageNamed:@"user_male-128.png"] forState:UIControlStateNormal];
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
    [cell.centerButton setImage:[UIImage imageNamed:@"group-128.png"] forState:UIControlStateNormal];
    return cell;
}

- (void)setIsSharedEntry:(BOOL)aIsSharedEntry
{
    isSharedEntry = aIsSharedEntry;
    [[self entryForName] setEnabled:((aIsSharedEntry)? NO:YES)];
    if (isSharedEntry) {
        [[self entryForName] setText:@""];
        //TODO: set placeholder text to empty
        self.entryForName.placeholder = @"";
    }
}

//TODO: action for centerButton,
- (IBAction)moveFirstResponder:(id)sender{
    [[self entryForName] becomeFirstResponder];
    if ([self isSharedEntry])
        [[self entryAmountInDollar] resignFirstResponder];
}

@end
