//
//  ICFormatControl.h
//  MiniTip
//
//  Created by IFAN CHU on 9/18/13.
//  Copyright (c) 2013 IFAN CHU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MTEntryTableViewCell.h"


// This class is to provide an app-wide staic method store
// as convenience
@interface ICFormatHelper : NSObject
// Format UITextField, needs to be called for each UITextField which requires formatting
// how to apply this on UITextField:
// 1. In view, drag a UITextField into View, create an IBOutlet for it
// 2. In view.m, viewDidLoad function, use this static function to format it. eg. [ICFormatControl formatUITextField:self.testUITextField];
// 3. In the UITextField's delegate, shouldChangeCharactersInRange method, return [ICFormatControl textField:textField formatUITextFieldForCurrencyInDelegate:range replacementString:string];
+ (void)formatUITextField:(UITextField *) textField;
// A method to format the UITextField with a given leftView image
+ (void)formatUITextField:(UITextField *) textField withLeftVIewImage:(NSString *)leftViewImageName;
// Format UITextField input to comform to Currency 2-digit decimal format. Need to be called inside the delegate of the UITextField shouldChangeCharactersInRange method
+ (BOOL)textField:(UITextField *)textField formatUITextFieldForCurrencyInDelegate:(NSRange)range replacementString:(NSString *)string;
// Fetch only the decimal part from customized UITextfield
+ (NSString *)getFromUITextField:(UITextField *) textField;
// Format UILabel, needs to be called for each UILabel which requires formatting
+ (void)formatUILabel:(UILabel *) label;
// get the custom font Lato
+ (UIFont *)getLatoLightFont: (CGFloat) size;
+ (UIFont *)getLatoBoldFont: (CGFloat) size;
+ (void)formatUIButton:(UIButton *)button;
+ (UIColor *)getBackgroundColor;
+ (void)setupCustomNavigationItemTitleView:(UINavigationItem *)navigationItem withCustomText:(NSString *)text;
+ (UIColor *)getCustomColorBlue;
// #aaaaaa: rgb(170, 170, 170)
+ (UIColor *)getCustomLightGray;
+ (void)cleanTextWhenTextFieldDidBeginEditing:(UITextField *)textField;
+ (MTEntryTableViewCell *)getCellFromTextField:(UITextField *)textField;
// image for shared entry
+ (UIImage *)getGroupImage;
// image for personal entry
+ (UIImage *)getPersonalImage;
// format UILabel text as bold
+ (void) formatUILabelAsBold:(UILabel *)label;

+ (void)formatLabelForButton: (UIButton *) button withHeight: (double) height andVerticalOffset:(double) offset andText: (NSString *) labelText withFont: (UIFont *) font withFontColor:(UIColor *)color withTag: (NSInteger)tagNumber;
@end
