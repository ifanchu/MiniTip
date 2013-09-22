//
//  MTResultItem.h
//  MiniTip
//
//  Created by IFAN CHU on 11/29/12.
//  Copyright (c) 2012 IFAN CHU. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MTResultItemStore;

@interface MTResultItem : NSObject
{
}
@property (nonatomic, strong) NSMutableArray *personalEntries;

- (double)sumOfPersonalEntries;
- (double)tipForName;
- (double)portionOfName;
- (double)taxForName;
- (double)totalForName;
- (NSString *)getName;

@end
