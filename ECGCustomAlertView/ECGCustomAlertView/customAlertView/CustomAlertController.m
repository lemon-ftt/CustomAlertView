//
//   ______ _____ _____
//  |  ____/ ____/ ____|
//  | |__ | |   | |  __
//  |  __|| |   | | |_ |
//  | |___| |___| |__| |
//  |______\_____\_____|
//
//
//  CustomAlertController.m
//  SnapEcgDoctor
//
//  Created by tan on 16/7/20.
//  Copyright © 2016年 baotiao ni. All rights reserved.
//

#import "CustomAlertController.h"
//#import "ECGMacro.h"
//#import "ECGConst.h"
#import "Masonry.h"
#import "ECGCustomAlertView.h"
#import "ListTableViewCell.h"




/** 屏幕尺寸 */
#define kMainScreenBounds [UIScreen mainScreen].bounds

@interface CustomAlertController ()<UITableViewDelegate,UITableViewDataSource,ListTableViewCellDelegate>
{
    int topInterval;
}

/** 蒙版 */
@property (nonatomic, strong) UIView *coverView;
/** 弹框 */
@property (nonatomic, strong) UIView *showView;
@property (nonatomic, strong) NSArray *btnTitleArr;
@property (nonatomic, strong) NSMutableArray *inputArr;
@property (nonatomic, copy) NSString *topTitle;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *footView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) Completed leftCompleted;
@property (nonatomic, copy) Completed rightCompleted;
@end

@implementation CustomAlertController

//-(instancetype)initWithTitle:(NSString *)title btnTitles:(NSArray *)btnTitleArr dataArr:(NSArray *)inputArr {
//    self = [super init];
//    if (self) {
//        _topTitle = title;
//        self.btnTitleArr = btnTitleArr;
//        [self.inputArr addObjectsFromArray:inputArr];
//    }
//    return self;
//}

static CustomAlertController * instance = nil;
+(instancetype)shareAlertController{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[CustomAlertController alloc] init];
    });
    return instance;
}

-(NSArray *)btnTitleArr {
    if (!_btnTitleArr) {
        _btnTitleArr = [[NSArray alloc]init];
    }
    return _btnTitleArr;
}

-(NSArray *)inputArr {
    if (!_inputArr) {
        _inputArr = [NSMutableArray array];
    }
    return _inputArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKB)];
    [self.view addGestureRecognizer:tap];
    
}

-(UIView *)coverView {
    if (!_coverView) {
        _coverView = [[UIView alloc] initWithFrame:kMainScreenBounds];
    }
    return _coverView;
}

-(UIView *)showView {
    if (!_showView) {
        _showView = [[UIView alloc] init];
        _showView.layer.masksToBounds = YES;
        _showView.layer.cornerRadius = 8;
        _showView.center = self.view.center;
        _showView.bounds = CGRectMake(0, 0, ECGAlertViewWidth, ECGAlertViewHeight);
        _showView.backgroundColor = [UIColor whiteColor];
    }
    return _showView;
}

-(UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.numberOfLines = 0;
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.center = CGPointMake(CGRectGetWidth(self.showView.frame)/2, (CGRectGetHeight(self.showView.frame)-100-20)/2+100);
    }
    return _titleLabel;
}

-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(self.titleLabel.frame) + topInterval, CGRectGetWidth(self.showView.frame), CGRectGetHeight(self.showView.frame)-CGRectGetHeight(self.titleLabel.frame)-topInterval) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
    }
    return _tableView;
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
    
    [self.inputArr addObjectsFromArray:dataArr];
    
    topInterval = 0;
    if (![self isNull:title]) {
        topInterval = ECGContentMargin * 2;
        CGSize titleSize = [title boundingRectWithSize:CGSizeMake(ECGAlertViewWidth-10, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.titleLabel.font} context:nil].size;
        self.titleLabel.text = title;
        self.titleLabel.frame = CGRectMake(Margin, ECGContentMargin, CGRectGetWidth(self.showView.frame)-Margin*2,titleSize.height);
    }else {
        topInterval = ECGContentMargin;
        self.titleLabel.text = @"";
        self.titleLabel.frame = CGRectZero;
    }
    
    [self.showView addSubview:self.titleLabel];
    
    [self updateViewLayoutWith:dataArr.count top:topInterval];
    
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = self.footView;
    self.tableView.scrollEnabled = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.showView addSubview:self.tableView];
    
    
}

- (void)updateViewLayoutWith:(NSInteger)count top:(int)top{
    if (count >= 5) {
        self.showView.center = self.view.center;
        self.showView.bounds = CGRectMake(0, 0, ECGAlertViewWidth, ECGScreenHeight-ECGAlertViewHeight);
    }else {
        self.showView.center = self.view.center;
        self.showView.bounds = CGRectMake(0, 0, ECGAlertViewWidth, ECGCellHeight*count+ECGButtonHeight+top+CGRectGetHeight(self.titleLabel.frame));
    }
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.inputArr.count;
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





- (void)alertViewControllerWithTitle:(NSString *)title btnTitles:(NSArray *)btnTitleArr dataArr:(NSArray *)inputArr andLeftBlock:(Completed)leftBlock rightBlock:(Completed)rightBlock {
    self.leftCompleted = leftBlock;
    self.rightCompleted = rightBlock;
    //创建蒙版
    [self.view addSubview:self.coverView];
    self.coverView.backgroundColor = [UIColor whiteColor];
    self.coverView.alpha = 0;
    [self.view addSubview:self.showView];
    [self setUIWithTitle:title btnTitles:btnTitleArr dataArr:inputArr];

    
}


/** 点击确定 or 取消触发事件 */
-(void)alertBtnClick:(UIButton *)sender{
    [self dismissKB];
    if (sender.tag == 500) {//左边按钮
        self.leftCompleted(self.inputArr);
        [ECGCustomAlertView showToast:@"测试" duration:3];
    }else {
        self.rightCompleted(self.inputArr);
    }
    
}

/**
 消失弹框
 */
- (void)dismissListView {
    [self dismissViewControllerAnimated:NO completion:nil];
    [self.showView removeFromSuperview];
}

- (UIColor *)alertBackgroundColor{
    
    if (_alertBackgroundColor == nil) {
        _alertBackgroundColor = [UIColor colorWithRed:249/255.0 green:249/255.0 blue:249/255.0 alpha:1];
    }
    return _alertBackgroundColor;
}

/** 确定按钮背景色 */
- (UIColor *)btnConfirmBackgroundColor{
    
    if (_btnConfirmBackgroundColor == nil) {
        _btnConfirmBackgroundColor = [UIColor orangeColor];
    }
    return _btnConfirmBackgroundColor;
}

/** 取消按钮背景色 */
- (UIColor *)btnCancelBackgroundColor{
    
    if (_btnCancelBackgroundColor == nil) {
        _btnCancelBackgroundColor = [UIColor blueColor];
    }
    return _btnCancelBackgroundColor;
}

/** message字体颜色 */
- (UIColor *)messageColor{
    
    if (_messageColor == nil) {
        _messageColor = [UIColor blackColor];
    }
    return _messageColor;
}

- (void)dismissKB {
    [self.view endEditing:YES];
}




@end
