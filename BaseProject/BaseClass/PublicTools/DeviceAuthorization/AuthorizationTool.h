//
//  AuthorizationTool.h
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, AuthorizationStatus) {
    AuthorizationStatusAuthorized = 0,    // 已授权
    AuthorizationStatusDenied,            // 拒绝
    AuthorizationStatusRestricted,        // 应用没有相关权限，且当前用户无法改变这个权限，比如:家长控制
    AuthorizationStatusNotSupport         // 硬件等不支持
};

// 定位权限枚举
typedef NS_ENUM(NSUInteger, LocationAuthorizationStatus) {
    LocationAuthorizationStatusNotDetermined = 0,
    LocationAuthorizationStatusAuthorizedAlways,        // 一直允许定位
    LocationAuthorizationStatusAuthorizedWhenInUse,     // 使用时定位
    LocationAuthorizationStatusDenied,                  // 拒绝
    LocationAuthorizationStatusRestricted,              // 应用没有相关权限，且当前用户无法改变这个权限，比如:家长控制
    LocationAuthorizationStatusNotSuppot
};


@interface AuthorizationTool : NSObject

/**
 *  请求相册访问权限
 *
 *  @param callback 授权状态回调
 */
+ (void)requestImagePickerAuthorization:(void(^)(AuthorizationStatus status))callback;

/**
 *  请求相机权限
 *
 *  @param callback 授权状态回调
 */
+ (void)requestCameraAuthorization:(void(^)(AuthorizationStatus status))callback;

/**
 *  通讯录权限
 *
 *  @param callback 授权状态回调
 */
+ (void)requestAddressBookAuthorization:(void (^)(AuthorizationStatus status))callback;
/**
 *  定位权限
 *
 *  @param callback 授权状态回调
 */
+ (void)requestLocationAuthorization:(void (^)(LocationAuthorizationStatus status))callback;

@end
