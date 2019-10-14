//
//  HSLoginInfo.h
//  Hoomsun
//
//  Created by Hans on 16/1/11.
//  Copyright © 2016年 Hoomsun. All rights reserved.
//

#import <Foundation/Foundation.h>

@class User;

#pragma mark - 登录信息的保存、读取、删除
// 登录信息
@interface LoginInfo : NSObject

/// 判断是否登录
+ (BOOL)judgeLoginStatus;

/// 登录后，保存用户信息
+ (void)saveLoginInfo:(nonnull User *)model;

/// 登录后，保存用户信息
+ (nullable User *)savedLoginInfo;
/// 删除保存的用户信息
+ (void)removeSavedLoginInfo;



#pragma mark - 重置及删除保存的信息

/// 删除所有本地归档的数据
//+ (void)removeAllSavedInfo;
/// 重置UserDefault信息
//+ (void)resetUserDefault;


@end
