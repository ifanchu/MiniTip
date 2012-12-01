//
//  MTEntryTableViewCell.m
//  MiniTip
//
//  Created by IFAN CHU on 11/28/12.
//  Copyright (c) 2012 IFAN CHU. All rights reserved.
//

#import "MTEntryTableViewCell.h"

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
    return cell;
}

- (void)setIsSharedEntry:(BOOL)aIsSharedEntry
{
    isSharedEntry = aIsSharedEntry;
    [[self entryForName] setEnabled:((aIsSharedEntry)? NO:YES)];
    if (isSharedEntry) {
        [[self entryForName] setText:@"SHARED"];
    }
}



@end
