//
//  ICFormatControl.m
//  MiniTip
//
//  Created by IFAN CHU on 9/18/13.
//  Copyright (c) 2013 IFAN CHU. All rights reserved.
//

#import "ICFormatHelper.h"
#import <QuartzCore/QuartzCore.h>
#import "MTEntryTableViewCell.h"

@implementation ICFormatHelper

+ (void)formatUIButton:(UIButton *)button
{
    [ICFormatHelper formatUILabel:button.titleLabel];
    button.backgroundColor = [UIColor clearColor];
}

+ (void)formatUILabel:(UILabel *)label
{
//    [label setFont: [ICFormatControl getLatoFont:label.font.pointSize]];
    label.font = [ICFormatHelper getLatoLightFont:label.font.pointSize];
    label.textColor = [ICFormatHelper getCustomColorBlue];
    label.minimumScaleFactor = 0.5;
}

+ (void)formatUILabelAsBold:(UILabel *)label
{
    [ICFormatHelper formatUILabel:label];
    label.font = [ICFormatHelper getLatoBoldFont:label.font.pointSize];
}

+ (void)formatUITextField:(UITextField *)textField
{
    textField.textAlignment = NSTextAlignmentRight;
    textField.backgroundColor = [UIColor clearColor];
    textField.borderStyle = UITextBorderStyleNone;
    textField.layer.cornerRadius = 8.0f;
    textField.layer.masksToBounds = YES;
    textField.layer.borderWidth = 0.5f;
    textField.layer.borderColor = [[ICFormatHelper getCustomColorBlue] CGColor];
    CGRect frameRect = textField.frame;
    textField.layer.borderColor = [[UIColor clearColor] CGColor];
    frameRect.size.height = 40;
//    frameRect.size.width = 230;
    textField.frame = frameRect;
    textField.keyboardType = UIKeyboardTypeNumberPad;
    textField.font = [ICFormatHelper getLatoLightFont:textField.font.pointSize];
//    [textField setFont: [ICFormatControl getLatoFont:textField.font.pointSize]];
    textField.textColor = [ICFormatHelper getCustomColorBlue];
//    textField.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);

}

+ (NSString *)getFromUITextField:(UITextField *)textField
{
    return [textField.text stringByReplacingOccurrencesOfString:@"$" withString:@""];
}

+ (void)formatUITextField:(UITextField *)textField withLeftVIewImage:(NSString *)leftViewImageName
{
    [ICFormatHelper formatUITextField:textField];
    [textField setLeftView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:leftViewImageName]]];
    [textField setLeftViewMode:UITextFieldViewModeAlways];
}

+ (BOOL)textField:(UITextField *)textField formatUITextFieldForCurrencyInDelegate:(NSRange)range replacementString:(NSString *)string
{
    NSString *text = [textField.text stringByReplacingCharactersInRange:range withString:string];
    text = [text stringByReplacingOccurrencesOfString:@"." withString:@""];
    text = [text stringByReplacingOccurrencesOfString:@"$" withString:@""];
    double number = [text intValue] * 0.01;
    textField.text = [NSString stringWithFormat:@"%@%.2lf", @"$", number];
    return NO;
}

+ (UIFont *)getLatoLightFont:(CGFloat)size
{
    return [UIFont fontWithName:@"Lato-Light" size:size];
}

+ (UIFont *)getLatoBoldFont:(CGFloat)size
{
    return [UIFont fontWithName:@"Lato-Bold" size:size];
}

+ (UIColor *)getCustomColorBlue
{
    return [UIColor colorWithRed:69.0/255.0 green:122.0/255.0 blue:177.0/255.0 alpha:1.0f];
}

+ (UIColor *)getCustomLightGray
{
    return [UIColor colorWithRed:170.0/255.0 green:170.0/255.0 blue:170.0/255.0 alpha:1.0f];
}

+ (UIColor *)getBackgroundColor
{
    return [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
}

+ (void)setupCustomNavigationItemTitleView:(UINavigationItem *)navigationItem withCustomText:(NSString *)text
{
    CGRect frame = CGRectMake(0, 0, 400, 44);
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.font = [UIFont boldSystemFontOfSize:30.0];
    [ICFormatHelper formatUILabel:label];
    label.text = text;
    navigationItem.titleView = label;
}

+ (void)cleanTextWhenTextFieldDidBeginEditing:(UITextField *)textField
{
    textField.text = @"";
}

+ (MTEntryTableViewCell *)getCellFromTextField:(UITextField *)textField
{
    return (MTEntryTableViewCell *)[[[textField superview] superview] superview];
}

+ (UIImage *)getGroupImage
{
    return [UIImage imageNamed:@"group-128"];
}

+ (UIImage *)getPersonalImage
{
    return [UIImage imageNamed:@"user_male-128"];
}

// code from http://stackoverflow.com/questions/5864383/ios-uibutton-with-multiple-labels
// Formats a label to add to a button.  Supports multiline buttons
// Parameters:
// button - the button to add the label to
// height - height of the label.  usual value is 44
// offset - the offset from the top of the button
// labelText - the text for the label
// color - color of the text
// formatAsBold - YES = bold NO = normal weight
// tagNumber - tag for the label

+ (void)formatLabelForButton:(UIButton *)button withHeight:(double)height andVerticalOffset:(double)offset andText:(NSString *)labelText withFont:(UIFont *)font withFontColor:(UIColor *)color withTag:(NSInteger)tagNumber
{
    
    // Get width of button
    double buttonWidth= button.frame.size.width;
    
    // Initialize buttonLabel
    UILabel *buttonLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, offset, buttonWidth, height)];
    
    // Set font
    buttonLabel.font = font;
    
    // set font color of label
    buttonLabel.textColor = color;
    
    // Set background color, text, tag, and font
    buttonLabel.backgroundColor = [UIColor clearColor];
    buttonLabel.text = labelText;
    buttonLabel.tag = tagNumber;
    
    // Center label
    buttonLabel.textAlignment = NSTextAlignmentCenter;
    
    // Add label to button
    [button addSubview:buttonLabel];
} // End formatLabelForButton
@end
