//
//  NSString+Number.m
//  BaseProject
//
//  Created by apple on 2019/10/14.
//  Copyright © 2019 shawnhans. All rights reserved.
//

#import "NSString+Number.h"


@implementation NSString (Number)

#pragma mark - 金额

/// 将字符串转换为数字，如果不是数字，则返回nil
- (NSNumber * _Nullable)convertToNumber {
    if (!self) {
        return nil;
    }
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumber *numberObj = [formatter numberFromString:self];
    return numberObj;
}

/// 将数字字符串转换为1位小数+元
- (NSString * _Nullable)convertToMoneyWithOneDecimal {
    if (!self) {
        return nil;
    }

    NSNumber *num = [self convertToNumber];
    if (num == nil) {
        return nil;
    }

    NSString *result = [NSString stringWithFormat:@"%.1f", num.floatValue];
    return result;
}

/// 将数字字符串进行转换，保留2位小数
- (NSString * _Nullable)convertToMoneyWithTwoDecimal {
    NSNumber *num = [self convertToNumber];
    if (num == nil) {
        return nil;
    }

    // 保留小数点后2位
    NSString *convertStr = [self reserveDecimalPartWithDigitCount:2 roundingMode:NSRoundUp];
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    //    numberFormatter.maximumFractionDigits = decimalCount;    //设置最大小数点后的位数
    //    numberFormatter.minimumFractionDigits = decimalCount;    //设置最小小数点后的位数
    [numberFormatter setPositiveFormat:@"0.00;"];
    [numberFormatter setNegativeFormat:@"-0.00;"];
    NSString *resultStr = [numberFormatter stringFromNumber:[NSNumber numberWithDouble:[convertStr doubleValue]]];
    return [resultStr copy];
}

/// 将数字字符串进行转换，保留3位小数
- (NSString * _Nullable)convertToMoneyWithThreeDecimal {
    NSNumber *num = [self convertToNumber];
    if (num == nil) {
        return nil;
    }

    // 保留小数点后2位
    NSString *convertStr = [self reserveDecimalPartWithDigitCount:3 roundingMode:NSRoundUp];
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
//    numberFormatter.maximumFractionDigits = decimalCount;    //设置最大小数点后的位数
//    numberFormatter.minimumFractionDigits = decimalCount;    //设置最小小数点后的位数
    [numberFormatter setPositiveFormat:@"0.000;"];
    [numberFormatter setNegativeFormat:@"-0.000;"];
    NSString *resultStr = [numberFormatter stringFromNumber:[NSNumber numberWithDouble:[convertStr doubleValue]]];
    return [resultStr copy];
}

/// 将数字字符串转换为千分位显示
- (NSString * _Nullable)convertWithThousandSeparator {
    if (!self) {
        return nil;
    }
    
    // 判断是否是数字
    NSNumber *num = [self convertToNumber];
    if (num == nil) {
        return nil;
    }
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setPositiveFormat:@",###;"];
    NSString *resultStr = [numberFormatter stringFromNumber:[NSNumber numberWithInteger:[self integerValue]]];
    return [resultStr copy];
}

/// 将数字字符串转换为千分位显示，保留2位小数
- (NSString * _Nullable)convertWithThousandSeparatorAndTwoDigits {
    if (!self) {
        return nil;
    }
    
    // 判断是否是数字
    NSNumber *num = [self convertToNumber];
    if (num == nil) {
        return nil;
    }
    
    // 保留小数点后2位
    NSString *convertStr = [self reserveDecimalPartWithDigitCount:2 roundingMode:NSRoundUp];
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setPositiveFormat:@"###,##0.00;"];
    NSString *resultStr = [numberFormatter stringFromNumber:[NSNumber numberWithDouble:[convertStr doubleValue]]];
    return [resultStr copy];
}

/// 保留小数点后指定的位数
- (NSString * _Nullable)reserveDecimalPartWithDigitCount:(NSInteger)count
                                            roundingMode:(NSRoundingMode)roundMode {
    if (self == nil) {
        return nil;
    }

    // 判断是否是数字
    NSNumber *num = [self convertToNumber];
    if (num == nil) {
        return nil;
    }

    // 如果是负数，并且是向上进位模式，则更改为相反的模式才能拿到正确结果
    if (self.floatValue < 0.0) {
        if (roundMode == NSRoundUp) {
            roundMode = NSRoundDown;
        }
        else if (roundMode == NSRoundDown) {
            roundMode = NSRoundUp;
        }
    }

    // 先保留小数点后n位
    NSString *convertStr = nil;
    NSRange decimalPoint = [self rangeOfString:@"."];
    NSInteger toIndex = -1;

    if (decimalPoint.length > 0) {
        toIndex = decimalPoint.location + count + 1;
    }

    if (toIndex != -1 &&
        toIndex < self.length - 1) {
        convertStr = [self substringToIndex:toIndex+1];
    }
    else {
        convertStr = self;
    }

    NSDecimalNumberHandler *handler = [NSDecimalNumberHandler
                                       decimalNumberHandlerWithRoundingMode:roundMode
                                       scale:count
                                       raiseOnExactness:NO
                                       raiseOnOverflow:NO
                                       raiseOnUnderflow:NO
                                       raiseOnDivideByZero:YES];

    // 通过字符串计算金额
    NSDecimalNumber *decimalNumber = [NSDecimalNumber decimalNumberWithString:convertStr];
    NSDecimalNumber *resultDecimalNumber = [decimalNumber decimalNumberByRoundingAccordingToBehavior:handler];
    NSString *resultDecimalStr = [NSString stringWithFormat:@"%@", resultDecimalNumber];

    // 显示2位小数
    NSString *format = [NSString stringWithFormat:@"%%.%ldf", (long)count];
    double number = [resultDecimalStr doubleValue];
    NSString *resultStr = [NSString stringWithFormat:format, number];

    return resultStr;
}



#pragma mark - 数字

/**
 整数部分有多少位数字
 
 @return 正常情况:>=0；如果不是数字则返回-1
 */
- (NSInteger)integerLength {
    NSNumber *num = [self convertToNumber];
    if (num == nil) {
        return -1;
    }
    
    NSInteger x = [self doubleValue];
    NSInteger sum=0,j=1;
    
    while( x >= 1 ) {
        x=x/10;
        sum++;
        j=j*10;
    }
    
    return sum;
}

/// 取出字符串中的数字
- (NSString * _Nullable)getDigitString {
    NSCharacterSet *nonDigits =[[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    NSString *digitsStr = [self stringByTrimmingCharactersInSet:nonDigits];
    if ([NSString validateNumberWithString:digitsStr]) {
        return digitsStr;
    }
    else {
        return nil;
    }
}


/// 验证是否是数字
+ (BOOL)validateNumberWithString:(NSString *)s {
    char c;
    for (int i = 0; i < s.length; i++) {
        c = [s characterAtIndex:i];
        if (isdigit(c) == NO) {
            return NO;
        }
    }
    return YES;
}

@end
