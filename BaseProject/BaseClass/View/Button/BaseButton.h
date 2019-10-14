//
//  HSBaseButton.h
//  HSRongyiBao
//
//  Created by hoomsun on 2017/7/17.
//  Copyright © 2017年 hoomsun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseButton : UIButton

//#pragma mark - Properties

//@property (nonatomic, strong) NSArray * _Nullable gradientColors;

// 设置button是否是可用状态（不可用则置灰）
@property (nonatomic, assign) BOOL isAvailable;
@property (nonatomic, strong) UIColor * _Nullable defaultTitleColor;
@property (nonatomic, strong) UIColor * _Nullable defaultBackgrouodColor;
@property (nonatomic, strong) UIColor * _Nullable unableTitleColor;
@property (nonatomic, strong) UIColor * _Nullable unableBackgroundColor;


#pragma mark - Initializer

+ (instancetype _Nullable)buttonWithFrame:(CGRect)frame
                                    title:(NSString * _Nullable)title;

+ (instancetype _Nullable)buttonWithFrame:(CGRect)frame
                                    title:(NSString * _Nullable)title
                               titleColor:(UIColor *_Nullable)titleColor;

+ (instancetype _Nullable)buttonWithFrame:(CGRect)frame
                                    title:(NSString * _Nullable)title
                               titleColor:(UIColor *_Nullable)titleColor
                          backgroundColor:(UIColor *_Nullable)backgroundColor
                             cornerRadius:(CGFloat)cornerRadius;

+ (instancetype _Nullable)buttonWithFrame:(CGRect)frame
                                    title:(NSString * _Nullable)title
                               titleColor:(UIColor *_Nullable)titleColor
                                titleSize:(CGFloat)titleSize
                          backgroundColor:(UIColor *_Nullable)backgroundColor
                             cornerRadius:(CGFloat)cornerRadius;

/// 圆角按钮
+ (instancetype _Nullable)roundCornerWithFrame:(CGRect)frame
                                         title:(NSString * _Nullable)title
                                    titleColor:(UIColor *_Nullable)titleColor
                                     titleSize:(CGFloat)titleSize
                               backgroundColor:(UIColor *_Nullable)backgroundColor
                                  cornerRadius:(CGFloat)cornerRadius;

/// 两端为大圆角、底色为渐变的Button
+ (instancetype _Nullable)roundCornerGradientButtonWithFrame:(CGRect)frame
                                                       title:(NSString * _Nullable)title;


//+ (instancetype _Nullable )initWithFrame:(CGRect)frame
//                              titleColor:(UIColor *_Nullable)titleColor
//                            cornerRadius:(CGFloat)cornerRadius;

/// 对按钮置灰情况进行设置
- (void)setUnableTitle:(NSString * _Nullable)unableTitle
  unableBackgroudColor:(UIColor * _Nullable)unableBackgroudColor;


- (void)setTitleColor:(UIColor *_Nullable)titleColor
         cornerRadius:(CGFloat)cornerRadius;

/// 设置成灰色样式
- (void)isGrayStyle:(BOOL)isGray;

// 设置button为底色渐变、圆角
- (void)gradientBackgroudWithCornerRadius:(CGFloat)cornerRadius;


@end
