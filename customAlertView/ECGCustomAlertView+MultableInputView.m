//
//  ECGCustomAlertView+MultableInputView.m
//  ECGCustomAlertView
//
//  Created by tan on 2017/3/24.
//  Copyright © 2017年 tantan. All rights reserved.
//

#import "ECGCustomAlertView+MultableInputView.h"
#import "ListTableViewCell.h"



@interface MultableInputView : NSObject<UITableViewDelegate,UITableViewDataSource,ListTableViewCellDelegate>

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *view;
@property (nonatomic, strong) ECGCustomAlertView *alertView;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, strong) UIView *footView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *btnTitleArr;
@property (nonatomic,strong) NSMutableArray *inputArr;
@property (nonatomic, copy) Complete leftComplete;
@property (nonatomic, copy) Complete rightComplete;
@property (nonatomic, strong) UIView *backgroundView;


+ (void)showMutableInputViewWithTitle:(NSString *)title btnTitles:(NSArray *)arr dataArr:(NSArray *)dataArr;

@end


@implementation MultableInputView

- (BOOL)isNull:(NSString *)str
{
    // 判断是否为空串
    if ([str isEqual:[NSNull null]]) {
        return YES;
    }
    else if ([str isKindOfClass:[NSNull class]])
    {
        return YES;
    }
    else if (str==nil){
        return YES;
    }
    else if ([str isEqualToString:@""] || [str isEqualToString:@"<null>"] ||[str isEqualToString:@"(null)"]){
        return YES;
    }
    
    return NO;
}

static MultableInputView* inputView;
/**
 <#Description#>
 
 @return <#return value description#>
 */
+ (MultableInputView *)shareInstance {
    if (!inputView) {
        inputView = [[MultableInputView alloc] init];
    }
    return inputView;
}

- (UIView *)backgroundView {
    if (!_backgroundView) {
        _backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ECGScreenWidth, ECGScreenHeight)];
        _backgroundView.backgroundColor = [UIColor clearColor];
    }
    return _backgroundView;
}

- (UIView *)view {
    if (!_view) {
        _view = [[UIView alloc] init];
        _view.center = self.backgroundView.center;
        _view.layer.masksToBounds = YES;
        _view.layer.cornerRadius = 8;
        _view.bounds = CGRectMake(0, 0, ECGAlertViewWidth, ECGAlertViewHeight);
        _view.backgroundColor = [UIColor whiteColor];
    }
    return _view;
}


+ (void)showMutableInputViewWithTitle:(NSString *)title btnTitles:(NSArray *)arr dataArr:(NSArray *)dataArr {
    [[MultableInputView shareInstance].backgroundView addSubview:[MultableInputView shareInstance].view];
    [[MultableInputView shareInstance] setUIWithTitle:title btnTitles:arr dataArr:dataArr];
    [MultableInputView shareInstance].alertView = [[ECGCustomAlertView alloc] initWithCustomView:[MultableInputView shareInstance].backgroundView dismissWhenTouchedBackground:NO];
    [[MultableInputView shareInstance].alertView show];
}



- (void)setUIWithTitle:(NSString *)title btnTitles:(NSArray *)btnTitles dataArr:(NSArray *)dataArr {
    if (btnTitles && btnTitles.count > 0) {
        if (btnTitles.count == 2) {
            self.btnTitleArr = btnTitles;
        }else {
            self.btnTitleArr = @[@"取消",@"确定"];
        }
    }else {
        self.btnTitleArr = @[@"取消",@"确定"];
    }
    
    self.inputArr = [NSMutableArray arrayWithArray:dataArr];
    _titleLabel = [[UILabel alloc]init];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.numberOfLines = 0;
    _titleLabel.font = [UIFont systemFontOfSize:16];
    _titleLabel.center = CGPointMake(CGRectGetWidth(self.view.frame)/2, (CGRectGetHeight(self.view.frame)-100-20)/2+100);
    int top = 0;
    if (![self isNull:title]) {
        top = ECGContentMargin * 2;
        CGSize titleSize = [title boundingRectWithSize:CGSizeMake(ECGAlertViewWidth-10, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:_titleLabel.font} context:nil].size;
        _titleLabel.text = title;
        _titleLabel.frame = CGRectMake(Margin, ECGContentMargin, CGRectGetWidth(self.view.frame)-Margin*2,titleSize.height);
    }else {
        top = ECGContentMargin;
        _titleLabel.text = @"";
        _titleLabel.frame = CGRectZero;
    }
    
    [self.view addSubview:_titleLabel];
    
    [self updateViewLayoutWith:dataArr.count top:top];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(_titleLabel.frame) + top, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-CGRectGetHeight(_titleLabel.frame)-top) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = self.footView;
    _tableView.scrollEnabled = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:_tableView];
    
    
}

