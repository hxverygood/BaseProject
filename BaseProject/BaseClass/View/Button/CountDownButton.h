//
//  CountDownButton.h
//
//  Created by hans on 2018/4/23.
//  Copyright © 2018年. All rights reserved.
//

#import "BaseButton.h"

typedef NS_ENUM(NSInteger, CountDownStatus) {
    CountDownTimerIsIdle,
    CountDownTimerIsCounting
};



@interface CountDownButton : BaseButton

@property (nonatomic, assign, readonly) CountDownStatus countDownStatus;
@property (nonatomic, assign, readonly) NSInteger remainCount;
@property (nonatomic, copy) void (^statusBlock)(CountDownStatus status);

- (void)setCountDown:(NSInteger)count;

- (void)setTitle:(NSString *)title
           count:(NSInteger)count;

- (void)setTitle:(NSString *)title
 backgroundColor:(UIColor *)backgroundColor
           count:(NSInteger)count;

- (void)timerStart;
- (void)timerStop;

@end
