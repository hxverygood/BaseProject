//
//  NSString+HXDate.h
//  Baili
//
//  Created by xabaili on 16/1/9.
//  Copyright © 2016年 Baili. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, DateFormatterType) {
    DateFormatterTypeYM = 0,       // 年月
    DateFormatterTypeYMd = 1,       // 年月日
    DateFormatterTypeYMdKKmm = 2,     // 年月日 (24)小时 分钟
    DateFormatterTypeYMdKKmmss = 3     // 年月日 (24)小时 分钟 秒
};



@interface NSString (Date)

/**
 *  将给定的时间戳转换为字符串
 *
 *  @param timestamp        时间戳
 *  @param dateFormaterType 包含种格式
 *  @param separator    年月日之间的分隔符
 *  @return 返回一个字符串
 */
+ (NSString * _Nullable)dateStringFromTimestamp:(NSTimeInterval)timestamp
                                  dateFormatter:(DateFormatterType)dateFormaterType
                                      separator:(NSString * _Nullable)separator;

/**
 *  将给定的时间戳字符串转换为指定格式的字符串
 *
 *  @param timestampString 时间戳字符串
 *  @param dateFormaterType 日期格式类型enum
 *  @param separator 格式化日期中年月日中间的分隔符
 *  @return 格式化日期字符串
 */
+ (NSString * _Nullable)dateStringFromTimestampString:(NSString * _Nullable)timestampString dateFormatter:(DateFormatterType)dateFormaterType separator:(NSString * _Nullable)separator;

/**
 *  获取当前时间戳对应的日期字符串
 *
 *  @param formaterType 格式化日期类型enum
 *  @param separator    年月日之间的分隔符
 *  @return 返回一个字符串
 */
+ (NSString * _Nullable)dateStringFromTimestampWithFormatter:(DateFormatterType)formaterType
                                                   separator:(NSString * _Nullable)separator;


/**
 *  将格式化时间字符串转换为时间戳
 *
 *  @param dateString 格式化日期
 *  @param formatterType 日期格式类型枚举
 *  @return 时间戳字符串
 */
+ (NSString * _Nullable)timestampStringFromDateString:(NSString * _Nullable)dateString formatterType:(DateFormatterType)formatterType;

/**
 *  将一定格式的时间字符串转换为时间戳，需指定日期的格式
 *
 *  @param dateString 格式化日期
 *  @param formatterString 日期格式(字符串形式)
 *  @return 时间戳字符串
 */
+ (NSString * _Nullable)timestampStringFromDateString:(NSString * _Nullable)dateString formatterString:(NSString * _Nullable)formatterString;

/**
 *  将一定格式的时间字符串转换为时间戳，需指定日期的格式
 *
 *  @param dateString 格式化日期
 *  @param formatterType 日期格式类型枚举
 *  @param separator 格式化日期中年月日中间的分隔符
 *  @return 时间戳字符串
 */
+ (NSString * _Nullable)timestampStringFromDateString:(NSString * _Nullable)dateString formatterType:(DateFormatterType)formatterType separator:(NSString * _Nullable)separator;


/**
 *  获取 NSDate 对应的时间字符串（中国大陆地区）
 *
 *  @param date NSDate类型的日期
 *  @param dateFormat 日期格式字符串
 *  @return 格式化日期字符串
 */
+ (NSString * _Nullable)getDateStringWithDate:(NSDate * _Nullable)date
                                   dateFormat:(NSString * _Nullable)dateFormat;

/// 获取当前时间戳
+ (instancetype _Nullable)getCurrentTimeStamp;



#pragma mark - 比较

/**
 *  获取当前时间后几天的格式化日期
 *
 *  @param days 往后推延的天数
 *  @return 格式化日期
 */
+ (NSString * _Nullable)getDateStringAfterDays:(NSInteger)days;

/// 将时间戳转换为刚刚、x分钟前、今天、昨天等字段
- (NSString * _Nullable)distanceTimeCompareWithNowAndShowDetail:(BOOL)showDetail;

@end