- (void)updateViewLayoutWith:(NSInteger)count top:(int)top{
    if (count > 6) {
        self.view.center = self.backgroundView.center;
        self.view.bounds = CGRectMake(0, 0, ECGAlertViewWidth, ECGScreenHeight-ECGAlertViewHeight);
    }else {
        self.view.center = self.backgroundView.center;
        self.view.bounds = CGRectMake(0, 0, ECGAlertViewWidth, ECGCellHeight*count+ECGButtonHeight+top+CGRectGetHeight(self.titleLabel.frame));
    }
}



- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.inputArr.count;
//    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[ListTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.delegate = self;
    [cell setupUIWithIndex:indexPath.row];
    [cell setDataWith:self.inputArr[indexPath.row]];
    return cell;
}

#pragma ListTableViewCellDelegate 

- (void)callbackInputContent:(NSString *)text index:(NSInteger)index {
    NSLog(@"%@---%ld",text,(long)index);
    ListModel *model = self.inputArr[index-1000];
    NSLog(@"input%@",self.inputArr);
    model.content = text;
    [self.inputArr replaceObjectAtIndex:index-1000 withObject:model];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return ECGCellHeight;
}

- (UIView *)footView {
    if (!_footView) {
        _footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ECGAlertViewWidth, ECGButtonHeight)];
        _footView.backgroundColor = [UIColor whiteColor];
        
        CGFloat btnWidth = CGRectGetWidth(_footView.frame)/2 - ECGMargin * 1.5;
        
        //增加两条线
        UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(ECGMargin, ECGMargin, CGRectGetWidth(_footView.frame), 0.3)];
        lineView.backgroundColor=[UIColor grayColor];
        [_footView addSubview:lineView];
        
        UIView *seperateLine=[[UIView alloc]initWithFrame:CGRectMake(ECGMargin + (ECGMargin + btnWidth), _footView.frame.size.height - ECGButtonHeight - ECGMargin,0.3, ECGButtonHeight)];
        seperateLine.backgroundColor=[UIColor grayColor];
        [_footView addSubview:seperateLine];
        
        for (int i = 0; i < 2; i++) {
            
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(ECGMargin + (ECGMargin + btnWidth) * i, _footView.frame.size.height - ECGButtonHeight - ECGMargin, btnWidth, ECGButtonHeight)];
            [btn setTitle:self.btnTitleArr[i] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [_footView addSubview:btn];
            btn.tag = i+500;
            [btn addTarget:self action:@selector(alertBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    return _footView;
}
    
- (void)alertBtnClick:(UIButton *)btn {
    __weak typeof(self) weakSelf = self;
    [self dismissMutableInputViewCompletion:^(NSMutableArray *inputArr) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (btn.tag == 500) {//左边按钮
                weakSelf.leftComplete(weakSelf.inputArr);
            }else {
                weakSelf.rightComplete(weakSelf.inputArr);
            }
        });
    }];
    
}

- (void)dismissMutableInputViewCompletion:(void(^)(NSMutableArray *inputArr))completion {
    __weak typeof(self) weakSelf = self;
    [self.alertView dismissWithCompletion:^{
        // 处理内容
        if (completion) {
            completion(weakSelf.inputArr);
        }
    }];
}

@end

@implementation ECGCustomAlertView (MultableInputView)

+ (void)showMutableInputViewWithTitle:(NSString *)title btnTitles:(NSArray *)arr dataArr:(NSArray *)dataArr leftButtonCompelete:(Complete)leftCompelete rightButtonCompelete:(Complete)rightCompelete{
    
    [MultableInputView showMutableInputViewWithTitle:title btnTitles:arr dataArr:dataArr];
    [MultableInputView shareInstance].leftComplete = ^(NSMutableArray *info) {
        leftCompelete(info);
    };
    [MultableInputView shareInstance].rightComplete = ^(NSMutableArray *info) {
        rightCompelete(info);
    };
    
}


@end
