//
//  NSString+HXDate.m
//  Baili
//
//  Created by xabaili on 16/1/9.
//  Copyright © 2016年 Baili. All rights reserved.
//

#import "NSString+Date.h"


@implementation NSString (Date)

/**
 *  将时间NSDate转换为字符串
 *
 *  @param timestamp        时间戳(double类型)
 *  @param dateFormaterType 包含种格式
 *  @param separator    年月日之间的分隔符
 *  @return 返回一个字符串
 */
+ (NSString * _Nullable)dateStringFromTimestamp:(NSTimeInterval)timestamp
                                  dateFormatter:(DateFormatterType)dateFormaterType
                                      separator:(NSString * _Nullable)separator {
    
    // 计算时间戳数字位数
    NSInteger tmp = timestamp / 1000000000;
    if (tmp > 10) {
        NSInteger count = 1;
        double time = tmp;
        while (time / 10 >= 1) {
            time = time / 10;
            count *= 10;
        }
        timestamp /= count;
    }
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp];
    
    NSDateFormatter *formatter = [self getDateFormatterWithType:dateFormaterType separator:separator];
    
    NSLocale *local = [[NSLocale alloc] initWithLocaleIdentifier:@"zh"];
    formatter.locale = local;
    
    NSString *dateStr = [formatter stringFromDate:date];
    return dateStr;
}

/**
 *  将一定格式的时间字符串转换为时间戳
 *
 *  @param timestampString 时间戳字符串
 *  @param dateFormaterType 日期格式类型enum
 *  @param separator 格式化日期中年月日中间的分隔符
 *  @return 格式化日期字符串
 */
+ (NSString * _Nullable)dateStringFromTimestampString:(NSString * _Nullable)timestampString dateFormatter:(DateFormatterType)dateFormaterType separator:(NSString * _Nullable)separator {
    if ([NSString isBlankString:timestampString]) {
        return nil;
    }

    NSNumber *timeNum = [timestampString convertToNumber];
    if (timeNum != nil) {
        NSString *sep = [NSString isBlankString:separator] ? @"-" : separator;
        NSString *timeStr = [NSString dateStringFromTimestamp:timeNum.unsignedLongValue dateFormatter:dateFormaterType separator:sep];
        return timeStr;
    }
    else {
        return timestampString;
    }
}


/**
 *  获取当前时间戳对应的日期字符串
 *
 *  @param formaterType 格式化日期类型enum
 *  @param separator    年月日之间的分隔符
 *  @return 返回一个字符串
 */
+ (NSString * _Nullable)dateStringFromTimestampWithFormatter:(DateFormatterType)formaterType
separator:(NSString * _Nullable)separator {
    NSDate *date = [NSDate date];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    switch (formaterType) {
        case DateFormatterTypeYM:
            if ([NSString isBlankString:separator]) {
                formatter.dateFormat = [NSString stringWithFormat:@"yyyy年MM月"];
            }
            else {
                formatter.dateFormat = [NSString stringWithFormat:@"yyyy%@MM", separator];
            }
        break;
            
        case DateFormatterTypeYMd:
            formatter.dateFormat = [NSString stringWithFormat:@"yyyy%@MM%@dd", separator, separator];
            break;
            
        case DateFormatterTypeYMdKKmm:
            formatter.dateFormat = [NSString stringWithFormat:@"yyyy%@MM%@dd HH:mm", separator, separator];
            break;
            
        case DateFormatterTypeYMdKKmmss:
            formatter.dateFormat = [NSString stringWithFormat:@"yyyy%@MM%@dd HH:mm:ss", separator, separator];
            break;
            
        default:
            break;
    }
    
    NSLocale *local = [[NSLocale alloc] initWithLocaleIdentifier:@"zh"];
    formatter.locale = local;
    
    NSString *dateStr = [formatter stringFromDate:date];
    return dateStr;
}

/**
 *  将格式化时间字符串转换为时间戳
 *
 *  @param dateString 格式化日期
 *  @param formatterType 日期格式类型枚举
 *  @return 时间戳字符串
 */
+ (NSString * _Nullable)timestampStringFromDateString:(NSString * _Nullable)dateString formatterType:(DateFormatterType)formatterType {
    if ([self isBlankString:dateString]) {
        return nil;
    }

    NSString *timestampStr = nil;
    NSString *separator = @"";
    if ([dateString containsString:@"-"]) {
        separator = @"-";
    }
    else if ([dateString containsString:@"."]) {
        separator = @".";
    }

    timestampStr = [NSString timestampStringFromDateString:dateString formatterType:DateFormatterTypeYMdKKmm separator:separator];

    return timestampStr;
}


