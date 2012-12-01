//
//  MTEntryItem.m
//  MiniTip
//
//  Created by IFAN CHU on 11/29/12.
//  Copyright (c) 2012 IFAN CHU. All rights reserved.
//

#import "MTEntryItem.h"

@implementation MTEntryItem
@synthesize entryAmountInDollar, entryForName, isSharedEntry;

+ (id)getEmptyPersonalEntry
{
    return [[MTEntryItem alloc] initWithEntryForName:@"" entryAmountInDollar:@"" isSharedEntry:NO];
}

+ (id)getEmptySharedEntry
{
    return [[MTEntryItem alloc] initWithEntryForName:@"" entryAmountInDollar:@"" isSharedEntry:YES];
}

+ (id)getInvisibleEntry
{
    MTEntryItem *i = [MTEntryItem getEmptyPersonalEntry];
    i.isInvisible = YES;
    return i;
}

- (id)initWithEntryForName:(NSString *)aEntryForName entryAmountInDollar:(NSString *)aEntryAmountInDollar isSharedEntry:(BOOL)aIsSharedEntry
{
    self = [super init];
    
    if (self) {
        [self setEntryAmountInDollar:aEntryAmountInDollar];
        [self setEntryForName:aEntryForName];
        [self setIsSharedEntry:aIsSharedEntry];
        [self setIsInvisible:NO];
    }
    return self;
}

- (NSString *)description
{
    NSMutableString *desc = [[NSMutableString alloc] initWithString:@""];
    
    if(isSharedEntry)
        [desc appendString:@"A shared entry"];
    else{
        [desc appendFormat:@"%@ for %@", @"A personal entry", entryForName];
    }
    
    [desc appendFormat:@" costs %@", entryAmountInDollar];
    
    return desc;
}

@end
