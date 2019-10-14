//
//  Hud.m
//  LDDriverSide
//
//  Created by shandiangou on 2018/6/6.
//  Copyright © 2018年 lightingdog. All rights reserved.
//

#import "HUD.h"
#import "SVProgressHUD_Extension.h"
#import "UIImage+GIFImage.h"

#define DEFAULT_BACKGROUND_COLOR    [UIColor colorWithRed:0.9f green:0.9f blue:0.9f alpha:0.9]
#define DEFAULT_FOREGROUND_COLOR    [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.75]
#define DEFAULT_MININUMSIZE         CGSizeMake(80.0, 80.0)
#define DEFAULT_IMAGEVIEWSIZE       CGSizeMake(28.0, 28.0)

@interface HUD ()

//@property (nonatomic, strong) UIColor *defaultBackgroundColor;

@end



@implementation HUD

#pragma mark - Getter

//- (UIColor *)defaultBackgroundColor {
//    if (!_defaultBackgroundColor) {
//        _defaultBackgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.75];
//    }
//    return _defaultBackgroundColor;
//}



#pragma mark - Method

+ (void)defaultConfig {
    // 配置SVProgressHUD
    [SVProgressHUD setMinimumDismissTimeInterval:1.0];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleCustom];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD setBackgroundColor:DEFAULT_BACKGROUND_COLOR];
    [SVProgressHUD setForegroundColor:DEFAULT_FOREGROUND_COLOR];
    [SVProgressHUD setCornerRadius:12.0f];
    [SVProgressHUD setMinimumSize:DEFAULT_MININUMSIZE];
    [SVProgressHUD sharedView].imageViewSize = DEFAULT_IMAGEVIEWSIZE;
    [SVProgressHUD sharedView].maxSupportedWindowLevel = UIWindowLevelAlert;
    [SVProgressHUD sharedView].backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.9];
}

+ (void)gifConfig {
    [SVProgressHUD setMinimumDismissTimeInterval:CGFLOAT_MAX];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleCustom];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD setBackgroundColor:DEFAULT_BACKGROUND_COLOR];
    [SVProgressHUD setForegroundColor:DEFAULT_FOREGROUND_COLOR];
    [SVProgressHUD setCornerRadius:12.0f];
    CGFloat imageViewWidth = 100.0;
    [SVProgressHUD setMinimumSize:CGSizeMake(imageViewWidth + 30.0, imageViewWidth + 30.0)];
    [SVProgressHUD sharedView].imageViewSize = CGSizeMake(imageViewWidth, imageViewWidth);
    [SVProgressHUD sharedView].maxSupportedWindowLevel = UIWindowLevelAlert;
    [SVProgressHUD sharedView].backgroundColor = [UIColor clearColor];
}

/// HUD是否正在显示
+ (BOOL)isVisible {
    BOOL isVisible = [SVProgressHUD isVisible];
    return isVisible;
}

+ (void)show {
//    [SVProgressHUD show];

    [HUD gifConfig];
    [SVProgressHUD showImage:[UIImage imageWithGIFNamed:@"loading"] status:nil];
}

+ (void)showWithStatus:(NSString *)status {
    [HUD gifConfig];
    [SVProgressHUD showImage:[UIImage imageWithGIFNamed:@"loading"] status:status];
//    [SVProgressHUD showWithStatus:status];
}

+ (void)showInfoWithStatus:(nullable NSString *)status {
    [HUD dismiss];
    [HUD defaultConfig];
    [SVProgressHUD showInfoWithStatus:status];
}

+ (void)showImage:(UIImage *)image
           status:(NSString *)status {
    [HUD defaultConfig];
    [SVProgressHUD showImage:image status:status];
}

+ (void)showSuccessWithStatus:(nullable NSString*)status {
    [HUD dismiss];
    [HUD defaultConfig];
    [SVProgressHUD showSuccessWithStatus:status];
}

+ (void)showErrorWithStatus:(nullable NSString*)status {
    [HUD dismiss];
    [HUD defaultConfig];
    [SVProgressHUD showErrorWithStatus:status];
}

+ (void)dismiss {
    [SVProgressHUD dismiss];
}

+ (void)dismissWithCompletion:(nullable void (^)(void))completion {
    [SVProgressHUD dismissWithCompletion:^{
        if (completion) {
            completion();
        }
    }];
}

@end
