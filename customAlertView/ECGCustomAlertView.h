//
//   ______ _____ _____
//  |  ____/ ____/ ____|
//  | |__ | |   | |  __
//  |  __|| |   | | |_ |
//  | |___| |___| |__| |
//  |______\_____\_____|
//
//
//  ECGCustomAlertView.h
//  CustomAlertViewDemo
//  弹框类 (注：带输入框效果的自定义视图,需在项目中引入IQKeyboardManager，来处理键盘盖住问题，仿JCAlertView修改)
//  Created by tan on 2016/11/8.
//  Copyright © 2016年 tantan. All rights reserved.
//

#define kMainScreenBounds [UIScreen mainScreen].bounds
#define ECGColor(r, g, b) [UIColor colorWithRed:(r/255.0) green:(g/255.0) blue:(b/255.0) alpha:1.0]
#define ECGScreenWidth [UIScreen mainScreen].bounds.size.width
#define ECGScreenHeight [UIScreen mainScreen].bounds.size.height
#define ECGAlertViewWidth ECGLayoutConstraintEqualTo6(560)
#define ECGAlertViewHeight ECGLayoutConstraintEqualTo6(300)
#define ECGAlertViewMaxHeight ECGLayoutConstraintEqualTo6(880)
#define ECGMargin 0
#define Margin ECGLayoutConstraintEqualTo6(20)
#define Line 2
#define ECGContentMargin ECGLayoutConstraintEqualTo6(30)
#define ECGTextMargin ECGLayoutConstraintEqualTo6(60)
#define ECGButtonHeight ECGLayoutConstraintEqualTo6(88)
#define ECGAlertViewTitleLabelHeight ECGLayoutConstraintEqualTo6(80)
#define ECGCellHeight ECGLayoutConstraintEqualTo6(100)
#define ECGAlertViewTitleColor ECGColor(65, 65, 65)
#define ECGAlertViewTitleFont [UIFont boldSystemFontOfSize:20]
#define ECGAlertViewContentColor ECGColor(102, 102, 102)
#define ECGAlertViewContentFont [UIFont systemFontOfSize:16]
#define ECGAlertViewContentHeight (ECGAlertViewHeight - ECGAlertViewTitleLabelHeight - ECGButtonHeight - ECGMargin * 2)
#define ECGiOS7OrLater ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7)

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "ECGLayoutConstraint.h"

typedef void(^clickHandle)(void);

typedef void(^clickHandleWithIndex)(NSInteger index);

typedef void(^rightClick)(int index,NSString *content);//index区别点击的button(左边按钮为0，右边按钮为1)，content文本内容

typedef NS_ENUM(NSInteger, ECGAlertViewButtonType) {//底部button的样式
    ECGAlertViewButtonTypeDefault = 0,
    ECGAlertViewButtonTypeCancel,
    ECGAlertViewButtonTypeWarn,
    ECGAlertViewButtonTypeNone,  //黑色字体
    ECGAlertViewButtonTypeHeight,
    ECGAlertViewButtonTypeECG    //熙健色
};

@interface ECGCustomAlertView : UIView

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, strong) NSArray *buttons;
@property (nonatomic, strong) NSArray *clicks;
@property (nonatomic, copy) clickHandleWithIndex clickWithIndex;
@property (nonatomic, strong) UIImageView *screenShotView;
@property (nonatomic, getter=isCustomAlert) BOOL customAlert;
@property (nonatomic, getter=isDismissWhenTouchBackground) BOOL dismissWhenTouchBackground;
@property (nonatomic, getter=isAlertReady) BOOL alertReady;

// ------------------------布局----------------------
- (void)setup;

//-------------Show AlertView with title and message--------------------

/**
 在屏幕下方展示一句提示信息
 
 @param text 提示信息
 @param duration 显示时间
 */
+ (void)showToast:(NSString *)text duration:(uint64_t)duration;

/**
 在屏幕下方展示一句带有自定义图片的提示信息
 
 @param text 提示信息
 @param image 自定义image
 @param bl 是否重复
 @param duration 显示时长
 */
+ (void)showCustomContainsImageToast:(NSString *)text withImage:(UIImage *)image waitDone:(BOOL)bl duration:(uint64_t)duration;

/**
 等待框

 @param content 信息文本
 */
