//
//  ListModel.m
//  ECGCustomAlertView
//
//  Created by tan on 2017/3/27.
//  Copyright © 2017年 tantan. All rights reserved.
//

#import "ListModel.h"

@implementation ListModel

- (instancetype)init {
    self = [super init];
    if (self) {
        _leftName = @"";
        _tip = @"";
        _rightName = @"";
        _content = @"";
    }
    return self;
}

+ (instancetype)creatListModelWithLeftName:(NSString *)leftN tip:(NSString *)tip rightName:(NSString *)rightN content:(NSString *)content {
    ListModel *M = [[ListModel alloc] init];
    M.leftName = leftN;
    M.tip = tip;
    M.rightName = rightN;
    M.content = content;
    return M;
}

@end
