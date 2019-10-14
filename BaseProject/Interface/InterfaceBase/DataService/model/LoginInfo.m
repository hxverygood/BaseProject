//
//  LoginInfo.m
//

#import "LoginInfo.h"
#import "User.h"

static NSString *const kLoginInfoFileName = @"info";


@interface LoginInfo ()

//@property (nonatomic, strong) NSArray *productNames;

@end



@implementation LoginInfo

#pragma mark - Login Status
/// 判断是否登录
+ (BOOL)judgeLoginStatus{
    if ([LoginInfo savedLoginInfo]) {
        return YES;
    }
    return NO;
}



#pragma mark - 登录信息的保存、读取、删除
/// 登录后，保存用户信息
+ (void)saveLoginInfo:(nonnull User *)model {
    NSString *path = [self pathForName:kLoginInfoFileName];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:model];
    if (data) {
        __unused BOOL success = [data writeToFile:path atomically:YES];
    }
}

/// 获取保存的用户登录信息
+ (nullable User *)savedLoginInfo {
    NSString *path = [self pathForName:kLoginInfoFileName];
    id obj = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    if ([obj isKindOfClass:[User class]]) {
        return obj;
    } else {
        return nil;
    }
}

/// 删除保存的登录信息
+ (void)removeSavedLoginInfo {
    NSString *path = [self pathForName:kLoginInfoFileName];
    BOOL exist = [[NSFileManager defaultManager] fileExistsAtPath:path];
    if (exist) {
        [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
    }
    
//    // 删除sessionId
//    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"com.xabaili.sessionid"];
}



#pragma mark - 重置及删除保存的信息

/// 删除所有本地归档的数据
//+ (void)removeAllSavedInfo {
//    [LoginInfo removeSavedLoginInfo];
//}

/// 重置UserDefault信息
//+ (void)resetUserDefault {
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    [userDefaults setBool:YES forKey:kVoiceBroadcast];
//    [userDefaults setBool:NO forKey:kAcceptOrder];
//    [userDefaults synchronize];
//}



#pragma mark - Func

+ (NSString *)pathForName:(NSString *)name {
    NSArray *array =  NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    return [array[0] stringByAppendingPathComponent:name];
}

@end
