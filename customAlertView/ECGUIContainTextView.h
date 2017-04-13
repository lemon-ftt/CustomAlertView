//
//   ______ _____ _____
//  |  ____/ ____/ ____|
//  | |__ | |   | |  __
//  |  __|| |   | | |_ |
//  | |___| |___| |__| |
//  |______\_____\_____|
//
//
//  ECGUIContainTextView.h
//  CustomAlertViewDemo
//  带输入效果的自定义视图(做弹出视图)
//  Created by tan on 2016/11/8.
//  Copyright © 2016年 tantan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ECGPlaceHolderTextView.h"

typedef void (^alertLeftBlock)(NSString *text);
typedef void (^alertRightBlock)(NSString *text);

@interface ECGUIContainTextView : UIView

@property (nonatomic, copy) alertLeftBlock leftBlock;
@property (nonatomic, copy) alertRightBlock rightBlock;

@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)ECGPlaceHolderTextView *contentTextView;
@property(nonatomic,strong)UIButton *leftButton,*rightButton;
@property(nonatomic,strong)UILabel *tipLabel;

-(instancetype)initPagesViewWithTitle:(NSString *)title leftButtonTitle:(NSString *)leftButtonTitle rightButtonTitle:(NSString *)rightButtonTitle placeholderText:(NSString *)placeholderText tipLabelTitle:(int)tipLabelTextNum;

@end
