//
//  PublicFunction.h
//  LDDriverSide
//
//  Created by shandiangou on 2018/6/9.
//  Copyright © 2018年 lightingdog. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PublicFunction : NSObject

// 获得应用自定义名称
+ (NSString *)appDisplayName;
+ (NSString *)bundleName;
+ (NSString *)bundleID;
/// 获取App的版本号
+ (NSString *)appVersion;

/// 是否是第1次运行App
+ (BOOL)isAppFirstRunning;
/// App是否进行了更新
+ (BOOL)isAppUpdate;
/**
 第1次安装app或更新后第1次运行，则手动调用此方法保存状态信息。
 此功能是根据特定需求开发的，使用时请注意。
 */
+ (void)saveRunningState;

#pragma mark - 记录登录手机号

/// 将登录手机号保存在 userDefaults
+ (void)saveLoginPhoneInUserDefaults:(NSString *)phone;
/// 从 userDefaults 获取登录手机号
+ (NSString *)getLoginPhoneFromUserDefaults;
/// 删除 userDefaults 中的手机号
+ (void)removeLoginPhoneFromUserDefaults;


#pragma mark - 其它

/// 屏幕常亮
+ (void)screenAlwaysOn:(BOOL)turnOn;

/// 计算整个Cache目录大小
+ (float)cacheFolderSize;
/// 清理Cache目录缓存
+ (void)clearCacheFolderWithCompletion:(void (^)(BOOL finished))completion;


#pragma mark 拨打电话
+ (void)callWithPhoneLinks:(NSString *)phoneLinks;
+ (void)callWithPhoneNumber:(NSString *)phone;

@end
