//
//   ______ _____ _____
//  |  ____/ ____/ ____|
//  | |__ | |   | |  __
//  |  __|| |   | | |_ |
//  | |___| |___| |__| |
//  |______\_____\_____|
//
//
//  ECGCustomAlertView.m
//  CustomAlertViewDemo
//
//  Created by tan on 2016/11/8.
//  Copyright © 2016年 tantan. All rights reserved.
//

#import "ECGCustomAlertView.h"
#import "ECGLoadsAlertViewController.h"
#import "ECGUIContainTextView.h"
//#import "Masonry.h"


@interface ECGCustomAlertView () <ECGLoadsAlertViewControllerDelegate,WaitPopViewDelegate>



@end

@interface jCSingleTon : NSObject //处理window层级的类

@property (nonatomic, strong) UIWindow *backgroundWindow;
@property (nonatomic, weak) UIWindow *oldKeyWindow;
@property (nonatomic, strong) NSMutableArray *alertStack;
@property (nonatomic, strong) ECGCustomAlertView *previousAlert;

@end

@interface WaitPopView () //等待框

@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIView *view;
@property (nonatomic, strong) ECGCustomAlertView *alertView;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, strong) UIActivityIndicatorView *actView;
@property (nonatomic, strong) UIView *coverView;

@end

@implementation WaitPopView

static WaitPopView* kInstance;
/**
 <#Description#>

 @return <#return value description#>
 */
+ (WaitPopView *)shareInstance {
    if (!kInstance) {
        kInstance = [[WaitPopView alloc] init];
    }
    return kInstance;
}
//[[UIApplication sharedApplication].keyWindow addSubview:bView];
- (UIView *)coverView {
    if (!_coverView) {
        _coverView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _coverView.backgroundColor = [UIColor colorWithRed:(5/255.0) green:(0/255.0) blue:(10/255.0) alpha:0.5];
        [_coverView addSubview:self.view];
        
        // 单击的 Recognizer
        UITapGestureRecognizer* singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(SingleTap:)];
        //点击的次数
        singleRecognizer.numberOfTapsRequired = 1; // 单击
        
        //给self.view添加一个手势监测；
        
        [_coverView addGestureRecognizer:singleRecognizer];
    }
    return _coverView;
}

- (void)SingleTap:(UITapGestureRecognizer*)recognizer {
    NSLog(@"屏幕被点击了");
    if (_delegate && [_delegate respondsToSelector:@selector(touchCancel)]) {
        [_delegate touchCancel];
        [self dismissWaitPopView];
    }
}

- (UIView *)view {
    if (!_view) {
        _view = [[UIView alloc] init];
        _view.center = self.coverView.center;
        _view.bounds = CGRectMake(0, 0, ECGAlertViewWidth, ECGAlertViewHeight);
        _view.backgroundColor = [UIColor whiteColor];
        
        _actView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _actView.center = CGPointMake(CGRectGetWidth(_view.frame)/2, 20+30);
        CGAffineTransform transform = CGAffineTransformMakeScale(1.7f, 1.7f);
        _actView.transform = transform;
        _actView.bounds = CGRectMake(0, 0, 60, 60);
        [_view addSubview:_actView];
        
        _contentLabel = [[UILabel alloc]init];
        _contentLabel.textAlignment = NSTextAlignmentCenter;
        _contentLabel.numberOfLines = 0;
        _contentLabel.font = [UIFont systemFontOfSize:16];
        _contentLabel.center = CGPointMake(CGRectGetWidth(_view.frame)/2, (CGRectGetHeight(_view.frame)-100-20)/2+100);
        _contentLabel.bounds = CGRectMake(0, 0, CGRectGetWidth(_view.frame)-10, CGRectGetHeight(_view.frame)-100-20);
        [_view addSubview:_contentLabel];
        
    }
    return _view;
}

//- (void)setContentLabel:(UILabel *)contentLabel {
//    [self updateLayoutView];
//}
//
- (void)setContent:(NSString *)content {
    if (_content != content) {
        _content = content;
        [self updateLayout];
    }
}

