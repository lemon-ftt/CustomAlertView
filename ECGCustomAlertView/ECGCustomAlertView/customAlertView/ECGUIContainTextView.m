//
//   ______ _____ _____
//  |  ____/ ____/ ____|
//  | |__ | |   | |  __
//  |  __|| |   | | |_ |
//  | |___| |___| |__| |
//  |______\_____\_____|
//
//
//  ECGUIContainTextView.m
//  CustomAlertViewDemo
//  带输入效果的自定义视图(做弹出视图)
//  Created by tan on 2016/11/8.
//  Copyright © 2016年 tantan. All rights reserved.
//

//色值
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define RGB(r,g,b) RGBA(r,g,b,1.0f)
#define HEXCOLOR(hex) [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16)) / 255.0 green:((float)((hex & 0xFF00) >> 8)) / 255.0 blue:((float)(hex & 0xFF)) / 255.0 alpha:1]


#import "ECGUIContainTextView.h"
#import "Masonry.h"
#import "ECGCustomAlertView.h"

@interface ECGUIContainTextView ()<UITextViewDelegate>

@property(nonatomic,strong)UIView *showView;
@property(nonatomic,strong)UIView *bottomLineView,*seperateLineView;
@property(nonatomic,copy)NSString *viewTitle,*leftButtonTitle,*rightButtonTitle,*placeholderText;
@property(nonatomic,assign)int tipLabelTextNum;
@end

static const CGFloat kAlertViewHeight=200;
static const CGFloat kAlertViewLeftAndRight=15;
static const CGFloat kTopTitleLabelSapn=10;
static const CGFloat kTitleLabelHeight=16;
static const CGFloat kLeftAndRightSpan=10;
static const CGFloat kTopContentTextHeight=10;
static const CGFloat kContentTextViewHeight=100;
static const CGFloat kButtonHeight=44;
static const CGFloat kTipLabelWidth=160;
static const CGFloat kTipLabelHeight=30;

@implementation ECGUIContainTextView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

-(instancetype)initPagesViewWithTitle:(NSString *)title leftButtonTitle:(NSString *)leftButtonTitle rightButtonTitle:(NSString *)rightButtonTitle placeholderText:(NSString *)placeholderText tipLabelTitle:(int)tipLabelTextNum
{
    self = [super initWithFrame:[[UIScreen mainScreen] bounds]];
    if (self) {
        _viewTitle=title;
        _leftButtonTitle=leftButtonTitle;
        _rightButtonTitle=rightButtonTitle;
        _placeholderText=placeholderText;
        _tipLabelTextNum = tipLabelTextNum;
        
        [self layoutViewPage];
    }
    return self;
}


