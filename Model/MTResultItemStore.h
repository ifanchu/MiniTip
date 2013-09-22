//
//  MTResultItemStore.h
//  MiniTip
//
//  Created by IFAN CHU on 11/29/12.
//  Copyright (c) 2012 IFAN CHU. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MTResultItem;

@interface MTResultItemStore : NSObject
{
    NSMutableArray *persons;
}

@property (nonatomic) int sumOfPeople;
@property (nonatomic) double sumOfAllEntries;
@property (nonatomic) double sumOfAllSharedEntries;
@property (nonatomic) double totalTip;
@property (nonatomic) double totalTax;
@property (nonatomic) double tipPercent;

+ (MTResultItemStore *)defaultStore;

- (void)removePerson:(MTResultItem *)p;

- (NSArray *)allPersons;

- (void)clearStore;

- (BOOL)isEntryExistForName:(NSString *)name;

- (MTResultItem *)getResultItemForName:(NSString *)name;

- (void)addResultItem:(MTResultItem *)item;

@end
