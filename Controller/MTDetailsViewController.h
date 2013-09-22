//
//  MTDetailsViewController.h
//  MiniTip
//
//  Created by IFAN CHU on 11/29/12.
//  Copyright (c) 2012 IFAN CHU. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MTResultItem;
@interface MTDetailsViewController : UITableViewController
{
    
}
- (id)initWithResultItem:(MTResultItem *)aResultItem;
@property (nonatomic, weak) MTResultItem *resultItem;
@end
