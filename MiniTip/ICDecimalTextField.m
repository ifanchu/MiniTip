//
//  ICDecimalTextField.m
//  MiniTip
//
//  Created by IFAN CHU on 9/17/13.
//  Copyright (c) 2013 IFAN CHU. All rights reserved.
//

#import "ICDecimalTextField.h"
#import <QuartzCore/QuartzCore.h>

@class ICInternalDecimalTextFieldDelegate;
@interface ICInternalDecimalTextFieldDelegate : NSObject<UITextFieldDelegate>
@property (nonatomic, weak) ICDecimalTextField *textField;
@end

@interface ICDecimalTextField()
@property (nonatomic, strong) ICInternalDecimalTextFieldDelegate *customDelegate;
@end

@implementation ICDecimalTextField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self customInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]){
        [self customInit];
    }
    return self;
}

- (id)init{
    self = [super init];
    if (self) {
        [self customInit];
    }
    return self;
}

- (void) customInit{
    self.customDelegate = [[ICInternalDecimalTextFieldDelegate alloc] init];
    self.customDelegate.textField = self;
    self.delegate = self.customDelegate;
    self.textAlignment = NSTextAlignmentRight;
    self.backgroundColor = [UIColor clearColor];
    self.layer.cornerRadius = 8.0f;
    self.layer.masksToBounds = YES;
    self.layer.borderWidth = 1.0f;
    self.layer.borderColor = [[UIColor blueColor]CGColor];
    self.keyboardType = UIKeyboardTypeNumberPad;
}

@end

@implementation ICInternalDecimalTextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    NSString *text = [textField.text stringByReplacingCharactersInRange:range withString:string];
    text = [text stringByReplacingOccurrencesOfString:@"$" withString:@""];
    text = [text stringByReplacingOccurrencesOfString:@"." withString:@""];
    double number = [text intValue] * 0.01;
    
    textField.text = [NSString stringWithFormat:@"%@%.2lf", @"$", number];
    return NO;
}

@end