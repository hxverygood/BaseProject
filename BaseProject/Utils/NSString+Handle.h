//
//  NSString+HXString.h
//  Baili
//
//  Created by xabaili on 16/3/1.
//  Copyright © 2016年 Baili. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIkit.h>
#import <CommonCrypto/CommonDigest.h>

@interface NSString (Handle)

/// 判断字符串是否为空
+ (BOOL)isBlankString:(NSString * _Nullable)string;

/// 过滤字符串（空格、换行）
+ (NSString * _Nullable)filterWithString:(NSString * _Nullable)string;

/**
 获取字符串中指定字符后的子字符串

 @param chracter 指定字符
 @return 返回截取的子字符串
 */
- (NSString * _Nullable)substringBehindCharacter:(NSString * _Nullable)chracter;



#pragma mark - 隐藏部分字符

/// 隐藏中文名字
- (NSString * _Nullable)hidePartialName;
/// 隐藏身份证部分数字
- (NSString * _Nullable)hidePartialIdCardNumber;
/// 隐藏手机号部分数字
- (NSString * _Nullable)hidePhoneNumber;
/// 隐藏部分Email
- (NSString * _Nullable)hideEmail;
/// 截取银行卡号后4位
- (NSString * _Nullable)bankCardNumberLast4Digits;
/// 隐藏部分字符串
- (NSString * _Nullable)hideStringWithFrontPartialCount:(NSInteger)frontPartialCount
                                        endPartialCount:(NSInteger)endPartialCount;


#pragma mark - 其它

/// 判断字符串是否是url
- (BOOL)isUrl;

/// 转换为UTF8
- (NSString * _Nullable)toUTF8;



#pragma mark - 获取设备信息

//判断用户手机型号
+ (NSString * _Nonnull)deviceName;

// 获取系统版本号
+ (NSString * _Nonnull)systemVersion;



#pragma mark - Json String

/// JsonString转NSDictionary
- (NSDictionary * _Nullable)dictionaryWithJsonString;

/// JsonString加转义字符
- (NSString * _Nullable)addEscapeCharacter;





#pragma mark - 沙盒路径

/// 获取沙盒Documents路径
+ (NSString * _Nullable)sandboxDocumentDirectoryPath;


@end