- (void)updateLayout {
    
    CGSize titleSize = [self.content boundingRectWithSize:CGSizeMake(ECGAlertViewWidth-10, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.contentLabel.font} context:nil].size;
    _contentLabel.center = CGPointMake(CGRectGetWidth(_view.frame)/2, titleSize.height/2+100);
    _contentLabel.bounds = CGRectMake(0, 0, CGRectGetWidth(_view.frame)-10, titleSize.height);
    _view.bounds = CGRectMake(0, 0, ECGAlertViewWidth, CGRectGetHeight(self.contentLabel.frame)+60+60);
    
}

/**
 显示一些信息

 @param message 信息内容
 */
+ (void)showMessage:(NSString *)message {
    
    if (![WaitPopView shareInstance].coverView) {
        return;
    }

    [WaitPopView shareInstance].actView.hidden = NO;
    [[WaitPopView shareInstance].actView startAnimating];
    [WaitPopView shareInstance].content = message;
    [WaitPopView shareInstance].contentLabel.text = message;
    [[UIApplication sharedApplication].keyWindow addSubview:[WaitPopView shareInstance].coverView];
//    [WaitPopView shareInstance].alertView = [[ECGCustomAlertView alloc] initWithCustomView:[WaitPopView shareInstance].view dismissWhenTouchedBackground:NO];
//    [[WaitPopView shareInstance].alertView show];
    
//    _actView stopAnimating];
//    // 快速显示一个提示信息
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[WaitPopView shareInstance].view animated:YES];
////    hud.label.text = message;
//    [WaitPopView shareInstance].content = message;
//    [WaitPopView shareInstance].contentLabel.text = message;
//    //设置矩形框的背景颜色
//    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
//    hud.bezelView.color = [UIColor clearColor];
//    // 隐藏时候从父控件中移除
//    hud.removeFromSuperViewOnHide = YES;
////    hud.mode = MBProgressHUDModeIndeterminate;
//    hud.offset = CGPointMake(0, -([WaitPopView shareInstance].view.bounds.size.height)/2);
//    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC);
//    dispatch_after(time, dispatch_get_main_queue(), ^{
//        [self dismissWaitPopView];
//    });
    
}

/**
 显示一些信息
 
 @param message 信息内容
 */
- (void)showMessage:(NSString *)message {
    
    if (!self.coverView) {
        return;
    }
    
    self.actView.hidden = NO;
    [self.actView startAnimating];
    self.content = message;
    self.contentLabel.text = message;
    [[UIApplication sharedApplication].keyWindow addSubview:self.coverView];
    
}


- (void)dismissWaitPopView {
    [self.actView stopAnimating];
    [self.coverView removeFromSuperview];
}


@end

@interface TipsManage () //tips弹框

@end

@implementation TipsManage

/**
 在屏幕下方展示一句提示信息
 
 @param text 提示信息
 @param duration 显示时间
 */
+ (void)showToast:(NSString *)text duration:(uint64_t)duration{
//    [[UIApplication sharedApplication].keyWindow.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    hud.mode = MBProgressHUDModeText;
    //设置矩形框的背景颜色
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.color = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.62];
    hud.detailsLabel.text = text;
    hud.detailsLabel.textColor = [UIColor whiteColor];
    hud.userInteractionEnabled = NO; // 关闭 MBProgressHUD 的交互，让事件可以传递给下一层。
    hud.detailsLabel.font = [UIFont systemFontOfSize:14];
    float margin = hud.margin;
    CGSize size = [text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:hud.detailsLabel.font,NSFontAttributeName, nil]];
    hud.offset = CGPointMake(0,[UIScreen mainScreen].bounds.size.height/ 2.f - size.height-margin-5);

    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC);
    dispatch_after(time, dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
    });
}

/**
 在屏幕下方展示一句带有自定义图片的提示信息
 
 @param text 提示信息
 @param image 自定义image
 @param bl 是否重复
 @param duration 显示时长
 */
