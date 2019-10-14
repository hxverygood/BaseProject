//
//  HSBaseButton.m
//  HSRongyiBao
//
//  Created by hoomsun on 2017/7/17.
//  Copyright © 2017年 hoomsun. All rights reserved.
//

#import "BaseButton.h"

#define BUTTONCOLOR [UIColor colorWithRed:255/255.0 green:81/255.0  blue:8/255.0   alpha:1.0]


static const CGFloat defaultCornerRadius = 5.0;
static const CGFloat defaultFontSize = 16.0;



@interface BaseButton ()

@property (nonatomic, strong) NSString *normalTitle;
@property (nonatomic, strong) NSString *unableTitle;

@property (nonatomic, strong) NSArray *gradientColors;
@property (nonatomic, strong) NSArray *gradientColors_selected;
@property (nonatomic, strong) CAGradientLayer *gradientLayer;
@property (nonatomic, strong) CAGradientLayer *gradientLayer_selected;

@end



@implementation BaseButton

#pragma mark - Getter

- (UIColor *)defaultTitleColor {
    if (!_defaultTitleColor) {
        _defaultTitleColor = [UIColor colorWithRed:36/255.0 green:36/255.0 blue:36/255.0 alpha:1.0];
    }
    return _defaultTitleColor;
}

- (UIColor *)defaultBackgrouodColor {
    if (!_defaultBackgrouodColor) {
        _defaultBackgrouodColor = BUTTONCOLOR;
    }
    return _defaultBackgrouodColor;
}

- (UIColor *)unableTitleColor {
    if (!_unableTitleColor) {
        _unableTitleColor = [UIColor whiteColor];
    }
    return _unableTitleColor;
}

- (UIColor *)unableBackgroundColor {
    if (!_unableBackgroundColor) {
        _unableBackgroundColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1.0];
    }
    return _unableBackgroundColor;
}


- (NSArray<UIColor *> *)gradientColors {
    if (!_gradientColors) {
        NSArray<UIColor *> *colors = [NSArray arrayWithObjects:
                          // left
                          [UIColor colorWithRed:255/255.0 green:104/255.0 blue:44/255.0 alpha:1.0],
                          // right
                          [UIColor colorWithRed:255/255.0 green:6/255.0 blue:6/255.0 alpha:1.0],
                          nil];
        _gradientColors = colors;
    }
    return _gradientColors;
}

- (NSArray<UIColor *> *)gradientColors_selected {
    if (!_gradientColors_selected) {
        NSMutableArray<UIColor *> *tmpArray = [NSMutableArray array];
        for (int i = 0; i < self.gradientColors.count; i++) {
            UIColor *color = self.gradientColors[i];
            color = [color colorWithAlphaComponent:0.5];
            [tmpArray addObject:color];
        }
        _gradientColors_selected = tmpArray;
    }
    return _gradientColors_selected;
}



#pragma mark - Setter

- (void)setIsAvailable:(BOOL)isAvailable {
    _isAvailable = isAvailable;
    
    self.enabled = isAvailable;

    self.backgroundColor = isAvailable ? BUTTONCOLOR : self.unableBackgroundColor;
    [self setTitle:isAvailable ? self.normalTitle : self.unableTitle forState:UIControlStateNormal];
    [self setTitleColor:isAvailable ? self.defaultTitleColor : self.unableTitleColor forState:UIControlStateNormal];
}






#pragma mark - Initializer

+ (instancetype _Nullable)buttonWithFrame:(CGRect)frame
                                    title:(NSString * _Nullable)title {
    return [[BaseButton alloc] initWithFrame:frame
                                       title:title
                                  titleColor:nil
                                   titleSize:0.0
                             backgroundColor:nil
                                cornerRadius:0.0];
}

+ (instancetype _Nullable)buttonWithFrame:(CGRect)frame
                                    title:(NSString * _Nullable)title
                               titleColor:(UIColor *_Nullable)titleColor{
    return [[self alloc] initWithFrame:frame
                                 title:title
                            titleColor:titleColor
                             titleSize:0.0
                       backgroundColor:nil
                          cornerRadius:0.0];
}

+ (instancetype _Nullable)buttonWithFrame:(CGRect)frame
                                    title:(NSString * _Nullable)title
                               titleColor:(UIColor *_Nullable)titleColor
                          backgroundColor:(UIColor *_Nullable)backgroundColor
                             cornerRadius:(CGFloat)cornerRadius {
    return [[self alloc] initWithFrame:frame
                                 title:title
                            titleColor:titleColor
                             titleSize:0.0
                       backgroundColor:backgroundColor
                          cornerRadius:cornerRadius];
}

