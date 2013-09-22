//
//  MTEntryTableViewCell.h
//  MiniTip
//
//  Created by IFAN CHU on 11/28/12.
//  Copyright (c) 2012 IFAN CHU. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MTEntryTableViewCell : UITableViewCell
{

}
@property (weak, nonatomic) IBOutlet UITextField *entryAmountInDollar;
@property (weak, nonatomic) IBOutlet UITextField *entryForName;
@property (nonatomic) BOOL isSharedEntry;
// This idInArray indicates the cell's location in the array
// so that we can save it back to array
//@property (nonatomic) int idInArray;
@property (strong, nonatomic) IBOutlet UIButton *iconButton;

// Action for centerButton
- (IBAction)pressedIconButton:(id)sender;

+ (MTEntryTableViewCell *)getEmptyPersonalEntryCell;
+ (MTEntryTableViewCell *)getEmptySharedEntryCell;
@end
