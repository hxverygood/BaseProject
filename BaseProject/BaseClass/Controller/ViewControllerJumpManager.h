//
//  ViewControllerJumpManager.h
//  LDDriverSide
//
//  Created by shandiangou on 2018/6/5.
//  Copyright © 2018年 lightingdog. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ViewControllerJumpManager : NSObject

/// 判断是否登录
+ (BOOL)isLogin;

/// 没有登录，则present登录界面
+ (BOOL)isNotLoginAndJump;

@end
