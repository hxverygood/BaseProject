//
//  NSString+Number.h
//  BaseProject
//
//  Created by apple on 2019/10/14.
//  Copyright © 2019 shawnhans. All rights reserved.
//


#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Number)

#pragma mark - 金额

/// 将字符串转换为数字，如果不是数字，则返回nil
- (NSNumber * _Nullable)convertToNumber;

/// 将数字字符串转换为1位小数+元
- (NSString * _Nullable)convertToMoneyWithOneDecimal;
/// 将数字字符串进行转换，保留2位小数
- (NSString * _Nullable)convertToMoneyWithTwoDecimal;
/// 将数字字符串进行转换，保留3位小数
- (NSString * _Nullable)convertToMoneyWithThreeDecimal;

/// 将数字字符串转换为千分位显示
- (NSString * _Nullable)convertWithThousandSeparator;
/// 将数字字符串转换为千分位显示，保留2位小数
- (NSString * _Nullable)convertWithThousandSeparatorAndTwoDigits;



#pragma mark - 数字
/**
 整数部分有多少位数字

 @return 正常情况:>=0；如果不是数字则返回-1
 */
- (NSInteger)integerLength;

/// 取出字符串中的数字
- (NSString * _Nullable)getDigitString;

/// 验证是否是数字
+ (BOOL)validateNumberWithString:(NSString *)s;

@end

NS_ASSUME_NONNULL_END
