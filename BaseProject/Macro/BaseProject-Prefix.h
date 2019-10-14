//
//  BaseProject-Prefix.h
//
//  Created by shawnhans on 2019/10/14.
//  Copyright © 2019年 shawnhans. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProjectHeaderFile.h"

#ifndef BaseProject_Prefix_h
#define LDDriverSide_Prefix_h

#pragma mark - COLOR
/*--------------- COLOR ---------------*/
#define MAIN_COLOR              [UIColor colorWithRed:255/255.0 green:214/255.0 blue:83/255.0  alpha:1.0]
#define BACKGROUND_COLOR        [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0]
#define BLACK_COLOR             [UIColor colorWithRed:36/255.0  green:36/255.0  blue:36/255.0  alpha:1.0]
#define GRAY_COLOR              [UIColor colorWithRed:90/255.0  green:90/255.0  blue:90/255.0  alpha:1.0]
#define LIGHT_GRAY              [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0]
#define GRAY180                 [UIColor colorWithRed:180/255.0 green:180/255.0 blue:180/255.0 alpha:1.0]
#define BUTTON_COLOR            [UIColor colorWithRed:255/255.0 green:214/255.0 blue:83/255.0  alpha:1.0]
#define LINE_COLOR              [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0]

#define RGBCOLOR(r,g,b)         [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define RGBACOLOR(r,g,b,a)      [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]
#define HEXCOLOR(rgbValue)      [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]



#pragma mark - 手机尺寸

/*--------------- 系统型号、版本 ---------------*/
// 判断屏幕尺寸
#define iphone4x_3_5 ([UIScreen mainScreen].bounds.size.height==480.0f)
#define iphone5x_4_0 ([UIScreen mainScreen].bounds.size.height==568.0f)
#define iphone6_4_7 ([UIScreen mainScreen].bounds.size.height==667.0f)
#define iphonePlus_5_5 ([UIScreen mainScreen].bounds.size.height==736.0f && [UIScreen mainScreen].bounds.size.width==414.0f)

// 判断是否是 iPhoneX 刘海屏系列手机
static inline BOOL isIPhoneXSeries() {
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

// 获取 iPhoneX 刘海屏系列手机顶部高度差
static inline CGFloat isIPhoneXSeries_Top_Offset() {
    return isIPhoneXSeries() ? 24.0 : 0.0;
}

// 获取 iPhoneX 刘海屏系列手机底部高度差
static inline CGFloat isIPhoneXSeries_Bottom_Offset() {
    return isIPhoneXSeries() ? 34.0 : 0.0;
}



#pragma mark - 其它功能

/// Release模式下（发布的app）防止NSLog再打印信息消耗系统资源，也防止截获信息
#warning fix: print log

#if DEBUG
#define NSLog(...) NSLog(__VA_ARGS__)
#else
#define NSLog(...)
#endif

/// 去除空字符
#define TRIM(string) [string stringByReplacingOccurrencesOfString:@" " withString:@""]
#define APPDELEGATE  ((AppDelegate *)[UIApplication sharedApplication].delegate)


#pragma mark - 其它参数

#define SCREEN_WIDTH            [UIScreen mainScreen].bounds.size.width

#define TABBAR_HEIGHT           49.0
#define RADIUS                  6.0


/// 验证码位数
#define VERIFY_CODE_COUNT       6
/// 密码最小长度
#define PASSWORD_MIN_COUNT      6
/// 密码最大长度
#define PASSWORD_MAX_COUNT      16
/// 密码位数不足的提示信息
#define PASSWORD_WARNING    [NSString stringWithFormat:@"密码由%ld-%ld位数字和字母组成", (long)PASSWORD_MIN_COUNT, (long)PASSWORD_MAX_COUNT]

/// 倒计时
#ifdef DEBUG
#define COUNT_DOWN_TIME         60
#else
#define COUNT_DOWN_TIME         60
#endif

#endif /* LDDriverSide_Prefix_h */
