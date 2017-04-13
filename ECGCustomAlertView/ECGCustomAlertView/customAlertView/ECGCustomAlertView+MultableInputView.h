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

+ (void)showMutableInputViewWithTitle:(NSString *)title btnTitles:(NSArray *)arr dataArr:(NSArray *)dataArr leftButtonCompelete:(Complete)leftCompelete rightButtonCompelete:(Complete)rightCompelete;



@end

//@interface MultableInputView : UIView<UITableViewDelegate,UITableViewDataSource>
//@property (nonatomic, strong) NSArray *buttonTitleArr;
//@property (nonatomic,strong) NSArray *contentArr;
//
//@end
