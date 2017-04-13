//
//   ______ _____ _____
//  |  ____/ ____/ ____|
//  | |__ | |   | |  __
//  |  __|| |   | | |_ |
//  | |___| |___| |__| |
//  |______\_____\_____|
//
//
//  ECGLoadsAlertViewController.h
//  CustomAlertViewDemo
//  承载alertView的容器
//  Created by tan on 2016/11/8.
//  Copyright © 2016年 tantan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ECGCustomAlertView.h"

UIKIT_EXTERN NSString *const ECGAlertViewWillShowNotification;
UIKIT_EXTERN NSString *const ECGAlertViewDidShowNotification;
UIKIT_EXTERN NSString *const ECGAlertViewWillDismissNotification;
UIKIT_EXTERN NSString *const ECGAlertViewDidDismissNotification;

@class ECGLoadsAlertViewController;

@protocol ECGLoadsAlertViewControllerDelegate <NSObject>

@optional
- (void)coverViewTouched;

@end

@interface ECGLoadsAlertViewController : UIViewController

@property (nonatomic, strong) UIImageView *screenShotView;
@property (nonatomic, strong) UIButton *coverView;
@property (nonatomic, weak) ECGCustomAlertView *alertView;
@property (nonatomic, weak) id <ECGLoadsAlertViewControllerDelegate> delegate;

- (void)hideAlertWithCompletion:(void(^)(void))completion;
- (void)showAlert;

@end
