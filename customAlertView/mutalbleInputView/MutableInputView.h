//
//  MutableInputView.h
//  ECGCustomAlertView
//
//  Created by tan on 2017/3/30.
//  Copyright © 2017年 tantan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MutableInputViewController.h"

@interface MutableInputView : NSObject

+ (instancetype)shareInstancetype;

- (void)showMutableInputViewWithUIViewController:(UIViewController *)viewController Title:(NSString *)title btnTitles:(NSArray *)btnTitleArr dataArr:(NSArray *)inputArr andLeftBlock:(Completed)leftBlock rightBlock:(Completed)rightBlock;


- (void)dismissMutableInputView;

@end