+ (void)showCustomContainsImageToast:(NSString *)text withImage:(UIImage *)image waitDone:(BOOL)bl duration:(uint64_t)duration {
    CGSize textSize = [text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14],NSFontAttributeName, nil]];
    UITextField *textField = [[UITextField alloc]init];
    UIImageView *leftImageView = [[UIImageView alloc]initWithImage:image];
    leftImageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    textField.leftView = leftImageView;
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.enabled = NO;
    textField.borderStyle = UITextBorderStyleNone;
    textField.text = [NSString stringWithFormat:@"  %@",text];
    if ((textSize.width + image.size.width)> ECGScreenWidth) {
        if (textSize.height > image.size.height) {
            textField.frame = CGRectMake(0, 0, ECGScreenWidth, textSize.height);
        }else {
            textField.frame = CGRectMake(0, 0, ECGScreenWidth, image.size.height);
        }
        
    }else {
        if (textSize.height > image.size.height) {
            textField.frame = CGRectMake(0, 0, textSize.width + image.size.width, textSize.height);
        }else {
            textField.frame = CGRectMake(0, 0, textSize.width + image.size.width, image.size.height);
        }
    }
//    [[UIApplication sharedApplication].keyWindow.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.userInteractionEnabled = NO; // 关闭 MBProgressHUD 的交互，让事件可以传递给下一层。
//    hud.label.text = text;
    hud.label.font = [UIFont systemFontOfSize:14];
    hud.customView = textField;
    hud.offset = CGPointMake(0,[UIScreen mainScreen].bounds.size.height/ 2.f - 30);
    
    if (bl) {
        //repeat and repeat
    } else {
        dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC);
        dispatch_after(time, dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
        });
    }
}

@end

@implementation jCSingleTon

+ (instancetype)shareSingleTon{
    static jCSingleTon *shareSingleTonInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        shareSingleTonInstance = [jCSingleTon new];
    });
    return shareSingleTonInstance;
}

- (UIWindow *)backgroundWindow{
    if (!_backgroundWindow) {
        _backgroundWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _backgroundWindow.windowLevel = UIWindowLevelStatusBar - 1;
    }
    return _backgroundWindow;
}

- (NSMutableArray *)alertStack{
    if (!_alertStack) {
        _alertStack = [NSMutableArray array];
    }
    return _alertStack;
}

@end

@implementation ECGCustomAlertView

static ECGCustomAlertView *alert = nil;
+(instancetype)shareInstancetype {
    if (!alert) {
        alert = [[ECGCustomAlertView alloc]init];
    }
    return alert;
}

- (NSArray *)buttons{
    if (!_buttons) {
        _buttons = [NSArray array];
    }
    return _buttons;
}

- (NSArray *)clicks{
    if (!_clicks) {
        _clicks = [NSArray array];
    }
    return _clicks;
}

- (instancetype)initWithCustomView:(UIView *)customView dismissWhenTouchedBackground:(BOOL)dismissWhenTouchBackground{
    if (self = [super initWithFrame:customView.bounds]) {
        [self addSubview:customView];
        self.layer.masksToBounds=true;
        self.layer.cornerRadius=8;
        self.center = CGPointMake(ECGScreenWidth / 2, ECGScreenHeight / 2);
        self.customAlert = YES;
        self.dismissWhenTouchBackground = dismissWhenTouchBackground;
    }
    return self;
}

- (void)show{
    [[jCSingleTon shareSingleTon].alertStack addObject:self];
    [self showAlert];
}

- (void)dismissWithCompletion:(void(^)(void))completion{
    [self dismissAlertWithCompletion:^{
        if (completion) {
            completion();
        }
    }];
}

/**
 在屏幕下方展示一句提示信息
 
 @param text 提示信息
 @param duration 显示时间
 */
+ (void)showToast:(NSString *)text duration:(uint64_t)duration {
    [TipsManage showToast:text duration:duration];
}

/**
 在屏幕下方展示一句带有自定义图片的提示信息
 
 @param text 提示信息
 @param image 自定义image
 @param bl 是否重复
 @param duration 显示时长
 */
