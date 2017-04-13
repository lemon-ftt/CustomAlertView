//
//  CustomView.m
//  ECGCustomAlertView
//
//  Created by tan on 2017/3/22.
//  Copyright © 2017年 tantan. All rights reserved.
//

#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height

#import "CustomView.h"

@implementation CustomView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(canceButtonClcik)];
//        [view addGestureRecognizer:tap];
        view.backgroundColor = [UIColor blackColor];
        view.alpha = 0.5;
        [self addSubview:view];
        self.alpha = 1;
        self.frame = CGRectMake(0,0,WIDTH, HEIGHT);
        
        CGFloat alertViewH = 475;
//        [self creatAlertTitle:title alertViewH:alertViewH];
    }
    
    return self;
}

- (void)show{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}
- (void)hide{
    [self removeFromSuperview];
}

@end
