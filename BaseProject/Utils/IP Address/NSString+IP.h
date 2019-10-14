//
//  NSString+IP.h
//  LDDriverSide
//
//  Created by shandiangou on 2018/9/22.
//  Copyright © 2018年 lightingdog. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (IP)

/// 获取手机IP
+ (NSString * _Nullable)getIPAddressWithIPv4:(BOOL)preferIPv4;

@end
