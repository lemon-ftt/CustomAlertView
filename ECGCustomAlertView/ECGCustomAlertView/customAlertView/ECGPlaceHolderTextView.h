//
//   ______ _____ _____
//  |  ____/ ____/ ____|
//  | |__ | |   | |  __
//  |  __|| |   | | |_ |
//  | |___| |___| |__| |
//  |______\_____\_____|
//
//
//  ECGPlaceHolderTextView.h
//  CustomAlertViewDemo
//  带有提示输入的TextView
//  Created by tan on 2016/11/8.
//  Copyright © 2016年 tantan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ECGPlaceHolderTextView : UITextView

@property (nonatomic, strong) NSString *placeholder;
@property (nonatomic, strong) UIColor *placeholderColor;

-(void)textChanged:(NSNotification*)notification;

@end
