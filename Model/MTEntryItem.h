//
//  MTEntryItem.h
//  MiniTip
//
//  Created by IFAN CHU on 11/29/12.
//  Copyright (c) 2012 IFAN CHU. All rights reserved.
//

#import <Foundation/Foundation.h>

// Each entry represents a meal for a person
@interface MTEntryItem : NSObject
{
}
+ (id)getEmptyPersonalEntry;
+ (id)getEmptySharedEntry;
- (id)initWithEntryForName:(NSString *)aEntryForName entryAmountInDollar:(NSString *)aEntryAmountInDollar isSharedEntry:(BOOL)aIsSharedEntry;

// The meal is for forName
@property (nonatomic, copy) NSString *entryForName;
// The meal costs amountInDollars
@property (nonatomic, copy) NSString *entryAmountInDollar;
@property (nonatomic) BOOL isSharedEntry;

@end
