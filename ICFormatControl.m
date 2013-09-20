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

+ (void)formatUIButton:(UIButton *)button
{
    [ICFormatControl formatUILabel:button.titleLabel];
    button.backgroundColor = [UIColor clearColor];
}

+ (void)formatUILabel:(UILabel *)label
{
//    [label setFont: [ICFormatControl getLatoFont:label.font.pointSize]];
    label.font = [ICFormatControl getLatoFont:label.font.pointSize];
    label.textColor = [ICFormatControl getCustomColorBlue];
    label.minimumScaleFactor = 0.5;
    label.minimumFontSize = 10;
}

+ (void)formatUITextField:(UITextField *)textField
{
    textField.textAlignment = NSTextAlignmentRight;
    textField.backgroundColor = [UIColor clearColor];
//    textField.borderStyle = UITextBorderStyleNone;
    textField.layer.cornerRadius = 8.0f;
    textField.layer.masksToBounds = YES;
    textField.layer.borderWidth = 0.5f;
    textField.layer.borderColor = [[ICFormatControl getCustomColorBlue] CGColor];
    CGRect frameRect = textField.frame;
    frameRect.size.height = 40;
//    frameRect.size.width = 230;
    textField.frame = frameRect;
    textField.keyboardType = UIKeyboardTypeNumberPad;
    textField.font = [ICFormatControl getLatoFont:textField.font.pointSize];
//    [textField setFont: [ICFormatControl getLatoFont:textField.font.pointSize]];
        textField.textColor = [ICFormatControl getCustomColorBlue];
//    textField.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);
    
}

+ (NSString *)getFromUITextField:(UITextField *)textField
{
    return [textField.text stringByReplacingOccurrencesOfString:@"$" withString:@""];
}

+ (void)formatUITextField:(UITextField *)textField withLeftVIewImage:(NSString *)leftViewImageName
{
    [ICFormatControl formatUITextField:textField];
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

+ (UIFont *)getLatoFont:(CGFloat)size
{
    return [UIFont fontWithName:@"Lato" size:size];
}

+ (UIColor *)getCustomColorBlue
{
    return [UIColor colorWithRed:69.0/255.0 green:122.0/255.0 blue:177.0/255.0 alpha:1.0f];
}

+ (UIColor *)getBackgroundColor
{
    return [UIColor colorWithPatternImage:[UIImage imageNamed:@"paper_3.png"]];
}

+ (void)setupCustomNavigationItemTitleView:(UINavigationItem *)navigationItem withCustomText:(NSString *)text
{
    CGRect frame = CGRectMake(0, 0, 400, 44);
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.font = [UIFont boldSystemFontOfSize:30.0];
    [ICFormatControl formatUILabel:label];
    label.text = text;
    navigationItem.titleView = label;
}
@end
