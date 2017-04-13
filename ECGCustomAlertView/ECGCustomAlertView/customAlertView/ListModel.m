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

@end
