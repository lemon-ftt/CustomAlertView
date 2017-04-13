//
//  UITextField+Category.m
//  ECGCustomAlertView
//
//  Created by tan on 2017/3/27.
//  Copyright © 2017年 tantan. All rights reserved.
//

#import "UITextField+Category.h"
#import "UIViewExt.h"
@implementation UITextField (Category)


- (void)updateFrameWithLeftViewW:(CGFloat)leftViewW rightViewW:(CGFloat)rightViewW{
    
    self.leftView.width = leftViewW;
    
    self.rightView.width = rightViewW;
    self.inputView.x = CGRectGetMaxX(self.leftView.frame);
    self.inputView.width = self.width - self.leftView.width - self.rightView.width;
    
}
@end
