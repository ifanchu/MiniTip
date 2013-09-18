//
//  MTEntryItemStore.m
//  MiniTip
//
//  Created by IFAN CHU on 11/29/12.
//  Copyright (c) 2012 IFAN CHU. All rights reserved.
//

#import "MTEntryItemStore.h"
#import "MTEntryItem.h"
#import "MTResultItemStore.h"

@implementation MTEntryItemStore
int const NUMBER_OF_INVISIBLE_CELL = 10;

+ (MTEntryItemStore *)defaultStore
{
    static MTEntryItemStore *defaultStore = nil;
    if (!defaultStore) {
        defaultStore = [[super allocWithZone:nil] init];
    }
    NSLog(@"%@", defaultStore);
    return defaultStore;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [self defaultStore];
}

- (void)clearStore
{
    [entries removeAllObjects];
    [sharedEntries removeAllObjects];
    for (int i=0; i < NUMBER_OF_INVISIBLE_CELL; i++) {
        [entries addObject:[MTEntryItem getInvisibleEntry]];
    }
}

- (id)init
{
    self = [super init];
    if (self) {
        if (!entries){
            entries = [[NSMutableArray alloc] init];
            for (int i=0; i < NUMBER_OF_INVISIBLE_CELL; i++) {
                // add 10 invisible entries to entries array
                // this is to implement the scrolling feature
                [entries addObject:[MTEntryItem getInvisibleEntry]];
            }
        }
        if(!sharedEntries)
            sharedEntries = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)removeEntry:(MTEntryItem *)p
{
    [entries removeObjectIdenticalTo:p];
    if (p.isSharedEntry)
        [sharedEntries removeObjectIdenticalTo:p];
}

- (NSArray *)allEntries
{
    return entries;
}

- (void)moveEntryAtIndex:(int)from toIndex:(int)to
{
    if (from < 0 || from >= [entries count] || to < 0 || to >= [entries count])
        return;
    if (from == to)
        return;
    
    // Get pointer to the object being moved
    MTEntryItem *p = [entries objectAtIndex:from];
    
    // Remove p from entries
    [entries removeObjectAtIndex:from];
    
    // Insert p in entries at new location
    [entries insertObject:p atIndex:to];
}

- (MTEntryItem *)createPersonalEntry
{
    MTEntryItem *p = [MTEntryItem getEmptyPersonalEntry];
    int insertLoc = [entries count] - NUMBER_OF_INVISIBLE_CELL;
    [entries insertObject:p atIndex:insertLoc];
    
    return p;
}

- (MTEntryItem *)createSharedEntry
{
    MTEntryItem *p = [MTEntryItem getEmptySharedEntry];
    [sharedEntries addObject:p];
    int insertLoc = [entries count] - NUMBER_OF_INVISIBLE_CELL;
    [entries insertObject:p atIndex:insertLoc];
    
    return p;
}

- (NSArray *)getSharedEntries
{
    return sharedEntries;
}

+ (NSString *)description
{
    return [[[MTEntryItemStore defaultStore] allEntries] description];
}

- (double)sumOfAllEntries
{
    double sum = 0;
    for (MTEntryItem *p in entries) {
        sum += [[p entryAmountInDollar] doubleValue];
    }
    return sum;
}

- (double)sumOfAllSharedEntries
{
    double sum = 0;
    for (MTEntryItem *p in sharedEntries) {
        sum += [[p entryAmountInDollar] doubleValue];
    }
    return sum;
}

- (int)sumOfPeople
{
    NSMutableSet *set = [[NSMutableSet alloc] init];
    for (MTEntryItem *p in entries) {
        if ([[p entryForName] length] == 0)
            continue;
        [set addObject:[p entryForName]];
    }
    return [set count];
}
/*
 Determine whether the Calculate button should be enabled or not.
 There should be at least 1 personal entry with name given to 
 be able to be calculated.
 */
- (BOOL)isAbleToCalculate
{
    if ([entries count] == 0)
        return NO;
    if ([self sumOfPeople] == 0)
        return NO;
    for (MTEntryItem *i in entries) {
        if ([i isSharedEntry])
            continue;
        if ([[i entryForName] length] != 0)
            return YES;
    }
    return NO;
}

- (double)splitOfAllSharedEntries
{
    return [self sumOfAllSharedEntries]/[self sumOfPeople];
}

- (NSString *)description
{
    return [entries description];
}
@end
