//
//  MutableInputViewController.h
//  ECGCustomAlertView
//
//  Created by tan on 2017/3/30.
//  Copyright © 2017年 tantan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^Completed) (NSMutableArray * arr);

@interface MutableInputViewController : UIViewController

/** 创建单例 */
+(instancetype)shareAlertController;
/** 弹出alertView以及点击确定回调的block */
- (void)alertViewControllerWithTitle:(NSString *)title btnTitles:(NSArray *)btnTitleArr dataArr:(NSArray *)inputArr andLeftBlock:(Completed)leftBlock rightBlock:(Completed)rightBlock;
- (void)dismissListView;

@end
