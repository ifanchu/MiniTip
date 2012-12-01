//
//  MTResultItemStore.m
//  MiniTip
//
//  Created by IFAN CHU on 11/29/12.
//  Copyright (c) 2012 IFAN CHU. All rights reserved.
//

#import "MTResultItemStore.h"
#import "MTResultItem.h"

@implementation MTResultItemStore
@synthesize sumOfAllEntries, sumOfPeople, totalTax, totalTip;

+ (MTResultItemStore *)defaultStore
{
    static MTResultItemStore *defaultStore = nil;
    if(!defaultStore){
        defaultStore = [[super allocWithZone:nil] init];
    }
    return defaultStore;
}

- (void)clearStore
{
    [persons removeAllObjects];
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [self defaultStore];
}

- (id)init
{
    self = [super init];
    if (self) {
        if (!persons) {
            persons = [[NSMutableArray alloc] init];
        }
    }
    return self;
}

- (void)removePerson:(MTResultItem *)p
{
    [persons removeObjectIdenticalTo:p];
}

- (NSArray *)allPersons
{
    return persons;
}

- (BOOL)isEntryExistForName:(NSString *)name
{
    for (MTResultItem *p in persons) {
        if ([p.getName isEqualToString:name])
            return YES;
    }
    return NO;
}

- (MTResultItem *)getResultItemForName:(NSString *)name
{
    if (![self isEntryExistForName:name])
        return nil;
    for (MTResultItem *p in persons) {
        if ([[p getName] isEqualToString:name])
            return p;
    }
    return nil;
}

- (void)addResultItem:(MTResultItem *)item
{
    if ([self isEntryExistForName:[item getName]])
        @throw NSInvalidArgumentException;
    [persons addObject:item];
}

@end