+ (void)showWaitPopViewWithContent:(NSString *)content;

/**
 取消等待框
 */
+ (void)dismissWaitPopViewCompletion:(void(^)(void))completion;


/**
 show alertView with 1 button

 @param title <#title description#>
 @param message <#message description#>
 @param buttonType <#buttonType description#>
 @param buttonTitle <#buttonTitle description#>
 @param click <#click description#>
 */
+ (void)showOneButtonWithTitle:(NSString *)title Message:(NSString *)message ButtonType:(ECGAlertViewButtonType)buttonType ButtonTitle:(NSString *)buttonTitle Click:(clickHandle)click;

/**
 show alertView with 2 buttons

 @param title <#title description#>
 @param message <#message description#>
 @param buttonType <#buttonType description#>
 @param buttonTitle <#buttonTitle description#>
 @param click <#click description#>
 
 */
+ (void)showTwoButtonsWithTitle:(NSString *)title Message:(NSString *)message ButtonType:(ECGAlertViewButtonType)buttonType ButtonTitle:(NSString *)buttonTitle Click:(clickHandle)click ButtonType:(ECGAlertViewButtonType)buttonType ButtonTitle:(NSString *)buttonType Click:(clickHandle)click;

/**
 show alertView with greater than or equal to 3 buttons
 parameter of 'buttons' , pass by NSDictionary like @{JCAlertViewButtonTypeDefault : @"ok"}

 @param title <#title description#>
 @param message <#message description#>
 @param click <#click description#>
 @param buttons <#buttons description#>
 */
+ (void)showMultipleButtonsWithTitle:(NSString *)title Message:(NSString *)message Click:(clickHandleWithIndex)click Buttons:(NSDictionary *)buttons,... NS_REQUIRES_NIL_TERMINATION;


// ------------------------Show AlertView with TextView-----------------------------
//注：title可以传空(nil)
/**
 *  Show AlertView with TextView
 *
 *  @param title            标题(可以为空nil)
 *  @param leftButtonTitle  左边的button的标题（index==0）
 *  @param rightButtonTitle 右边的button的标题（index==1）
 *  @param placeholderText  文本框提示的内容
 *  @param tipLabelTextNum  文本框右下角字数长度
 *  @param click            传值
 */
+ (void)showContainsTextViewWithTitle:(NSString *)title leftButtonTitle:(NSString *)leftButtonTitle rightButtonTitle:(NSString *)rightButtonTitle placeholderText:(NSString *)placeholderText tipLabelTitle:(int)tipLabelTextNum click:(rightClick)click;


// ------------------------Show AlertView with customView-----------------------------

// create a alertView with customView.
// 'dismissWhenTouchBackground' : If you don't want to add a button on customView to call 'dismiss' method manually, set this property to 'YES'.
- (instancetype)initWithCustomView:(UIView *)customView dismissWhenTouchedBackground:(BOOL)dismissWhenTouchBackground;

- (void)configAlertViewPropertyWithTitle:(NSString *)title Message:(NSString *)message Buttons:(NSArray *)buttons Clicks:(NSArray *)clicks ClickWithIndex:(clickHandleWithIndex)clickWithIndex;

- (void)show;

// alert will resign keywindow in the completion.
- (void)dismissWithCompletion:(void(^)(void))completion;


@end

@interface WaitPopView : NSObject //等待框

/**
 等待框

 @param message <#message description#>
 */
+ (void)showMessage:(NSString *)message;

/**
 等待框消失
 */
+ (void)dismissWaitPopViewCompletion:(void(^)(void))completion;

@end

@interface TipsManage : NSObject //tips弹框

/**
 在屏幕下方展示一句提示信息

 @param text 提示信息
 @param duration 显示时间
 */
+ (void)showToast:(NSString *)text duration:(uint64_t)duration;

/**
 在屏幕下方展示一句带有自定义图片的提示信息

 @param text 提示信息
 @param image 自定义image
 @param bl 是否重复
 @param duration 显示时长
 */
+ (void)showCustomContainsImageToast:(NSString *)text withImage:(UIImage *)image waitDone:(BOOL)bl duration:(uint64_t)duration;

///**
// 等待框消失
// */
//+ (void)dismissWaitPopView;

@end
