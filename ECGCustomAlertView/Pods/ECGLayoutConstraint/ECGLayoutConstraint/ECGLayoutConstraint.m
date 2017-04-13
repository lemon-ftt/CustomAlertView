//
//  ECGLayoutConstraint.m
//  ECGLayoutConstraint
//
//  Created by tan on 2017/3/6.
//  Copyright © 2017年 tantan. All rights reserved.
//

#import "ECGLayoutConstraint.h"

@implementation ECGLayoutConstraint

+ (instancetype)shareInstance
{
    static ECGLayoutConstraint *_constraint;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _constraint = [[ECGLayoutConstraint alloc] init];
        _constraint->_deviceType = [_constraint currentDeviceType];
    });
    return _constraint;
}

/**
 以 6p 的px像素值作为基础来计算其他屏幕的pt值-->约束
 
 @param value 6p 的px像素值
 @return 当前设备的pt值
 */
+ (CGFloat)getConstrainlWithValueFrom6P:(CGFloat)value
{
    ECGLayoutConstraint *layoutConstraint = [self shareInstance];
    CGFloat constraint = 0;
    switch (layoutConstraint.deviceType) {
            
        case CYDeviceTypeIphone6:
            constraint = (CGFloat)((value *0.60335196f)/2);
            break ;
        case CYDeviceTypeIphone6s:
            constraint = (CGFloat)((value *0.60335196f)/2);
            break ;
        case CYDeviceTypeIphone7:
            constraint = (CGFloat)((value *0.60335196f)/2);
            break ;
        case CYDeviceTypeIphone6p:
            constraint = (CGFloat)(value/3);
            break;
        case CYDeviceTypeIphone7p:
            constraint = (CGFloat)(value/3);
            break;
        default:
            constraint = (CGFloat)((value *0.51396649f)/2);
            break;
    }
    
    return constraint;
}

/**
 以 6 的px像素值作为基础来计算其他屏幕的pt值-->约束

 @param value 6 的px像素值
 @return 当前设备的pt值
 */
+ (CGFloat)getConstrainlWithValueFrom6:(CGFloat)value
{
    ECGLayoutConstraint *layoutConstraint = [self shareInstance];
    CGFloat constraint = 0;
    switch (layoutConstraint.deviceType) {
            
        case CYDeviceTypeIphone6:
            constraint = (CGFloat)(value/2);
            break ;
        case CYDeviceTypeIphone6s:
            constraint = (CGFloat)(value/2);
            break ;
        case CYDeviceTypeIphone7:
            constraint = (CGFloat)(value/2);
            break ;
        case CYDeviceTypeIphone6p:
            constraint = (CGFloat)((value *1.656f)/3);
            break;
        case CYDeviceTypeIphone7p:
            constraint = (CGFloat)((value *1.656f)/3);
            break;
        default:
            constraint = (CGFloat)((value *0.85333333f)/2);
            break;
    }
    
    return constraint;
}

/**
 以 6 为基准得到一个不同屏幕尺寸相对应的 font
 
 @param fontSize <#fontSize description#>
 @return 当前设备相对应的 font
 */
+ (UIFont * _Nullable)getAdjustsFont:(CGFloat)fontSize {
    return [UIFont systemFontOfSize:[self getAdjustFontSize:fontSize]];
}

/**
 以 6P 为基准得到一个不同屏幕尺寸相对应的 font
 
 @param fontSize <#fontSize description#>
 @return 当前设备相对应的 font
 */
+ (UIFont * _Nullable)getAdjustsFontFrom6P:(CGFloat)fontSize {
    return [UIFont systemFontOfSize:[self getAdjustFontSizeFrom6P:fontSize]];
}

/**
 以 6 为基准得到字体的字号大小
 
 @param fontSize <#fontSize description#>
 @return 当前设备字体的字号大小
 */
+ (CGFloat)getAdjustFontSize:(CGFloat)fontSize {
    
    ECGLayoutConstraint *layoutConstraint = [self shareInstance];
    CGFloat size = 0.0f;
    switch (layoutConstraint.deviceType) {
        case CYDeviceTypeIphone6:
            size = fontSize;
            break ;
        case CYDeviceTypeIphone6p:
            size = (fontSize *1.104);
            break ;
        case CYDeviceTypeIphone7p:
            size = (fontSize *1.104);
            break ;
        default:
            size = (fontSize *0.85333333);
            break ;
    }
    return size;
}

/**
 以 6P 为基准得到字体的字号大小
 
 @param fontSize <#fontSize description#>
 @return 当前设备字体的字号大小
 */
+ (CGFloat)getAdjustFontSizeFrom6P:(CGFloat)fontSize {
    
    ECGLayoutConstraint *layoutConstraint = [self shareInstance];
    CGFloat size = 0.0f;
    switch (layoutConstraint.deviceType) {
        case CYDeviceTypeIphone6:
            size = (fontSize *0.9);
            break ;
        case CYDeviceTypeIphone6p:
            size = fontSize;
            break ;
        case CYDeviceTypeIphone7p:
            size = fontSize;
            break ;
        default:
            size = (fontSize *0.7);
            break ;
    }
    return size;
}

/**
 *  当前设备型号
 */
- (CYDeviceType)currentDeviceType {
    
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    if (screenHeight == 480.0f) {
        return CYDeviceTypeIphone4s;
    }else if (screenHeight == 568.0f){
        return CYDeviceTypeIphone5;
    }else if (screenHeight == 568.0f){
        return CYDeviceTypeIphone5s;
    }else if (screenHeight == 667.0f) {
        return CYDeviceTypeIphone6;
    }else if (screenHeight == 667.0f) {
        return CYDeviceTypeIphone6s;
    }else if (screenHeight == 667.0f) {
        return CYDeviceTypeIphone7;
    }
    return CYDeviceTypeIphone6p;
}

@end
