//
//   ______ _____ _____
//  |  ____/ ____/ ____|
//  | |__ | |   | |  __
//  |  __|| |   | | |_ |
//  | |___| |___| |__| |
//  |______\_____\_____|
//
//
//  CustomAlertController.h
//  SnapEcgDoctor
//
//  Created by tan on 16/7/20.
//  Copyright © 2016年 baotiao ni. All rights reserved.
//

#import <UIKit/UIKit.h>

//typedef void(^CustomBlock)(NSString *str1,NSString *str2,NSString *str3);
typedef void(^Completed) (NSMutableArray * arr);


@interface CustomAlertController : UIViewController

/** 设置alertView背景色 */
@property (nonatomic, copy) UIColor *alertBackgroundColor;
/** 设置确定按钮背景色 */
@property (nonatomic, copy) UIColor *btnConfirmBackgroundColor;
/** 设置取消按钮背景色 */
@property (nonatomic, copy) UIColor *btnCancelBackgroundColor;
/** 设置message字体颜色 */
@property (nonatomic, copy) UIColor *messageColor;





/** 创建单例 */
+(instancetype)shareAlertController;
/** 弹出alertView以及点击确定回调的block */
- (void)alertViewControllerWithTitle:(NSString *)title btnTitles:(NSArray *)btnTitleArr dataArr:(NSArray *)inputArr andLeftBlock:(Completed)leftBlock rightBlock:(Completed)rightBlock;
- (void)dismissListView;
@end