+ (instancetype _Nullable)buttonWithFrame:(CGRect)frame
                                    title:(NSString * _Nullable)title
                               titleColor:(UIColor *_Nullable)titleColor
                                titleSize:(CGFloat)titleSize
                          backgroundColor:(UIColor *_Nullable)backgroundColor
                             cornerRadius:(CGFloat)cornerRadius {
    return [[self alloc] initWithFrame:frame
                                 title:title
                            titleColor:titleColor
                             titleSize:titleSize
                       backgroundColor:backgroundColor
                          cornerRadius:cornerRadius];
}

/// 圆角按钮
+ (instancetype _Nullable)roundCornerWithFrame:(CGRect)frame
                                         title:(NSString * _Nullable)title
                                    titleColor:(UIColor *_Nullable)titleColor
                                     titleSize:(CGFloat)titleSize
                               backgroundColor:(UIColor *_Nullable)backgroundColor
                                  cornerRadius:(CGFloat)cornerRadius {
    return [[self alloc] initWithFrame:frame
                                 title:title
                            titleColor:titleColor
                             titleSize:titleSize
                       backgroundColor:backgroundColor
                          cornerRadius:frame.size.height/2.0];
}

/// 两端为大圆角、底色为渐变的Button
+ (instancetype _Nullable)roundCornerGradientButtonWithFrame:(CGRect)frame
                                                      title:(NSString * _Nullable)title {
    BaseButton *button = [[BaseButton alloc] initWithFrame:frame title:title titleColor:[UIColor whiteColor] titleSize:15.0 backgroundColor:nil cornerRadius:CGRectGetHeight(frame)/2];

//    [button gradientBackgrounColors:button.gradientColors];
    return button;
}

//+ (instancetype _Nullable )initWithFrame:(CGRect)frame
//                              titleColor:(UIColor *_Nullable)titleColor
//                            cornerRadius:(CGFloat)cornerRadius {
//    return [[HSBaseButton alloc] initWithFrame:frame
//                                         title:nil
//                                    titleColor:titleColor
//                                     titleSize:0.0
//                               backgroundColor:nil
//                                  cornerRadius:cornerRadius];
//}