/**
 *  将一定格式的时间字符串转换为时间戳，需指定日期的格式
 *
 *  @param dateString 格式化日期
 *  @param formatterString 日期格式(字符串形式)
 *  @return 时间戳字符串
 */
+ (NSString * _Nullable)timestampStringFromDateString:(NSString * _Nullable)dateString formatterString:(NSString * _Nullable)formatterString {
    if ([self isBlankString:dateString]) {
        return nil;
    }

    if ([self isBlankString:formatterString]) {
        formatterString = @"yyyy%@MM%@dd HH:mm";
    }

    NSDateFormatter *formatter = [self dateFormatterWithFormatterString:formatterString];
    NSDate *date = [formatter dateFromString:dateString];
    NSString *timestampStr = [NSString stringWithFormat:@"%ld", (long)[date timeIntervalSince1970]];

    return timestampStr;
}

/**
 *  将一定格式的时间字符串转换为时间戳，需指定日期的格式
 *
 *  @param dateString 格式化日期
 *  @param formatterType 日期格式类型枚举
 *  @param separator 格式化日期中年月日中间的分隔符
 *  @return 时间戳字符串
 */
+ (NSString * _Nullable)timestampStringFromDateString:(NSString * _Nullable)dateString formatterType:(DateFormatterType)formatterType separator:(NSString * _Nullable)separator {
    if ([self isBlankString:dateString]) {
        return nil;
    }

    NSDateFormatter *formatter = [self getDateFormatterWithType:formatterType separator:separator];
    NSDate *date = [formatter dateFromString:dateString];
    NSString *timestampStr = [NSString stringWithFormat:@"%ld", (long)[date timeIntervalSince1970]];

    return timestampStr;
}



/**
 *  获取 NSDate 对应的时间字符串（中国大陆地区）
 *
 *  @param date NSDate类型的日期
 *  @param dateFormat 日期格式字符串
 *  @return 格式化日期字符串
 */
+ (NSString * _Nullable)getDateStringWithDate:(NSDate * _Nullable)date
                                   dateFormat:(NSString * _Nullable)dateFormat {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = dateFormat;
    NSLocale *local = [[NSLocale alloc] initWithLocaleIdentifier:@"zh"];
    formatter.locale = local;
    NSString *dateStr = [formatter stringFromDate:date];
    return dateStr;
}

/// 获取当前时间戳
+ (instancetype _Nullable)getCurrentTimeStamp {
    NSTimeInterval nowtime = [[NSDate date] timeIntervalSince1970] * 1000;
    long long theTime = [[NSNumber numberWithDouble:nowtime] longLongValue];
    NSString *curTime = [NSString stringWithFormat:@"%llu",theTime];
    return curTime;
}



#pragma mark - Private Func

+ (NSDateFormatter * _Nullable)dateFormatterWithFormatterString:(NSString * _Nullable)formatterString {
    if ([self isBlankString:formatterString]) {
        formatterString = @"yyyy%@MM%@dd HH:mm";
    }

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = formatterString;
    NSLocale *local = [[NSLocale alloc] initWithLocaleIdentifier:@"zh"];
    formatter.locale = local;

    return formatter;
}

+ (NSDateFormatter * _Nullable)dateFormatterWithSeparator:(NSString * _Nullable)separator {
    if ([self isBlankString:separator]) {
        separator = @"";
    }

    NSString *dateFormatterStr = [NSString stringWithFormat:@"yyyy%@MM%@dd HH:mm", separator, separator];;

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = dateFormatterStr;
    NSLocale *local = [[NSLocale alloc] initWithLocaleIdentifier:@"zh"];
    formatter.locale = local;

    return formatter;
}

/// 判断字符串是否为空
+ (BOOL)isBlankString:(NSString *)string {
    if (![string isKindOfClass:[NSString class]]) {
        return YES;
    }

    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}

+ (NSDateFormatter * _Nullable)getDateFormatterWithType:(DateFormatterType)dateFormaterType {
    NSDateFormatter *formatter = [self getDateFormatterWithType:dateFormaterType separator:@"-"];
    return formatter;
}

