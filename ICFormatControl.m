//
//  ICFormatControl.m
//  MiniTip
//
//  Created by IFAN CHU on 9/18/13.
//  Copyright (c) 2013 IFAN CHU. All rights reserved.
//

#import "ICFormatControl.h"
#import <QuartzCore/QuartzCore.h>

@implementation ICFormatControl
+ (void)formatUITextField:(UITextField *)textField
{
    textField.textAlignment = NSTextAlignmentRight;
    textField.backgroundColor = [UIColor clearColor];
    textField.layer.cornerRadius = 8.0f;
    textField.layer.masksToBounds = YES;
    textField.layer.borderWidth = 0.5f;
    textField.layer.borderColor = [[ICFormatControl getCustomColorBlue] CGColor];
    textField.keyboardType = UIKeyboardTypeNumberPad;
    [textField setFont: [ICFormatControl getLatoFont:textField.font.pointSize]];
    textField.borderStyle = UITextBorderStyleNone;
    textField.textColor = [ICFormatControl getCustomColorBlue];
    
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

+ (UIFont *)getLatoFont:(CGFloat)size
{
    return [UIFont fontWithName:@"Lato" size:size];
}

+ (UIColor *)getCustomColorBlue
{
    return [UIColor colorWithRed:69.0/255.0 green:122.0/255.0 blue:177.0/255.0 alpha:1.0f];
}

+ (void)formatUILabel:(UILabel *)label
{
    
}
@end
