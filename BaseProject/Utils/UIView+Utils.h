//
//  UIView+Utils.h
//  LDDriverSide
//
//  Created by shandiangou on 2018/6/7.
//  Copyright © 2018年 lightingdog. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Utils)

/// 获取占满屏幕时的frame（去除导航栏和tabbar）
+ (CGRect)fullScreenFrame;

/// 设置圆角
- (void)cornerRadius:(CGFloat)cornerRadius;
/// 设置半圆
- (void)halfCornerRadius;
/// 移除圆角
- (void)removeCornerRadius;
/// 设置边框线宽及颜色
- (void)borderWidth:(CGFloat)borderWitdh borderColor:(UIColor *)borderColor;

/// UIView 4个角分别设置圆角
- (void)cornerWithRect:(CGRect)rect
                 radii:(CGSize)radio
                corner:(UIRectCorner)corner;

/// UIView 上面2个角设置圆角
- (void)topCornerRadiusWithRect:(CGRect)rect;

/// UIView 下面2个角设置圆角
- (void)bottomCornerRadiusWithRect:(CGRect)rect;


/// 是否包含某种类型的View
- (BOOL)containSubviewClass:(Class)cls;

/// 递归遍历subview
- (__kindof UIView *)viewWithTag:(NSInteger)tag;

@end
