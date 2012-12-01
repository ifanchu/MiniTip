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
    NSMutableArray *entries;
    NSMutableArray *sharedEntries;
}

+ (NSString *)description;
+ (MTEntryItemStore *)defaultStore;

- (void)clearStore;

- (void)removeEntry:(MTEntryItem *)p;

- (NSArray *)allEntries;

- (MTEntryItem *)createPersonalEntry;

- (MTEntryItem *)createSharedEntry;

- (void)moveEntryAtIndex:(int)from toIndex:(int)to;

//// Calculate result based on the entries currently in store
//- (void)calculate;

- (NSArray *)getSharedEntries;

- (double)sumOfAllEntries;

- (double)sumOfAllSharedEntries;

- (double)splitOfAllSharedEntries;

- (int)sumOfPeople;

- (BOOL)isAbleToCalculate;

@end
