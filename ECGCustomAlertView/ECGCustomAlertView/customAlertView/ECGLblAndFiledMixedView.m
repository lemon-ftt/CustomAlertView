//
//  ECGLblAndFiledMixedView.m
//  ECGCustomAlertView
//
//  Created by tan on 2017/3/27.
//  Copyright © 2017年 tantan. All rights reserved.
//

#import "ECGLblAndFiledMixedView.h"
#import "Masonry.h"
#define kDefineFont [UIFont systemFontOfSize:16]
@interface ECGLblAndFiledMixedView(){
    NSString *_leftTitle;
    NSString *_rightTitle;
    NSString *_centerTitle;
}
@property (nonatomic, strong) UILabel *leftLbl;
@property (nonatomic, strong) UILabel *rightLbl;
@property (nonatomic, strong) UITextField *centerField;

@end
@implementation ECGLblAndFiledMixedView

- (instancetype)initWithFrame:(CGRect)frame leftTitle:(NSString *)leftT centerTitle:(NSString *)centerT {
    if (self = [super initWithFrame:frame]) {
        _leftTitle = leftT;
        _centerTitle = centerT;
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    CGFloat leftLblW = [_leftTitle sizeWithAttributes:@{NSFontAttributeName: kDefineFont}].width;
//    CGRect leftRect = CGRectMake(0, 0, leftLblW, 40);
//    self.leftLbl = [[UILabel alloc] initWithFrame:leftRect];
    self.leftLbl = [[UILabel alloc] init];
    [self addSubview:self.leftLbl];
    
    
    CGFloat rightLblW = [_leftTitle sizeWithAttributes:@{NSFontAttributeName: kDefineFont}].width;
//    CGRect rightRect = CGRectMake(0, 0, rightLblW, 40);
//    self.rightLbl = [[UILabel alloc] initWithFrame:rightRect];
    self.rightLbl = [[UILabel alloc] init];
    [self addSubview:self.rightLbl];
    
}


@end