+ (void)showCustomContainsImageToast:(NSString *)text withImage:(UIImage *)image waitDone:(BOOL)bl duration:(uint64_t)duration{
    [TipsManage showCustomContainsImageToast:text withImage:image waitDone:bl duration:duration];
}

/**
 展示等待框

 @param content <#content description#>
 */
+ (void)showWaitPopViewWithContent:(NSString *)content {
    [WaitPopView showMessage:content];
}

/**
 展示等待框-----点屏幕可以取消的
 
 @param content <#content description#>
 */
- (void)showWaitPopViewWithContent:(NSString *)content complete:(touchCancelHandle)compelete {
    self.touchCancelHandle = ^{
        compelete();
    };
    WaitPopView *wait = [WaitPopView shareInstance];
    wait.delegate = self;
    [wait showMessage:content];
}

/**
 等待框消失
 */
+ (void)dismissWaitPopView {
    WaitPopView *wait = [WaitPopView shareInstance];
    [wait dismissWaitPopView];
}

/**
 等待框消失
 */
- (void)dismissWaitPopView {
    WaitPopView *wait = [WaitPopView shareInstance];
    [wait dismissWaitPopView];
}

#pragma mark- WaitPopViewDelegate
-(void)touchCancel {
    self.touchCancelHandle();
}

+ (void)showOneButtonWithTitle:(NSString *)title Message:(NSString *)message ButtonType:(ECGAlertViewButtonType)buttonType ButtonTitle:(NSString *)buttonTitle Click:(clickHandle)click{
    id newClick = click;
    if (!newClick) {
        newClick = [NSNull null];
    }
    ECGCustomAlertView *alertView = [ECGCustomAlertView new];
    [alertView configAlertViewPropertyWithTitle:title Message:message Buttons:@[@{[NSString stringWithFormat:@"%zi", buttonType] : buttonTitle}] Clicks:@[newClick] ClickWithIndex:nil];
}

+ (void)showTwoButtonsWithTitle:(NSString *)title Message:(NSString *)message ButtonType:(ECGAlertViewButtonType)
buttonType ButtonTitle:(NSString *)buttonTitle Click:(clickHandle)click ButtonType:(ECGAlertViewButtonType)buttonType1 ButtonTitle:(NSString *)buttonTitle1 Click:(clickHandle)click1{
    id newClick = click;
    if (!newClick) {
        newClick = [NSNull null];
    }
    id newClick1 = click1;
    if (!newClick1) {
        newClick1 = [NSNull null];
    }
    ECGCustomAlertView *alertView = [ECGCustomAlertView new];
    [alertView configAlertViewPropertyWithTitle:title Message:message Buttons:@[@{[NSString stringWithFormat:@"%zi", buttonType] : buttonTitle}, @{[NSString stringWithFormat:@"%zi", buttonType1] : buttonTitle1}] Clicks:@[newClick, newClick1] ClickWithIndex:nil];
}

+ (void)showMultipleButtonsWithTitle:(NSString *)title Message:(NSString *)message Click:(clickHandleWithIndex)click Buttons:(NSDictionary *)buttons, ...{
    NSMutableArray *btnArray = [NSMutableArray array];
    NSString* curStr;
    va_list list;
    if(buttons)
    {
        [btnArray addObject:buttons];
        
        va_start(list, buttons);
        while ((curStr = va_arg(list, NSString*))) {
            [btnArray addObject:curStr];
        }
        va_end(list);
    }
    NSMutableArray *btns = [NSMutableArray array];
    for (int i = 0; i<btnArray.count; i++) {
        NSDictionary *dic = btnArray[i];
        [btns addObject:@{dic.allKeys.firstObject : dic.allValues.firstObject}];
    }
    
    ECGCustomAlertView *alertView = [ECGCustomAlertView new];
    [alertView configAlertViewPropertyWithTitle:title Message:message Buttons:btns Clicks:nil ClickWithIndex:click];
}

