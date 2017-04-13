//
//  ListModel.h
//  ECGCustomAlertView
//
//  Created by tan on 2017/3/27.
//  Copyright © 2017年 tantan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ListModel : NSObject

@property (nonatomic, copy)NSString *leftName;//列表左侧名字
@property (nonatomic, copy)NSString *tip;//中间输入框提示语
@property (nonatomic, copy)NSString *rightName;//列表右侧名字
@property (nonatomic, copy)NSString *content;//列表输入的内容


+ (instancetype)creatListModelWithLeftName:(NSString *)leftN
                                       tip:(NSString *)tip
                                 rightName:(NSString *)rightN
                                   content:(NSString *)content ;
@end
