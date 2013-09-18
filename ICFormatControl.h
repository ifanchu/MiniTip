//
//  ICFormatControl.h
//  MiniTip
//
//  Created by IFAN CHU on 9/18/13.
//  Copyright (c) 2013 IFAN CHU. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ICFormatControl : NSObject
// Format UITextField, needs to be called for each UITextField which requires formatting
+ (void)formatUITextField:(UITextField *) textField;
// Format UITextField input to comform to Currency 2-digit decimal format. Need to be called inside the delegate of the UITextField shouldChangeCharactersInRange method
+ (BOOL)textField:(UITextField *)textField formatUITextFieldForCurrencyInDelegate:(NSRange)range replacementString:(NSString *)string;
// Format UILabel, needs to be called for each UILabel which requires formatting
+ (void)formatUILabel:(UILabel *) label;
// get the custom font Lato
+ (UIFont *)getLatoFont: (CGFloat) size;

@end
