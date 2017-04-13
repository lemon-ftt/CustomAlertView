//
//  ECGCustomAlertView+MultableInputView.h
//  ECGCustomAlertView
//
//  Created by tan on 2017/3/24.
//  Copyright © 2017年 tantan. All rights reserved.
//

#import "ECGCustomAlertView.h"

typedef void(^Complete) (NSMutableArray * arr);

@interface ECGCustomAlertView (MultableInputView)

/**
 展示带有输入框的列表弹框

 @param title 标题
 @param arr 下边两个按钮的标题
 @param dataArr 数据源数组存放指定的model（ListModel对象）
 @param complete 返回修改过的model数组
 */
+ (void)showMutableInputViewWithTitle:(NSString *)title btnTitles:(NSArray *)arr dataArr:(NSArray *)dataArr leftButtonCompelete:(Complete)leftCompelete rightButtonCompelete:(Complete)rightCompelete;



@end

//@interface MultableInputView : UIView<UITableViewDelegate,UITableViewDataSource>
//@property (nonatomic, strong) NSArray *buttonTitleArr;
//@property (nonatomic,strong) NSArray *contentArr;
//
//@end
