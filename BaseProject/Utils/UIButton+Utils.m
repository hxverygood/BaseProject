//
//  UIButton+Utils.m
//

#import "UIButton+Utils.h"
#import <UIKit/UIKit.h>

@implementation UIButton (Utils)

// 设置边框颜色
- (void)setBorderColor:(UIColor *)color {
    self.layer.borderColor = color.CGColor;
}

// 设置线宽和颜色
- (void)setBorderWidth:(float)width andColor:(UIColor *)color {
    self.layer.borderWidth = width;
    self.layer.borderColor = color.CGColor;
    [self setTitleColor:color forState:UIControlStateNormal];
    [self setBackgroundColor:[UIColor clearColor]];
}

/// 设置圆角
- (void)setCornerRadius:(float)radius {
    self.layer.cornerRadius = radius;
    self.layer.masksToBounds = YES;
}

/// 设置圆角（圆角半径为半个按钮高度）
- (void)setCornerRadiusWithHalfHeight {
    self.layer.cornerRadius = self.frame.size.height / 2;
    self.layer.masksToBounds = YES;
}

/// 设置圆角、边框有颜色
- (void)setTitle:(NSString *)title titleColor:(UIColor *)titleColor borderWidth:(float)borderWidth borderColor:(UIColor *)borderColor borderRadius:(float)radius {
    [self setBorderWidth:borderWidth andColor:borderColor];
    [self setCornerRadius:radius];
    [self setTitle:title forState:UIControlStateNormal];
    [self setTitleColor:titleColor forState:UIControlStateNormal];
}

///// 根据按钮是否可用设置背景色
//- (void)changeButtonAppearanceForButton:(UIButton *)button enable:(BOOL)flag backgroudColor:(UIColor *)color {
//    button.backgroundColor = color;
//    if (flag) {
//        button.enabled = YES;
//        button.alpha = 1.0;
//    } else {
//        button.enabled = NO;
//        button.alpha = 0.4;
//    }
//}

/// 根据按钮是否可用设置背景色为灰色
- (void)changeButtonAppearanceWithEnable:(BOOL)flag {
    UIColor *backgroundColor = self.backgroundColor;
    self.enabled = flag;
    if (flag) {
        self.backgroundColor = backgroundColor;
    } else {
        self.backgroundColor = [UIColor grayColor];
    }
}

///// 根据按钮是否可用设置背景色
//- (void)changeButtonAppearanceWithEnable:(BOOL)flag
//                          backgroudColor:(UIColor *)color {
//    self.backgroundColor = color;
//    if (flag) {
//        self.enabled = YES;
//        self.alpha = 1.0;
//    } else {
//        self.enabled = NO;
//        self.alpha = 0.4;
//    }
//}
//
///// 根据按钮是否可用设置背景色为自定义颜色或灰色
//- (void)changeButtonAppearanceWithEnable:(BOOL)flag
//                    normalBackgroudColor:(UIColor *)color {
//    self.backgroundColor = [UIColor grayColor];
//    if (flag) {
//        self.enabled = YES;
//        self.backgroundColor = color;
//    } else {
//        self.enabled = NO;
//        self.backgroundColor = [UIColor grayColor];
//    }
//}
//
///// 根据按钮是否可用，设置title、背景色
//- (void)changeButtonAppearanceWithEnable:(BOOL)flag
//                                   title:(NSString *)title
//                          backgroudColor:(UIColor *)color {
//    self.backgroundColor = color;
//    [self setTitle:title forState:UIControlStateNormal];
//    
//    if (flag) {
//        self.enabled = NO;
//        self.alpha = 0.4;
//        
//    } else {
//        self.enabled = YES;
//        self.alpha = 1.0;
//    }
//}

/// 设置文字、字体大小、颜色
- (void)buttonWithTitle:(NSString *)title {
    [self setTitle:title forState:UIControlStateNormal];
}

- (void)buttonWithTextColor:(UIColor *)color {
    self.titleLabel.textColor = color;
}

- (void)buttonWithFontSize:(CGFloat)fontSize {
    self.titleLabel.font = [UIFont systemFontOfSize:fontSize];
}

- (void)buttonWithTitle:(NSString *)title
              textColor:(UIColor *)textColor
               fontSize:(CGFloat)fontSize {
    [self setTitle:title forState:UIControlStateNormal];
    [self setTitleColor:textColor forState:UIControlStateNormal];
    self.titleLabel.font = [UIFont systemFontOfSize:fontSize];
}

/// 图标、文字居中
- (void)verticalAlignTitleAndImageView {
    // button标题的偏移量
    self.titleEdgeInsets = UIEdgeInsetsMake(self.imageView.frame.size.height+5, -self.imageView.bounds.size.width, 0, 0);
    // button图片的偏移量
    self.imageEdgeInsets = UIEdgeInsetsMake(0, self.titleLabel.frame.size.width/2, self.titleLabel.frame.size.height+5, -self.titleLabel.frame.size.width/2);
}

@end
