//
//  ECGLayoutConstraint.h
//  ECGLayoutConstraint
//
//  Created by tan on 2017/3/6.
//  Copyright © 2017年 tantan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


// 根据比例设置约束
#define ECGLayoutConstraintEqualTo(constraint)   [ECGLayoutConstraint getConstrainlWithValueFrom6:constraint]
/// 设置不同的尺寸的字体对象
#define ECGAdjustFont(fontSize)                  [ECGLayoutConstraint getAdjustsFont:fontSize]
// 得到一个不同字体的字号大小
#define ECGAdjuestFontSize(size)                 [ECGLayoutConstraint getAdjustFontSize:size]

typedef NS_ENUM(NSInteger,CYDeviceType) {
    /** iphone4s */
    CYDeviceTypeIphone4s,
    /** iphone5 */
    CYDeviceTypeIphone5,
    /** iphone5s */
    CYDeviceTypeIphone5s,
    /** iphone6 */
    CYDeviceTypeIphone6,
    /** iphone6s */
    CYDeviceTypeIphone6s,
    /** iphone6p */
    CYDeviceTypeIphone6p,
    /** iphone7 */
    CYDeviceTypeIphone7,
    /** iphone7p */
    CYDeviceTypeIphone7p
};

@interface ECGLayoutConstraint : NSObject

/**  返回一个单例 */
+ (_Nullable instancetype)shareInstance;

/**
 以 6 的px像素值作为基础来计算其他屏幕的pt值-->约束
 
 @param value 6 的px像素值
 @return 当前设备的pt值
 */
+ (CGFloat)getConstrainlWithValueFrom6:(CGFloat)value;

/**
 以 6p 的px像素值作为基础来计算其他屏幕的pt值-->约束

 @param value 6p 的px像素值
 @return 当前设备的pt值
 */
+ (CGFloat)getConstrainlWithValueFrom6P:(CGFloat)value;

/**
 以 6 为基准得到一个不同屏幕尺寸相对应的 font

 @param fontSize <#fontSize description#>
 @return 当前设备相对应的 font
 */
+ (UIFont * _Nullable)getAdjustsFont:(CGFloat)fontSize;

/**
 以 6P 为基准得到一个不同屏幕尺寸相对应的 font
 
 @param fontSize <#fontSize description#>
 @return 当前设备相对应的 font
 */
+ (UIFont * _Nullable)getAdjustsFontFrom6P:(CGFloat)fontSize;

/**
 以 6 为基准得到字体的字号大小
 
 @param fontSize <#fontSize description#>
 @return 当前设备字体的字号大小
 */
+ (CGFloat)getAdjustFontSize:(CGFloat)fontSize;

/**
 以 6P 为基准得到字体的字号大小

 @param fontSize <#fontSize description#>
 @return 当前设备字体的字号大小
 */
+ (CGFloat)getAdjustFontSizeFrom6P:(CGFloat)fontSize;

/**  当前的设备型号 */
@property (nonatomic,assign,readonly)CYDeviceType deviceType;

@end
