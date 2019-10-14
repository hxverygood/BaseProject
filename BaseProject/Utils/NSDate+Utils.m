//
//  NSDate+Utils.m
//  HSRongyiBao
//
//  Created by 韩啸 on 2018/4/9.
//  Copyright © 2018年 hoomsun. All rights reserved.
//

#import "NSDate+Utils.h"

@implementation NSDate (Utils)

+ (NSDate * __nullable)currentDate {
    NSDate *currentDate = [NSDate date];
//    NSTimeInterval sec = [date timeIntervalSinceNow];
//    NSDate *currentDate = [[NSDate alloc] initWithTimeIntervalSinceNow:sec];

//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    formatter.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];//东八区时间
//    NSString *dateStr = [formatter stringFromDate:date];
//    NSDate *currentDate = [formatter dateFromString:[NSString stringWithFormat:@"%@ +0800", dateStr]];

//    NSInteger interval = [zone secondsFromGMTForDate:date];
//    NSDate *currentDate = [[NSDate alloc] initWithTimeIntervalSinceNow:interval];

    return currentDate;
}

@end
