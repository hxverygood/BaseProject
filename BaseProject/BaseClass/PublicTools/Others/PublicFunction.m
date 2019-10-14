//
//  PublicFunction.m
//  LDDriverSide
//
//  Created by shandiangou on 2018/6/9.
//  Copyright © 2018年 lightingdog. All rights reserved.
//

#import "PublicFunction.h"
#import "NSString+Number.h"
#import "HUD.h"


static NSString * const AppUsageKey = @"APP_USAGE";
static NSString * const AppFirstRunningKey = @"APP_FIRST_RUNNING";
static NSString * const AppVersionKey = @"APP_VERSION";
static NSString * const LoginPhoneKey = @"LOGIN_PHONE";


@interface PublicFunction ()

@end



@implementation PublicFunction

#pragma mark - Getter

// 获得应用自定义名称
+ (NSString *)appDisplayName {
    NSString *displayName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
    return displayName;
}

+ (NSString *)bundleName {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"];
}

+ (NSString *)bundleID {
    return [[NSBundle mainBundle] bundleIdentifier];
}

// 获取App的版本号
+ (NSString *)appVersion {
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    return [infoDic objectForKey:@"CFBundleShortVersionString"];
}

/// 是否是第1次运行App
+ (BOOL)isAppFirstRunning {
    NSDictionary *dict = [self getAppInfo];
    if (dict == nil) {
        NSLog(@"--------> 🌹app是第1次运行 <--------");
        return YES;
    }
    else {
        NSNumber *isFirstRunning = [dict objectForKey:AppFirstRunningKey];
        if (isFirstRunning == nil ||
            isFirstRunning.boolValue == YES) {
            NSLog(@"--------> 🌹app是第1次运行 <--------");
            return YES;
        }
        else {
            NSLog(@"--------> ❎app不是第一次运行 <--------");
            return NO;
        }
    }
}

/// 是否是更新后第1次运行App
+ (BOOL)isAppUpdate {
    NSDictionary *dict = [PublicFunction getAppInfo];
    if (dict == nil) {
        NSLog(@"--------> ☀️app已更新: 保存的 dict 为空 <--------");
        return YES;
    }
    else {
        NSString *appOldVersion = [dict objectForKey:AppVersionKey];
        if ([PublicFunction isBlankString:appOldVersion]) {
            NSLog(@"--------> ☀️app已更新: 保存的 version 为空 <--------");
            return YES;
        }
        else {
            appOldVersion = [appOldVersion stringByReplacingOccurrencesOfString:@" " withString:@""];
            appOldVersion = [appOldVersion stringByReplacingOccurrencesOfString:@"." withString:@""];


            NSString *currentVersion = [PublicFunction appVersion];
            if ([PublicFunction isBlankString:currentVersion]) {
                NSLog(@"--------> ☀️app已更新: 获取当前 version 为空 <--------");
                return YES;
            }

            currentVersion = [currentVersion stringByReplacingOccurrencesOfString:@" " withString:@""];
            currentVersion = [currentVersion stringByReplacingOccurrencesOfString:@"." withString:@""];

            NSNumber *appOldVersionNumber = [appOldVersion convertToNumber];
            NSNumber *currentVersionNumber = [currentVersion convertToNumber];

            if (appOldVersionNumber && currentVersionNumber) {
                if (currentVersionNumber.integerValue > appOldVersionNumber.integerValue) {
                    NSLog(@"--------> ☀️app已更新 <--------");
                    return YES;
                }
            }

            NSLog(@"--------> ❎app没有更新 <--------");
            return NO;
        }
    }
}


/**
 第1次安装app或更新后第1次运行，则手动调用此方法保存状态信息。
 此功能是根据特定需求开发的，使用时请注意。
 */
+ (void)saveRunningState {
    NSDictionary *dict = [PublicFunction getAppInfo];
    NSString *appVersion = [PublicFunction appVersion];

    if ([PublicFunction isBlankString:appVersion]) {
        return;
    }

    if (dict == nil) {
        dict = @{ AppFirstRunningKey : @(NO),
                  AppVersionKey : appVersion };
        [PublicFunction saveAppInfo:dict];
    }
    else {
        NSMutableDictionary *mutDict = [NSMutableDictionary dictionaryWithDictionary:dict];
        [mutDict setObject:@(NO) forKey:AppFirstRunningKey];
        [mutDict setObject:appVersion forKey:AppVersionKey];
        [PublicFunction saveAppInfo:[mutDict copy]];
    }
}



