//
//  CheckInput.h
//  BaiLi
//
//  Created by xabaili on 15/10/30.
//  Copyright © 2015年 Hans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CheckInput : NSObject

/// 身份证号
+ (BOOL)validateIdentityCard: (NSString *)identityCard;
/// 邮箱
+ (BOOL)validateEmail:(NSString *)email;
/// 邮编
+ (BOOL)validatePostcode:(NSString *)postcode;
/// 手机号
+ (BOOL)validateMobile:(NSString *)mobile;
/// 固定电话区号
+ (BOOL)validateTelAreaNumber:(NSString *)telAreaNumber;
/// 固定电话
+ (BOOL)validateTelNumber:(NSString *)telNumber;
//完整固定电话号码，中间用 - 分隔
//+ (BOOL) validateTotalTelNumber:(NSString *)telNumber;
/// 判断是否是中文
+ (BOOL)validateHan:(NSString *)string;
//是否包含中文
+ (BOOL)includeHan:(NSString *)string;

/// 中文、英文、数字
+ (BOOL)validateHanAndEnglishAndNumber:(NSString *)string;

/// 是否是正整数和0
+ (BOOL)validatePositiveNumber:(NSString *)string;

/// 正整数和0（需要输入整数有几位数字）
+ (BOOL)validatePositiveNumber:(NSString *)string
                 digitQuantity:(NSInteger)quantity;

/// 判断 CGFloat 类型的数字是否是整数
+ (BOOL)validatePositiveNumberWithFloat:(CGFloat)floatValue;

/// 验证码及位数
+ (BOOL)validateVerifyCode:(NSString *)string;

/// 验证是否是数字
+ (BOOL)validateNumberWithString:(NSString *)s;

/// 验证是否是数字，及数字位数
+ (BOOL)validateNumberWithString:(NSString*)number
                andDigitQuantity:(NSInteger)quantity;
/// 正整数+小数
+ (BOOL)validateWholeNumberAndDecimal:(NSString *)string;

/// 小数
+ (BOOL)validateDecimal:(NSString *)string;

/// 数字+逗号
+ (BOOL)validateNumberAndComma:(NSString *)string;

/// 判断输入的是否是金额
+ (BOOL)validateMoney:(NSString *)money;

/// 只验证字符数量
+ (BOOL)validateCharacterQuantity:(NSString *)string;

/// 检查银行卡是否合法(Luhn算法)
+ (BOOL)validateCardNumber:(NSString *)cardNumber;

/// 统计字数（除了空格等）
+ (int)countWord:(NSString *)s;

/// 检查车牌号是否合法
+ (BOOL)validateCarPlateNumber:(NSString *)string;

/// 简单地检查驾驶证号是否正确（1-18位字母、数字组成）
+ (BOOL)validateDriverLicenseNumber:(NSString *)string;

@end