+ (void)showContainsTextViewWithTitle:(NSString *)title leftButtonTitle:(NSString *)leftButtonTitle rightButtonTitle:(NSString *)rightButtonTitle placeholderText:(NSString *)placeholderText tipLabelTitle:(int)tipLabelTextNum click:(rightClick)click {
    ECGUIContainTextView *myInputView = [[ECGUIContainTextView alloc]initPagesViewWithTitle:title leftButtonTitle:leftButtonTitle rightButtonTitle:rightButtonTitle placeholderText:placeholderText tipLabelTitle:tipLabelTextNum];
    ECGCustomAlertView *alertView = [[ECGCustomAlertView alloc]initWithCustomView:myInputView dismissWhenTouchedBackground:YES];
    [alertView show];
    myInputView.leftBlock=^(NSString *text)
    {
        NSLog(@"当前值：%@",text);
        click(0,text);
        [alertView dismissWithCompletion:nil];
    };
    myInputView.rightBlock=^(NSString *text)
    {
//        //可以放在外面处理
//        if (text.length==0) {
//            //ToView:weakSelf.alertView这样才会显示出来 否则会被AlertView盖住
////            [MBProgressHUD showError:@"内容没有输入" ToView:weakSelf.alertView];
//            return;
//        }
        click(1,text);
        alertView.window.windowLevel = UIWindowLevelStatusBar +1;
//        [MBProgressHUD showAutoMessage:[NSString stringWithFormat:@"当前内容为:%@",text]];
        [alertView dismissWithCompletion:nil];
    };
    
}

- (void)configAlertViewPropertyWithTitle:(NSString *)title Message:(NSString *)message Buttons:(NSArray *)buttons Clicks:(NSArray *)clicks ClickWithIndex:(clickHandleWithIndex)clickWithIndex{
    self.title = title;
    self.message = message;
    self.buttons = buttons;
    self.clicks = clicks;
    self.clickWithIndex = clickWithIndex;
    
    [[jCSingleTon shareSingleTon].alertStack addObject:self];
    
    [self showAlert];
}

- (void)showAlert{
    NSInteger count = [jCSingleTon shareSingleTon].alertStack.count;
    ECGCustomAlertView *previousAlert = nil;
    if (count > 1) {
        NSInteger index = [[jCSingleTon shareSingleTon].alertStack indexOfObject:self];
        previousAlert = [jCSingleTon shareSingleTon].alertStack[index - 1];
    }
    
    if (previousAlert && previousAlert.vc) {
        if (previousAlert.isAlertReady) {
            [previousAlert.vc hideAlertWithCompletion:^{
                [self showAlertHandle];
            }];
        } else {
            [self showAlertHandle];
        }
    } else {
        [self showAlertHandle];
    }
}

- (void)showAlertHandle{
    UIWindow *keywindow = [UIApplication sharedApplication].keyWindow;
    if (keywindow != [jCSingleTon shareSingleTon].backgroundWindow) {
        [jCSingleTon shareSingleTon].oldKeyWindow = [UIApplication sharedApplication].keyWindow;
    }
    
    ECGLoadsAlertViewController *viewController = [[ECGLoadsAlertViewController alloc] init];
    viewController.delegate = self;
    viewController.alertView = self;
    self.vc = viewController;
    
    [jCSingleTon shareSingleTon].backgroundWindow.frame = [UIScreen mainScreen].bounds;
    [[jCSingleTon shareSingleTon].backgroundWindow makeKeyAndVisible];
    [jCSingleTon shareSingleTon].backgroundWindow.rootViewController = self.vc;
    
    [self.vc showAlert];
}

- (void)coverViewTouched{
    if (self.isDismissWhenTouchBackground) {
        [self dismissAlertWithCompletion:nil];
    }
}

- (void)alertBtnClick:(UIButton *)btn{
    [self dismissAlertWithCompletion:^{
        if (self.clicks.count > 0) {
            clickHandle handle = self.clicks[btn.tag];
            if (![handle isEqual:[NSNull null]]) {
                handle();
            }
        } else {
            if (self.clickWithIndex) {
                self.clickWithIndex(btn.tag);
            }
        }
    }];
}

