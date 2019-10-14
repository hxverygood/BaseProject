//
//  HUD.h
//  LDDriverSide
//
//  Created by shandiangou on 2018/6/6.
//  Copyright © 2018年 lightingdog. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HUD : UIView

+ (void)defaultConfig;
/// HUD是否正在显示
+ (BOOL)isVisible;

+ (void)show;
+ (void)showWithStatus:(nullable NSString *)status;
+ (void)showInfoWithStatus:(nullable NSString *)status;
+ (void)showImage:(nullable UIImage *)image
           status:(nullable NSString *)status;
+ (void)showSuccessWithStatus:(nullable NSString*)status;
+ (void)showErrorWithStatus:(nullable NSString*)status;
+ (void)dismiss;
+ (void)dismissWithCompletion:(nullable void (^)(void))completion;

@end
