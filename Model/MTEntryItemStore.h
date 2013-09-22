//
//  MTEntryItemStore.h
//  MiniTip
//
//  Created by IFAN CHU on 11/29/12.
//  Copyright (c) 2012 IFAN CHU. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MTEntryItem;
@class MTResultItemStore;

extern int const NUMBER_OF_INVISIBLE_CELL;

@interface MTEntryItemStore : NSObject
{
    NSMutableArray *entries;    // all entries will be added to this
    NSMutableArray *sharedEntries;  // only shared entries will be added to this
}

+ (NSString *)description;
+ (MTEntryItemStore *)defaultStore;
// remove all objects in entries and sharedEntries
- (void)clearStore;
// remove entry
- (void)removeEntry:(MTEntryItem *)p;
// return entries array
- (NSArray *)allEntries;
// create and add a personal entry to entries array
- (MTEntryItem *)createPersonalEntry;
// create and add a shared entry to entries and sharedEntries array
- (MTEntryItem *)createSharedEntry;

- (void)moveEntryAtIndex:(int)from toIndex:(int)to;
// return sharedEntries array
- (NSArray *)getSharedEntries;
// sum up the amount for all entries
- (double)sumOfAllEntries;
// sum up the amount for only sharedEntries
- (double)sumOfAllSharedEntries;
// split amount for shared entries
- (double)splitOfAllSharedEntries;
// total people in consideration
- (int)sumOfPeople;
// return a BOOL to indicate whether the data is enough
// to calculate
- (BOOL)isAbleToCalculate;

@end
