//
//  MTEntryTableViewCell.m
//  MiniTip
//
//  Created by IFAN CHU on 11/28/12.
//  Copyright (c) 2012 IFAN CHU. All rights reserved.
//

#import "MTEntryTableViewCell.h"
#import "ICFormatHelper.h"

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
    [cell.iconButton setImage:[ICFormatHelper getPersonalImage] forState:UIControlStateNormal];
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
    [cell.iconButton setImage:[ICFormatHelper getGroupImage] forState:UIControlStateNormal];
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

//TODO: action for iconButton
- (IBAction)pressedIconButton:(id)sender{
    // do nothing for now
}

@end