-(void)layoutViewPage
{
    if (!self.showView) {
        self.showView=[[UIView alloc]init];
        self.showView.layer.cornerRadius = 8;
        self.showView.layer.masksToBounds = YES;
        self.showView.backgroundColor=[UIColor whiteColor];
        [self addSubview:self.showView];
        [self.showView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(kAlertViewLeftAndRight);
            make.right.mas_equalTo(-kAlertViewLeftAndRight);
            make.center.mas_equalTo(0);
            make.height.mas_equalTo(kAlertViewHeight);
        }];
    }
    
    
    if (!self.titleLabel) {
        self.titleLabel=[[UILabel alloc]init];
        self.titleLabel.font=[UIFont systemFontOfSize:14];
        self.titleLabel.text=self.viewTitle;
        self.titleLabel.textColor=[UIColor blackColor];
        self.titleLabel.textAlignment=NSTextAlignmentCenter;
        [self.showView addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(kLeftAndRightSpan);
            make.right.mas_equalTo(-kLeftAndRightSpan);
            make.top.mas_equalTo(kTopTitleLabelSapn);
            make.height.mas_equalTo(kTitleLabelHeight);
        }];
    }
    
    //区别是否有头部的布局
    CGFloat curContentTextTop=self.viewTitle.length?kTopTitleLabelSapn+kTitleLabelHeight+kTopContentTextHeight:kTopTitleLabelSapn;
    CGFloat curContentTextHeight=self.viewTitle.length?kContentTextViewHeight:kContentTextViewHeight+kTopTitleLabelSapn+kTitleLabelHeight;
    
    if (!self.contentTextView) {
        self.contentTextView = [[ECGPlaceHolderTextView alloc]init];
        self.contentTextView.delegate=self;
        self.contentTextView.layer.borderWidth = 0.5f;
        self.contentTextView.layer.cornerRadius = 8;
        self.contentTextView.layer.masksToBounds = YES;
        self.contentTextView.layer.borderColor = RGB(234, 234, 234).CGColor;
        self.contentTextView.font = [UIFont systemFontOfSize:12];
        self.contentTextView.textColor = [UIColor blackColor];
        self.contentTextView.placeholder=self.placeholderText;
        self.contentTextView.placeholderColor = HEXCOLOR(0x666666);
        self.contentTextView.returnKeyType=UIReturnKeyDone;
        [self.showView addSubview:self.contentTextView];
        [self.contentTextView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(kLeftAndRightSpan);
            make.right.mas_equalTo(-kLeftAndRightSpan);
            make.top.mas_equalTo(curContentTextTop);
            make.height.mas_equalTo(curContentTextHeight);
        }];
    }
    
    if (!self.tipLabel) {
        self.tipLabel = [[UILabel alloc]init];
        self.tipLabel.font = [UIFont systemFontOfSize:12];
        self.tipLabel.text = [NSString stringWithFormat:@"0/%d",_tipLabelTextNum];
        self.tipLabel.textAlignment = NSTextAlignmentRight;
        self.tipLabel.textColor = [UIColor lightGrayColor];
        [self.showView addSubview:self.tipLabel];
        [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-kLeftAndRightSpan);
            make.bottom.mas_equalTo(self.contentTextView.mas_bottom);
            make.width.mas_equalTo(kTipLabelWidth);
            make.height.mas_equalTo(kTipLabelHeight);
        }];
    }
    
    if (!self.leftButton) {
        self.leftButton=[[UIButton alloc]init];
        [self.leftButton setTitle:self.leftButtonTitle forState:UIControlStateNormal];
        [self.leftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.leftButton addTarget:self action:@selector(leftBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.showView addSubview:self.leftButton];
        [self.leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
            make.height.mas_equalTo(kButtonHeight);
        }];
    }
    
    if (!self.rightButton) {
        self.rightButton=[[UIButton alloc]init];
        [self.rightButton setTitle:self.rightButtonTitle forState:UIControlStateNormal];
        [self.rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.rightButton addTarget:self action:@selector(rightBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.showView addSubview:self.rightButton];
        [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
            make.height.mas_equalTo(kButtonHeight);
            make.left.mas_equalTo(self.leftButton.mas_right);
            make.width.mas_equalTo(self.leftButton.mas_width);
        }];
    }
    
    
    if (!self.bottomLineView) {
        self.bottomLineView=[[UIView alloc]init];
        self.bottomLineView.backgroundColor=[UIColor grayColor];
        [self.showView addSubview:self.bottomLineView];
        [self.bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.mas_equalTo(0);
            make.bottom.mas_equalTo(-kButtonHeight);
            make.height.mas_equalTo(0.3);
        }];
    }
    
    
    if (!self.seperateLineView) {
        self.seperateLineView=[[UIView alloc]init];
        self.seperateLineView.backgroundColor=[UIColor grayColor];
        [self.showView addSubview:self.seperateLineView];
        [self.seperateLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.leftButton.mas_right).offset(0);
            make.height.mas_equalTo(kButtonHeight);
            make.width.mas_equalTo(0.3);
            make.bottom.mas_equalTo(0);
        }];
    }
    
}


#pragma mark UITextViewDelegate

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
    
}



- (void)textViewDidChange:(UITextView *)textView

{
    //实时显示字数
    self.tipLabel.text = [NSString stringWithFormat:@"%u/%d", (unsigned)textView.text.length,_tipLabelTextNum];
    //字数限制操作
    if (textView.text.length >= _tipLabelTextNum) {
        textView.text = [textView.text substringToIndex:_tipLabelTextNum];
        self.tipLabel.text = [NSString stringWithFormat:@"%d/%d",_tipLabelTextNum,_tipLabelTextNum];
    }
    
}

#pragma mark 自定义代码

-(void)leftBtnClicked
{
    if (self.leftBlock) {
        self.leftBlock(self.contentTextView.text);
    }
}

-(void)rightBtnClicked
{
    if (self.rightBlock) {
        self.rightBlock(self.contentTextView.text);
    }
}

@end