- (void)dismissAlertWithCompletion:(void(^)(void))completion{
    [self.vc hideAlertWithCompletion:^{
        [self stackHandle];
        
        if (completion) {
            completion();
        }
        
        NSInteger count = [jCSingleTon shareSingleTon].alertStack.count;
        if (count > 0) {
            ECGCustomAlertView *lastAlert = [jCSingleTon shareSingleTon].alertStack.lastObject;
            [lastAlert showAlert];
        }
    }];
}

- (void)stackHandle{
    [[jCSingleTon shareSingleTon].alertStack removeObject:self];
    
    NSInteger count = [jCSingleTon shareSingleTon].alertStack.count;
    if (count == 0) {
        [self toggleKeyWindow];
    }
}

- (void)toggleKeyWindow{
    [[jCSingleTon shareSingleTon].oldKeyWindow makeKeyAndVisible];
    [jCSingleTon shareSingleTon].backgroundWindow.rootViewController = nil;
    [jCSingleTon shareSingleTon].backgroundWindow.frame = CGRectZero;
}

- (void)setup{
    if (self.subviews.count > 0) {
        return;
    }
    
    if (self.isCustomAlert) {
        return;
    }
    
    self.layer.masksToBounds=true;
    self.layer.cornerRadius=8;
    
    self.frame = CGRectMake(0, 0, ECGAlertViewWidth, ECGAlertViewHeight);
    NSInteger count = self.buttons.count;
    
    if (count > 2) {
        self.frame = CGRectMake(0, 0, ECGAlertViewWidth, ECGAlertViewTitleLabelHeight + ECGAlertViewContentHeight + ECGMargin + (ECGMargin + ECGButtonHeight) * count);
    }
    self.center = CGPointMake(ECGScreenWidth / 2, ECGScreenHeight / 2);
    self.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(ECGMargin, 0, ECGAlertViewWidth - ECGMargin * 2, ECGAlertViewTitleLabelHeight)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text = self.title;
    titleLabel.textColor = ECGAlertViewTitleColor;
    titleLabel.font = ECGAlertViewTitleFont;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:titleLabel];
    
    CGFloat contentLabelYValue = ECGAlertViewTitleLabelHeight;
    if (self.title.length==0||self.title==nil) {
        contentLabelYValue=10;
    }
    
    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(ECGContentMargin, contentLabelYValue, ECGAlertViewWidth - ECGContentMargin * 2, ECGAlertViewContentHeight)];
    contentLabel.backgroundColor = [UIColor clearColor];
    contentLabel.text = self.message;
    contentLabel.textColor = ECGAlertViewContentColor;
    contentLabel.font = ECGAlertViewContentFont;
    contentLabel.numberOfLines = 0;
    contentLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:contentLabel];
    
    CGFloat contentHeight = [contentLabel sizeThatFits:CGSizeMake(ECGAlertViewWidth-ECGContentMargin*2, CGFLOAT_MAX)].height;
    
    if (contentHeight > ECGAlertViewContentHeight) {
        [contentLabel removeFromSuperview];
        
        UITextView *contentView = [[UITextView alloc] initWithFrame:CGRectMake(ECGContentMargin, contentLabelYValue, ECGAlertViewWidth - ECGContentMargin * 2, ECGAlertViewContentHeight)];
        contentView.backgroundColor = [UIColor clearColor];
        contentView.text = self.message;
        contentView.textColor = ECGAlertViewContentColor;
        contentView.font = ECGAlertViewContentFont;
        contentView.editable = NO;
        if (ECGiOS7OrLater) {
            contentView.selectable = NO;
        }
        [self addSubview:contentView];
        
        CGFloat realContentHeight = 0;
        if (ECGiOS7OrLater) {
            [contentView.layoutManager ensureLayoutForTextContainer:contentView.textContainer];
            CGRect textBounds = [contentView.layoutManager usedRectForTextContainer:contentView.textContainer];
            CGFloat height = (CGFloat)ceil(textBounds.size.height + contentView.textContainerInset.top + contentView.textContainerInset.bottom);
            realContentHeight = height;
        }else {
            realContentHeight = contentView.contentSize.height;
        }
        
        if (realContentHeight > ECGAlertViewContentHeight) {
            CGFloat remainderHeight = ECGAlertViewMaxHeight - ECGAlertViewTitleLabelHeight - ECGMargin - (ECGMargin + ECGButtonHeight) * count;
            contentHeight = realContentHeight;
            if (realContentHeight > remainderHeight) {
                contentHeight = remainderHeight;
            }
            
            CGRect frame = contentView.frame;
            frame.size.height = contentHeight;
            contentView.frame = frame;
            
            CGRect selfFrame = self.frame;
            selfFrame.size.height = selfFrame.size.height + contentHeight - ECGAlertViewContentHeight;
            self.frame = selfFrame;
            self.center = CGPointMake(ECGScreenWidth / 2, ECGScreenHeight / 2);
        }
    }
    
    if (!ECGiOS7OrLater) {
        CGRect frame = self.frame;
        frame.origin.y -= 10;
        self.frame = frame;
    }
    
    if (count == 1) {
        
        //增加线条
        UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(ECGMargin, self.frame.size.height - ECGButtonHeight - ECGMargin, ECGAlertViewWidth - ECGMargin * 2, 0.3)];
        lineView.backgroundColor=[UIColor grayColor];
        [self addSubview:lineView];
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(ECGMargin, self.frame.size.height - ECGButtonHeight - ECGMargin, ECGAlertViewWidth - ECGMargin * 2, ECGButtonHeight)];
        NSDictionary *btnDict = [self.buttons firstObject];
        [btn setTitle:[btnDict.allValues firstObject] forState:UIControlStateNormal];
        [self setButton:btn BackgroundWithButonType:[[btnDict.allKeys firstObject] integerValue]];
        [self addSubview:btn];
        btn.tag = 0;
        [btn addTarget:self action:@selector(alertBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    } else if (count == 2) {
        CGFloat btnWidth = ECGAlertViewWidth / 2 - ECGMargin * 1.5;
        
        //增加两条线
        UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(ECGMargin, self.frame.size.height - ECGButtonHeight - ECGMargin, ECGAlertViewWidth - ECGMargin * 2, 0.3)];
        lineView.backgroundColor=[UIColor grayColor];
        [self addSubview:lineView];
        
        UIView *seperateLine=[[UIView alloc]initWithFrame:CGRectMake(ECGMargin + (ECGMargin + btnWidth), self.frame.size.height - ECGButtonHeight - ECGMargin,0.3, ECGButtonHeight)];
        seperateLine.backgroundColor=[UIColor grayColor];
        [self addSubview:seperateLine];
        
        for (int i = 0; i < 2; i++) {
            
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(ECGMargin + (ECGMargin + btnWidth) * i, self.frame.size.height - ECGButtonHeight - ECGMargin, btnWidth, ECGButtonHeight)];
            NSDictionary *btnDict = self.buttons[i];
            [btn setTitle:[btnDict.allValues firstObject] forState:UIControlStateNormal];
            [self setButton:btn BackgroundWithButonType:[[btnDict.allKeys firstObject] integerValue]];
            [self addSubview:btn];
            btn.tag = i;
            [btn addTarget:self action:@selector(alertBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        }
    } else if (count > 2) {
        if (contentHeight < ECGAlertViewContentHeight) {
            contentHeight = ECGAlertViewContentHeight;
        }
        for (int i = 0; i < count; i++) {
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(ECGMargin, contentLabelYValue + contentHeight + ECGMargin + (ECGMargin + ECGButtonHeight) * i, ECGAlertViewWidth - ECGMargin * 2, ECGButtonHeight)];
            NSDictionary *btnDict = self.buttons[i];
            [btn setTitle:[btnDict.allValues firstObject] forState:UIControlStateNormal];
            [self setButton:btn BackgroundWithButonType:[[btnDict.allKeys firstObject] integerValue]];
            [self addSubview:btn];
            btn.tag = i;
            [btn addTarget:self action:@selector(alertBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
}

+ (void)layoutLandscapeAndPortrait {
    NSInteger count = [jCSingleTon shareSingleTon].alertStack.count;
    ECGCustomAlertView *previousAlert = nil;
//    if (count > 1) {
//        NSInteger index = [[jCSingleTon shareSingleTon].alertStack indexOfObject:self];
//        previousAlert = [jCSingleTon shareSingleTon].alertStack[index - 1];
//    }
    
    if (count > 0) {
        previousAlert = [jCSingleTon shareSingleTon].alertStack.lastObject;
    }
    
    if (previousAlert && previousAlert.vc) {
        previousAlert.vc.view.frame = [UIScreen mainScreen].bounds;
        previousAlert.vc.coverView.frame = [UIScreen mainScreen].bounds;
        previousAlert.vc.alertView.center = CGPointMake(ECGScreenWidth / 2, ECGScreenHeight / 2);

    }
}

- (void)setButton:(UIButton *)btn BackgroundWithButonType:(ECGAlertViewButtonType)buttonType{
    UIColor *textColor = nil;
    UIImage *normalImage = nil;
    UIImage *highImage = nil;
    //可以不断的扩展Button样式
    switch (buttonType) {
        case ECGAlertViewButtonTypeDefault:
            normalImage = [self imageFromColorWithColor:[UIColor blueColor]];
            highImage = [self imageFromColorWithColor:[UIColor blueColor]];
            textColor = ECGColor(255, 255, 255);
            [btn setBackgroundImage:[self resizeImage:normalImage] forState:UIControlStateNormal];
            [btn setBackgroundImage:[self resizeImage:highImage] forState:UIControlStateHighlighted];
            [btn setTitleColor:textColor forState:UIControlStateNormal];
            break;
        case ECGAlertViewButtonTypeCancel:
            normalImage = [self imageFromColorWithColor:ECGColor(105, 105, 105)];
            highImage = [self imageFromColorWithColor:ECGColor(105, 105, 105)];
            [btn setBackgroundImage:[self resizeImage:normalImage] forState:UIControlStateNormal];
            [btn setBackgroundImage:[self resizeImage:highImage] forState:UIControlStateHighlighted];
            [btn setTitleColor:textColor forState:UIControlStateNormal];
            textColor = ECGColor(255, 255, 255);
            break;
        case ECGAlertViewButtonTypeWarn:
            normalImage = [self imageFromColorWithColor:ECGColor(255, 99, 71)];
            highImage = [self imageFromColorWithColor:ECGColor(255, 99, 71)];
            [btn setBackgroundImage:[self resizeImage:normalImage] forState:UIControlStateNormal];
            [btn setBackgroundImage:[self resizeImage:highImage] forState:UIControlStateHighlighted];
            [btn setTitleColor:textColor forState:UIControlStateNormal];
            textColor = ECGColor(255, 255, 255);
            break;
        case ECGAlertViewButtonTypeNone:
            
            textColor = [UIColor blackColor];
            [btn setTitleColor:textColor forState:UIControlStateNormal];
            break;
        case ECGAlertViewButtonTypeHeight:
            
            textColor = [UIColor blueColor];
            [btn setTitleColor:textColor forState:UIControlStateNormal];
            break;
        case ECGAlertViewButtonTypeECG:
            
            textColor = [UIColor colorWithRed:0.16 green:0.80 blue:0.82 alpha:1];
            [btn setTitleColor:textColor forState:UIControlStateNormal];
            break;
            
    }
    
    
}

- (UIImage *)resizeImage:(UIImage *)image{
    return [image stretchableImageWithLeftCapWidth:image.size.width / 2 topCapHeight:image.size.height / 2];
}

- (UIImage *)imageFromColorWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}


@end
