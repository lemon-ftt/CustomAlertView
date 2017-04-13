//
//  ListTableViewCell.m
//  ECGCustomAlertView
//
//  Created by tan on 2017/3/24.
//  Copyright © 2017年 tantan. All rights reserved.
//

#define NUM @"0123456789"

#import "ListTableViewCell.h"
#import "ECGCustomAlertView.h"

@interface customTextField : UITextField

@end

@implementation customTextField



@end

@interface ListTableViewCell ()<UITextFieldDelegate>

@end

@implementation ListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)layoutSubviews {
    
}

- (UITextField *)textField {
    if (_textField == nil) {
        _textField = [[UITextField alloc]initWithFrame:CGRectMake(ECGTextMargin, Margin, ECGAlertViewWidth-ECGTextMargin*2, CGRectGetHeight(self.frame)-Margin*1.5-Line)];
        _textField.textAlignment = NSTextAlignmentCenter;
        _textField.placeholder = @"";
        _textField.text = @"";
        _textField.keyboardType = UIKeyboardTypeNumberPad;
    }
    return _textField;
}

- (UILabel *)leftLabel {
    if (_leftLabel == nil) {
        _leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, ECGAlertViewTitleLabelHeight, ECGAlertViewTitleLabelHeight)];
        _leftLabel.font = [UIFont systemFontOfSize:16];
        _leftLabel.text = @"12121";
    }
    return _leftLabel;
}

- (UILabel *)rightLabel {
    if (_rightLabel == nil) {
        _rightLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, ECGAlertViewTitleLabelHeight, ECGAlertViewTitleLabelHeight)];
        _rightLabel.font = [UIFont systemFontOfSize:16];
        _rightLabel.text = @"5451323";
    }
    return _rightLabel;
}

- (UIView *)lineView {
    if (_lineView == nil) {
        _lineView = [[UIView alloc]initWithFrame:CGRectMake(ECGTextMargin, Margin+CGRectGetHeight(_textField.frame)+Line*2, CGRectGetWidth(_textField.frame), Line)];
        _lineView.backgroundColor = [UIColor grayColor];
    }
    return _lineView;
}

- (void)setupUIWithIndex:(NSInteger)index {
    [self.contentView addSubview:self.textField];
    self.textField.delegate = self;
    self.textField.leftView = self.leftLabel;
    self.textField.leftViewMode = UITextFieldViewModeAlways;
    self.textField.rightView = self.rightLabel;
    self.textField.text = @"";
    self.textField.rightViewMode = UITextFieldViewModeAlways;
    self.textField.tag = index+1000;
    [self.contentView addSubview:self.lineView];
    self.lineView.tag = index+2000;
}

- (void)setDataWith:(ListModel *)model {
   
    [self setUILayoutWithModel:model];
    self.leftLabel.text = model.leftName;
    self.rightLabel.text = model.rightName;
    self.textField.placeholder = model.tip;
}

- (void)setUILayoutWithModel:(ListModel *)model {
    
    CGSize leftStr = [model.leftName sizeWithAttributes:@{NSFontAttributeName: self.leftLabel.font}];
    self.leftLabel.frame = CGRectMake(0, 0, leftStr.width+5, ECGAlertViewTitleLabelHeight);
    CGSize rightStr = [model.rightName sizeWithAttributes:@{NSFontAttributeName: self.rightLabel.font}];
    self.rightLabel.frame = CGRectMake(0, 0, rightStr.width+5, ECGAlertViewTitleLabelHeight);
    
//    CGFloat leftw = [model.leftName sizeWithAttributes:@{NSFontAttributeName: self.leftLabel.font}].width;
//    CGFloat rightw = [model.rightName sizeWithAttributes:@{NSFontAttributeName: self.rightLabel.font}].width;
//    [self.textField updateFrameWithLeftViewW:leftw rightViewW:rightw];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    UIView *view =  [self.contentView viewWithTag:textField.tag+1000];
    view.backgroundColor = [UIColor colorWithRed:73.0/255.0 green:189.0/255.0 blue:204.0/255.0 alpha:1.0];
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    UIView *view =  [self.contentView viewWithTag:textField.tag+1000];
    view.backgroundColor = [UIColor grayColor];
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(callbackInputContent:index:)]) {
        [self.delegate callbackInputContent:textField.text index:textField.tag];
    }
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    return [self validateNumber:string];
}

//只能输入数字
- (BOOL)validateNumber:(NSString *)number {
    BOOL res = YES;
    NSCharacterSet *tmpSet = [NSCharacterSet characterSetWithCharactersInString:NUM];
    int i = 0;
    while (i < number.length) {
        NSString * string = [number substringWithRange:NSMakeRange(i, 1)];
        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
        if (range.length == 0) {
            res = NO;
            break;
        }
        i++;
    }
    return res;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    return YES;
}



@end
