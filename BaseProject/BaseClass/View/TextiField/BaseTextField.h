//
//  BaseTextField.h
//
//  Created by hans on 2017/7/17.
//  Copyright © 2017年. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseTextField : UITextField

@property (nonatomic, assign) CGFloat editor_dx;
@property (nonatomic, assign) CGFloat editor_dy;


/// 两端为圆角的textField
+ (instancetype _Nullable)roundCornerTextFieldWithFrame:(CGRect)frame
                                              textColor:(UIColor * _Nullable)textColor
                                            placeholder:(NSString * _Nullable )placehoder;


/// 生成自定义颜色的textField
+ (instancetype _Nullable)textFieldWithFrame:(CGRect)frame
                                    fontSize:(CGFloat)fontSize
                                   textColor:(UIColor * _Nullable)textColor
                                 placeholder:(NSString * _Nullable)placehoder
                            placeholderColor:(UIColor * _Nullable)placeholderColor
                                cornerRadius:(CGFloat)cornerRadius;

- (void)setTextColor:(UIColor * _Nullable)textColor
    placeholderColor:(UIColor * _Nullable)placeholderColor;

- (void)setTextColor:(UIColor * _Nullable)textColor
           tintColor:(UIColor * _Nullable)tintColor;

- (void)roundCornerTextField;

@end