+ (NSDateFormatter * _Nullable)getDateFormatterWithType:(DateFormatterType)dateFormaterType separator:(NSString * _Nullable)separator
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    switch (dateFormaterType) {
        case DateFormatterTypeYM:
            if ([NSString isBlankString:separator]) {
                formatter.dateFormat = [NSString stringWithFormat:@"yyyyMM"];
            }
            else {
                formatter.dateFormat = [NSString stringWithFormat:@"yyyy%@MM", separator];
            }
            break;
        case DateFormatterTypeYMd:
            if ([NSString isBlankString:separator]) {
                formatter.dateFormat = [NSString stringWithFormat:@"yyyyMMdd"];
            }
            else {
                formatter.dateFormat = [NSString stringWithFormat:@"yyyy%@MM%@dd", separator, separator];
            }
            break;
        case DateFormatterTypeYMdKKmm:
            if ([NSString isBlankString:separator]) {
                formatter.dateFormat = [NSString stringWithFormat:@"yyyyMMdd  HH:mm"];
            }
            else {
                formatter.dateFormat = [NSString stringWithFormat:@"yyyy%@MM%@dd  HH:mm", separator, separator];
            }

            break;

        case DateFormatterTypeYMdKKmmss:
            if ([NSString isBlankString:separator]) {
                formatter.dateFormat = [NSString stringWithFormat:@"yyyyMMdd  HH:mm:ss"];
            }
            else {
                formatter.dateFormat = [NSString stringWithFormat:@"yyyy%@MM%@dd  HH:mm:ss", separator, separator];
            }

            break;

        default:
            break;
    }

    NSLocale *local = [[NSLocale alloc] initWithLocaleIdentifier:@"zh"];
    formatter.locale = local;

    return formatter;
}



#pragma mark - 比较

/**
 *  获取当前时间后几天的格式化日期
 *
 *  @param days 往后推延的天数
 *  @return 格式化日期
 */
+ (NSString * _Nullable)getDateStringAfterDays:(NSInteger)days {
    NSDate *currentDate = [NSDate date];
    NSDate *date = [currentDate dateByAddingTimeInterval:60 * 60 * 24 * days];
    NSString *dateStr = [NSString getDateStringWithDate:date dateFormat:@"yyyy-MM-dd"];
    return dateStr;
}

/// 将时间戳转换为刚刚、x分钟前、今天、昨天等字段
- (NSString * _Nullable)distanceTimeCompareWithNowAndShowDetail:(BOOL)showDetail {
    NSString *beforeTimeStr = [self copy];
    
    // 判断是否是数字
    NSNumber *beforeTimeNum = [beforeTimeStr convertToNumber];
    if (beforeTimeNum == nil) {
        return nil;
    }
    
    // 判断整数位数，如果大于9则进行截取
    NSInteger integerLength = [beforeTimeStr integerLength];
    if (integerLength > 10) {
        beforeTimeStr = [beforeTimeStr substringToIndex:10];
    }
    else if (integerLength < 10) {
        return nil;
    }
    
    NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
    double distanceTime = now - [beforeTimeStr doubleValue];
    // 要显示的时间：刚刚、xx分钟前、
    NSString *distanceStr;
    
    
    NSDate *beforeDate = [NSDate dateWithTimeIntervalSince1970:[beforeTimeStr doubleValue]];
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"HH:mm"];
    NSString *beforeTimeStr2 = [dateFormatter stringFromDate:beforeDate];
    
    [dateFormatter setDateFormat:@"dd"];
    NSString *nowDayStr = [dateFormatter stringFromDate:[NSDate date]];
    NSString *lastDayStr = [dateFormatter stringFromDate:beforeDate];
    
    if (distanceTime < 60) {  // 小于一分钟
        distanceStr = @"刚刚";
    }
    else if (distanceTime < 60*60) {  // 时间小于一个小时
        distanceStr = [NSString stringWithFormat:@"%ld分钟前",(long)distanceTime/60];
    }
    else if(distanceTime < 24*60*60 && ([nowDayStr integerValue] == [lastDayStr integerValue])){  // 时间小于一天，xx时xx分
        distanceStr = [NSString stringWithFormat:@"%@", beforeTimeStr2];
    }
    else if(distanceTime < 24*60*60*2 && [nowDayStr integerValue] != [lastDayStr integerValue]){
        distanceStr = (showDetail == YES ? [NSString stringWithFormat:@"昨天 %@", beforeTimeStr2] : @"昨天");
    }
    else {
        [dateFormatter setDateFormat:(showDetail == YES ? @"yyyy/MM/dd HH:mm" : @"yyyy/MM/dd")];
        distanceStr = [dateFormatter stringFromDate:beforeDate];
    }
    
    return distanceStr;
}



#pragma mark - Private

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

@end