- (instancetype)initWithFrame:(CGRect)frame
                        title:(NSString * _Nullable)title
                   titleColor:(UIColor *_Nullable)titleColor
                    titleSize:(CGFloat)titleSize
              backgroundColor:(UIColor *_Nullable)backgroundColor
                 cornerRadius:(CGFloat)cornerRadius {
                 
    self = [super initWithFrame:frame];
    
    if (self) {
        self.normalTitle = title ? : @"提交";
        self.unableTitle = @"正在获取数据，请稍候";
        
        BaseButton *button = [BaseButton buttonWithType:UIButtonTypeCustom];
        button.frame= frame;
        
        if (title) {
            [button setTitle:title forState:UIControlStateNormal];
        }
        
        [button setTitleColor:titleColor ?: self.defaultTitleColor forState:UIControlStateNormal];
        
        button.titleLabel.font = [UIFont systemFontOfSize:titleSize > 0.1 ? titleSize : defaultFontSize];
        
        if (cornerRadius > 0.0) {
            [button setTitleColor:titleColor cornerRadius:cornerRadius];
        } else {
            [button setTitleColor:titleColor cornerRadius:defaultCornerRadius];
        }
        
        button.backgroundColor = backgroundColor ? : self.defaultBackgrouodColor;
        
        self = button;
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        self.titleLabel.font = [UIFont systemFontOfSize:defaultFontSize];
        [self setTitleColor:self.defaultTitleColor forState:UIControlStateNormal];
        self.backgroundColor = self.defaultBackgrouodColor;
        self.layer.cornerRadius = defaultCornerRadius;
        self.layer.masksToBounds = YES;
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
//        [self gradientBackgroudWithCornerRadius:5.0];
        self.normalTitle = self.titleLabel.text ? : @"提交";
        self.unableTitle = @"正在获取数据，请稍候";
        self.titleLabel.font = [UIFont systemFontOfSize:defaultFontSize];
        self.backgroundColor = self.defaultBackgrouodColor;
        self.unableBackgroundColor = self.unableBackgroundColor;
        [self setTitleColor:self.defaultTitleColor forState:UIControlStateNormal];
        self.layer.cornerRadius = defaultCornerRadius;
        self.layer.masksToBounds = YES;
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
//    [self gradientBackgroudWithCornerRadius:5.0];
    self.normalTitle = self.titleLabel.text ? : @"提交";
    self.unableTitle = @"正在获取数据，请稍候";
    self.titleLabel.font = [UIFont systemFontOfSize:defaultFontSize];
    self.backgroundColor = self.defaultBackgrouodColor;
    self.unableBackgroundColor = self.unableBackgroundColor;
    [self setTitleColor:self.defaultTitleColor forState:UIControlStateNormal];
    self.layer.cornerRadius = defaultCornerRadius;
    self.layer.masksToBounds = YES;
}

//- (void)layoutSubviews {
//    [super layoutSubviews];
//
////    if (_gradientLayer) {
////        _gradientLayer.frame = self.bounds;
////    }
////    
////    if (_gradientLayer_selected) {
////        _gradientLayer_selected.frame = self.bounds;
////    }
//}



#pragma mark - Func

/// 对按钮置灰情况进行设置
- (void)setUnableTitle:(NSString * _Nullable)unableTitle
  unableBackgroudColor:(UIColor * _Nullable)unableBackgroudColor {
    self.unableTitle = unableTitle ? : @"正在获取数据...";
    self.unableBackgroundColor = unableBackgroudColor ? : self.unableBackgroundColor;
}

- (void)setTitleColor:(UIColor *_Nullable)titleColor
         cornerRadius:(CGFloat)cornerRadius {
    if (self) {
        if (titleColor) {
            [self setTitleColor:titleColor forState:UIControlStateNormal];
        }
        
        if (cornerRadius > 0.1) {
            self.layer.cornerRadius = cornerRadius;
            self.layer.masksToBounds = YES;
        }
    }
}

/// 设置成灰色样式
- (void)isGrayStyle:(BOOL)isGray {
    [self setTitleColor:isGray ? self.unableTitleColor : self.defaultTitleColor forState:UIControlStateNormal];
    self.backgroundColor = isGray ? self.unableBackgroundColor : self.defaultBackgrouodColor;
}

// 设置button为底色渐变、圆角
- (void)gradientBackgroudWithCornerRadius:(CGFloat)cornerRadius {
    if (!self) {
        return;
    }
    
    [self gradientBackgrounColors:self.gradientColors];
    [self setTitleColor:[UIColor whiteColor] cornerRadius:cornerRadius];
}



#pragma mark - Privte Func

- (void)gradientBackgrounColors:(NSArray *)colors {
    if (!self) {
        return;
    }
    
    NSMutableArray *cgColorArray = [NSMutableArray array];
    for (UIColor *color in colors) {
        [cgColorArray addObject:(id)color.CGColor];
    }
    
    CALayer *buttonLayer = self.layer;
    _gradientLayer = [CAGradientLayer layer];
    _gradientLayer.frame = self.bounds;
    _gradientLayer.colors = cgColorArray;
    _gradientLayer.startPoint = CGPointMake(0.0, 0.5);
    _gradientLayer.endPoint = CGPointMake(1.0, 0.5);
    [buttonLayer insertSublayer:_gradientLayer atIndex:0];
}

- (void)gradientBackgrounColors_selected:(NSArray *)colors {
    if (!self) {
        return;
    }
    
    NSMutableArray *cgColorArray_selected = [NSMutableArray array];
    for (UIColor *color in colors) {
        [cgColorArray_selected addObject:(id)color.CGColor];
    }
    
    CALayer *buttonLayer = self.layer;
    _gradientLayer_selected = [CAGradientLayer layer];
    _gradientLayer_selected.frame = self.bounds;
    _gradientLayer_selected.colors = cgColorArray_selected;
    _gradientLayer_selected.startPoint = CGPointMake(0.0, 0.5);
    _gradientLayer_selected.endPoint = CGPointMake(1.0, 0.5);
    [buttonLayer insertSublayer:_gradientLayer_selected atIndex:0];
}



#pragma mark - Action

//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//    // handle touch
//    [super touchesBegan:touches withEvent:event];
//    
//    // Remove old gradient here
//    [[[[self layer] sublayers] objectAtIndex:0] removeFromSuperlayer];
//    
//    if ([self state] == UIControlStateHighlighted)
//    {
//        [self gradientBackgrounColors_selected:self.gradientColors_selected];
//    }
//}
//
//- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
//    // handle touch
//    [super touchesEnded:touches withEvent:event];
//    
//    // Remove old gradient here
//    [[[[self layer] sublayers] objectAtIndex:0] removeFromSuperlayer];
//    [self gradientBackgrounColors:self.gradientColors];
//}

@end
