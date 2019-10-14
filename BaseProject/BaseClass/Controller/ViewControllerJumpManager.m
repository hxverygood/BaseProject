//
//  ViewControllerJumpManager.m
//  LDDriverSide
//
//  Created by shandiangou on 2018/6/5.
//  Copyright © 2018年 lightingdog. All rights reserved.
//

#import "ViewControllerJumpManager.h"
#import "LoginInfo.h"
//#import "LoginViewController.h"

@implementation ViewControllerJumpManager

/// 判断是否登录
+ (BOOL)isLogin {
    return [LoginInfo judgeLoginStatus];
}

/// 没有登录，则present登录界面
+ (BOOL)isNotLoginAndJump {
#warning fix: test
    //判断是否登录，如果没有登录则跳转至登录界面
//    if (![LoginInfo judgeLoginStatus]) {
//        LoginViewController *vc = [[LoginViewController alloc] init];
//        vc.navbarIsTranslucent = YES;
//        vc.hidesBottomBarWhenPushed = YES;
//        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:vc];
//        UIViewController *currentVC = [ViewControllerJumpManager currentViewController];
//        [currentVC presentViewController:navi animated:YES completion:nil];
//        return YES;
//    }
    return NO;
}




#pragma mark - Private

/// 获取当前VC
+ (__kindof UIViewController *)currentViewController {
    // Find best view controller
    UIViewController *viewController = [[UIApplication sharedApplication].windows firstObject].rootViewController;
    return [ViewControllerJumpManager findBestViewController:viewController];
}

+ (UIViewController *)findBestViewController:(UIViewController *)vc {
    if (vc.presentedViewController) {
        // Return presented view controller
        return [ViewControllerJumpManager findBestViewController:vc.presentedViewController];
    } else if ([vc isKindOfClass:[UISplitViewController class]]) {
        // Return right hand side
        UISplitViewController *svc = (UISplitViewController *) vc;
        if (svc.viewControllers.count > 0)
            return [ViewControllerJumpManager findBestViewController:svc.viewControllers.lastObject];
        else
            return vc;
    } else if ([vc isKindOfClass:[UINavigationController class]]) {
        // Return top view
        UINavigationController *svc = (UINavigationController *) vc;
        if (svc.viewControllers.count > 0)
            return [ViewControllerJumpManager findBestViewController:svc.topViewController];
        else
            return vc;
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        // Return visible view
        UITabBarController *svc = (UITabBarController *) vc;
        if (svc.viewControllers.count > 0)
            return [ViewControllerJumpManager findBestViewController:svc.selectedViewController];
        else
            return vc;
    } else {
        // Unknown view controller type, return last child view controller
        return vc;
    }
}

@end