#pragma mark - 记录登录手机号

/// 将登录手机号保存在 userDefaults
+ (void)saveLoginPhoneInUserDefaults:(NSString *)phone {
    if ([PublicFunction isBlankString:phone] == NO) {
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        [userDefault setObject:phone forKey:LoginPhoneKey];
        [userDefault synchronize];
    }
}

/// 从 userDefaults 获取登录手机号
+ (NSString *)getLoginPhoneFromUserDefaults {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *phone = [userDefault objectForKey:LoginPhoneKey];
    return phone;
}

/// 删除 userDefaults 中的手机号
+ (void)removeLoginPhoneFromUserDefaults {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault removeObjectForKey:LoginPhoneKey];
    [userDefault synchronize];
}



#pragma mark - 其它

/// 屏幕常亮
+ (void)screenAlwaysOn:(BOOL)turnOn {
    [UIApplication sharedApplication].idleTimerDisabled = turnOn;
}


#pragma mark 拨打电话

+ (void)callWithPhoneLinks:(NSString *)phoneLinks {
    NSURL *phoneUrl = [NSURL URLWithString:phoneLinks];

    if ([[UIApplication sharedApplication] canOpenURL:phoneUrl]) {
        [[UIApplication sharedApplication] openURL:phoneUrl];
    }
    else {
        [HUD showInfoWithStatus:@"无法拨打电话"];
    }
}

+ (void)callWithPhoneNumber:(NSString *)phone {
    NSString *phoneUrlStr = [NSString stringWithFormat:@"tel://%@", phone];
    NSURL *phoneUrl = [NSURL URLWithString:phoneUrlStr];
    if ([[UIApplication sharedApplication] canOpenURL:phoneUrl]) {
        [[UIApplication sharedApplication] openURL:phoneUrl];
    }
    else {
        [HUD showInfoWithStatus:@"无法拨打电话"];
    }
}



#pragma mark  - Private Func

+ (NSDictionary *)getAppInfo {
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] dictionaryForKey:AppUsageKey];
    return dict;
}

+ (void)saveAppInfo:(NSDictionary *)dict {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:dict forKey:AppUsageKey];
    [userDefault synchronize];
}

/// 判断字符串是否为空
+ (BOOL)isBlankString:(NSString *)string {
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}



#pragma mark 计算缓存
/**
 *  计算整个Cache目录大小
 */
+ (float)cacheFolderSize {
    NSString *folderPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];

    NSFileManager * manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath :folderPath]) {
        return 0 ;
    }
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString *fileName;
    long long folderSize = 0 ;
    while ((fileName = [childFilesEnumerator nextObject]) != nil ){
        NSString * fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }

    return folderSize/( 1024.0 * 1024.0 );
}

/**
 *  计算单个文件大小
 */
+ (long long)fileSizeAtPath:(NSString *)filePath {

    NSFileManager *manager = [NSFileManager defaultManager];

    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0 ;

}


/// 清理Cache目录缓存
+ (void)clearCacheFolderWithCompletion:(void (^)(BOOL finished))completion {
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains (NSCachesDirectory , NSUserDomainMask, YES) firstObject];
    NSArray *files = [[NSFileManager defaultManager ] subpathsAtPath:cachePath];
    //NSLog ( @"cachpath = %@" , cachePath);
    for (NSString *p in files) {

        NSError *error = nil;
        //获取文件全路径
        NSString *fileAbsolutePath = [cachePath stringByAppendingPathComponent:p];

        if ([[NSFileManager defaultManager] fileExistsAtPath:fileAbsolutePath]) {
            [[NSFileManager defaultManager] removeItemAtPath:fileAbsolutePath error:&error];
        }
    }

    if (completion) {
        completion(YES);
    }
}


@end
