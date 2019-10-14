//
//  UIButton+Utils.h
//

#import <UIKit/UIKit.h>

/// 自定义按钮
@interface UIButton (Utils)

/// 设置边框颜色
- (void)setBorderColor:(UIColor *)color;

/// 设置线宽和颜色
- (void)setBorderWidth:(float)width andColor:(UIColor *)color;

/// 设置圆角
- (void)setCornerRadius:(float)radius;

/// 设置圆角（圆角半径为半个按钮高度）
- (void)setCornerRadiusWithHalfHeight;

/// 设置圆角、边框有颜色
- (void)setTitle:(NSString *)title
      titleColor:(UIColor *)titleColor
     borderWidth:(float)borderWidth
     borderColor:(UIColor *)borderColor
    borderRadius:(float)radius;

/// 根据按钮是否可用设置背景色为灰色
- (void)changeButtonAppearanceWithEnable:(BOOL)flag;

///// 根据按钮是否可用设置按钮背景色
//- (void)changeButtonAppearanceWithEnable:(BOOL)flag backgroudColor:(UIColor *)color;
//
///// 根据按钮是否可用设置背景色为自定义颜色或灰色
//- (void)changeButtonAppearanceWithEnable:(BOOL)flag
//                    normalBackgroudColor:(UIColor *)color;
//
///// 根据按钮是否可用，设置title、背景色
//- (void)changeButtonAppearanceWithEnable:(BOOL)flag title:(NSString *)title backgroudColor:(UIColor *)color;

/// 设置文字、字体大小、颜色
- (void)buttonWithTitle:(NSString *)title;

- (void)buttonWithTextColor:(UIColor *)color;

- (void)buttonWithFontSize:(CGFloat)fontSize;

- (void)buttonWithTitle:(NSString *)title
              textColor:(UIColor *)textColor
               fontSize:(CGFloat)fontSize;

/// 图标、文字居中
- (void)verticalAlignTitleAndImageView;

@end
