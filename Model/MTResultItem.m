//
//  MTResultItem.m
//  MiniTip
//
//  Created by IFAN CHU on 11/29/12.
//  Copyright (c) 2012 IFAN CHU. All rights reserved.
//

#import "MTResultItem.h"
#import "MTEntryItem.h"
#import "MTEntryItemStore.h"
#import "MTResultItemStore.h"

@implementation MTResultItem
@synthesize personalEntries;

- (id)init
{
    self = [super init];
    if (self) {
        personalEntries = [[NSMutableArray alloc] init];
    }
    return self;
}

- (double)sumOfPersonalEntries
{
    double total = 0;
    for (int i=0; i<[personalEntries count]; i++) {
        MTEntryItem *entry = (MTEntryItem *)[personalEntries objectAtIndex:i];
        total += [[entry entryAmountInDollar] doubleValue];
    }
    return total;
}

- (double)portionOfName
{
    return ([self sumOfPersonalEntries]+[[MTEntryItemStore defaultStore] splitOfAllSharedEntries])/[MTResultItemStore defaultStore].sumOfAllEntries;
}

- (double)tipForName
{
    return [MTResultItemStore defaultStore].totalTip*[self portionOfName];
}

- (double)taxForName
{
    return [MTResultItemStore defaultStore].totalTax*[self portionOfName];
}

- (double)totalForName
{
    return [self sumOfPersonalEntries]+[[MTEntryItemStore defaultStore] splitOfAllSharedEntries]+[self tipForName]+[self taxForName];
}

- (NSString *)getName
{
    MTEntryItem *entry = (MTEntryItem *)([personalEntries objectAtIndex:0]);
    return [entry entryForName];
}

- (NSString *)description
{
    NSMutableString *desc = [[NSMutableString alloc] initWithFormat:@"%@ has following entries: ", [self getName]];
    [desc appendString:[[self personalEntries] description]];
    return desc;
}

@end
