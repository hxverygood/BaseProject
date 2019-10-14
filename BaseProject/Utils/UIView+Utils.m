//
//  UIView+Utils.m
//  LDDriverSide
//
//  Created by shandiangou on 2018/6/7.
//  Copyright © 2018年 lightingdog. All rights reserved.
//

#import "UIView+Utils.h"

@implementation UIView (Utils)

/// 获取占满屏幕时的frame（去除导航栏和tabbar）
+ (CGRect)fullScreenFrame {
    BOOL navIsTranlucent = [UINavigationBar appearance].translucent;
    BOOL is_iPhoneXSeries = [UIView isIPhoneXSeries];

    UIViewController *currentVC = [self currentViewController];
    BOOL naviBarIsHidden = currentVC.navigationController.isNavigationBarHidden;

    CGFloat navHeight = is_iPhoneXSeries ? 88.0 : 64.0;
    CGFloat naviHeightDiff = (navIsTranlucent || naviBarIsHidden) ? 0.0 : navHeight;
    CGFloat bottomDiff = is_iPhoneXSeries ? 34.0 : 0.0;

    CGFloat viewHeight = CGRectGetHeight([UIScreen mainScreen].bounds) - naviHeightDiff - bottomDiff;
    CGRect viewFrame = CGRectMake(0.0, 0.0, SCREEN_WIDTH, viewHeight);

    return viewFrame;
}

/// 设置圆角
- (void)cornerRadius:(CGFloat)cornerRadius {
    self.layer.cornerRadius = cornerRadius;
    self.layer.masksToBounds = YES;
}

/// 设置半圆
- (void)halfCornerRadius {
    self.layer.cornerRadius = self.bounds.size.height/2;
    self.layer.masksToBounds = YES;
}

/// 移除圆角
- (void)removeCornerRadius {
    self.layer.cornerRadius = 0.0;
    self.layer.masksToBounds = NO;
}

/// 设置边框线宽及颜色
- (void)borderWidth:(CGFloat)borderWitdh borderColor:(UIColor *)borderColor {
    self.layer.borderWidth = borderWitdh;
    self.layer.borderColor = borderColor.CGColor;
}

/// UIView 4个角分别设置圆角
- (void)cornerWithRect:(CGRect)rect
                 radii:(CGSize)radio
                corner:(UIRectCorner)corner {
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:corner cornerRadii:radio];
    CAShapeLayer *masklayer = [[CAShapeLayer alloc] init]; // 创建shapelayer
    masklayer.frame = self.bounds;
    masklayer.path = path.CGPath; // 设置路径
    self.layer.mask = masklayer;
    self.layer.masksToBounds = YES;
}

/// UIView 上面2个角设置圆角
- (void)topCornerRadiusWithRect:(CGRect)rect {
    [self cornerWithRect:rect radii:CGSizeMake(10.0, 10.0) corner:UIRectCornerTopLeft | UIRectCornerTopRight];
}

/// UIView 下面2个角设置圆角
- (void)bottomCornerRadiusWithRect:(CGRect)rect {
//    NSLog(@"%@", NSStringFromCGRect(self.frame));
    [self cornerWithRect:rect radii:CGSizeMake(10.0, 10.0) corner:UIRectCornerBottomLeft | UIRectCornerBottomRight];
}

/// 是否包含某种类型的View
- (BOOL)containSubviewClass:(Class)cls {
    NSArray<UIView *> *subviews = self.subviews;

    for (int i = 0; i < subviews.count; i++) {
        if ([subviews[i] isKindOfClass:cls]) {
            return YES;
        }
    }
    return NO;
}

/// 递归遍历subview
- (__kindof UIView *)viewWithTag:(NSInteger)tag {
    if (self.tag == tag) return self;

    for (UIView *subview in self.subviews) {
        if (subview.tag == tag) {
            return subview;
        }
        else {
            UIView *resultView = [subview viewWithTag:tag];
            if (resultView) {
                return resultView;
            }
        }
    }
    return nil;
}



#pragma mark - Private Func

/// 获取当前VC
+ (UIViewController *)currentViewController {
    // Find best view controller
    UIViewController *viewController = [[UIApplication sharedApplication].windows firstObject].rootViewController;
    return [self findBestViewController:viewController];
}

+ (UIViewController *)findBestViewController:(UIViewController *)vc {
    if (vc.presentedViewController) {
        // Return presented view controller
        return [self findBestViewController:vc.presentedViewController];
    } else if ([vc isKindOfClass:[UISplitViewController class]]) {
        // Return right hand side
        UISplitViewController *svc = (UISplitViewController *) vc;
        if (svc.viewControllers.count > 0)
            return [self findBestViewController:svc.viewControllers.lastObject];
        else
            return vc;
    } else if ([vc isKindOfClass:[UINavigationController class]]) {
        // Return top view
        UINavigationController *svc = (UINavigationController *) vc;
        if (svc.viewControllers.count > 0)
            return [self findBestViewController:svc.topViewController];
        else
            return vc;
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        // Return visible view
        UITabBarController *svc = (UITabBarController *) vc;
        if (svc.viewControllers.count > 0)
            return [self findBestViewController:svc.selectedViewController];
        else
            return vc;
    } else {
        // Unknown view controller type, return last child view controller
        return vc;
    }
}

+ (BOOL)isIPhoneXSeries {
    BOOL iPhoneXSeries = NO;
    if (UIDevice.currentDevice.userInterfaceIdiom != UIUserInterfaceIdiomPhone) {
        return iPhoneXSeries;
    }

    if (@available(iOS 11.0, *)) {
        UIWindow *mainWindow = [[[UIApplication sharedApplication] delegate] window];
        if (mainWindow.safeAreaInsets.bottom > 0.0) {
            iPhoneXSeries = YES;
        }
    }

    return iPhoneXSeries;
}

@end
