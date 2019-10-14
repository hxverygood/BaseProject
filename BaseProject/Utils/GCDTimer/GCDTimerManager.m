//
//  GCDTimerManager.m
//  Copyright © 2017年. All rights reserved.
//

#import "GCDTimerManager.h"

@interface GCDTimerManager () {
    NSInteger timeoutReserved;
    NSInteger timeout;
    NSInteger count;
}

@property (nonatomic, assign) NSInteger delayTime;
@property (nonatomic, assign) NSInteger timerCount;

// timer
@property (nonatomic, strong) dispatch_source_t timer;
@property (nonatomic, strong) dispatch_queue_t queue;

// 回调
@property (nonatomic, copy) TimerBlock currentBlock;
// 是否循环
@property (nonatomic, assign) BOOL isRepeat;
// timer已经开始计时
@property (nonatomic, assign) BOOL isTimerStart;
// timer是第一次创建
@property (nonatomic, assign) BOOL isTimerFirstCreation;
// timer是否被挂起
@property (nonatomic, assign) BOOL isTimerSuspend;

@end

@implementation GCDTimerManager

#pragma mark - Getter

- (dispatch_queue_t)queue {
    if (!_queue) {
        _queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    }
    return _queue;
}

- (dispatch_source_t)timer {
    if (!_timer) {
        _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, self.queue);
    }
    return _timer;
}



#pragma mark - Initailizer

/// 初始化无限循环倒计时器
- (instancetype)initWithDelayTime:(NSInteger)delayTime
                     timeInterval:(NSTimeInterval)timeInterval {
    return [[GCDTimerManager alloc] initWithDelayTime:delayTime timerCount:0 timeInterval:timeInterval repeat:YES];
}

- (instancetype)initWithDelayTime:(NSInteger)delayTime
                       timerCount:(NSInteger)timerCount
                     timeInterval:(NSTimeInterval)timeInterval {
    return [[GCDTimerManager alloc] initWithDelayTime:delayTime timerCount:timerCount timeInterval:timeInterval repeat:NO];
}

- (instancetype)initWithDelayTime:(NSInteger)delayTime
                       timerCount:(NSInteger)timerCount
                     timeInterval:(NSTimeInterval)timeInterval
                           repeat:(BOOL)repeat {
    self = [super init];
    if (self) {
        _delayTime = delayTime;
        _timerCount = timerCount;
        _timeInterval = timeInterval;
        _isRepeat = repeat;

        timeoutReserved = timerCount;
        timeout = timerCount;

        _isTimerFirstCreation = YES;
        _isTimerStart = NO;
        _isTimerSuspend = NO;
    }
    return self;
}

- (void)creatTimer {
    dispatch_source_set_timer(self.timer, dispatch_walltime(NULL, _delayTime), _timeInterval * NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(self.timer, ^{
        if (self->_timerCount != 0) {
            if (self.currentBlock) {
                self.currentBlock(self->timeout);
            }

            if (self->timeout == 0 &&
                self->_isRepeat == NO) {
                // 不需要循环时倒计时结束，关闭
                [self stopTimer];
//                dispatch_source_cancel(self->_timer);
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (self.delegate && [self.delegate respondsToSelector:@selector(timerStop:)]) {
                        [self.delegate timerStop:self];
                    }
                });
                NSLog(@"倒计时停止");
                return;
            }

            self->timeout -= 1;

            if(self->timeout < 0) {
                if (self->_isRepeat) {
                    // 需要循环时计数器重置
                    self->timeout = self->timeoutReserved;
                }
            }
            //                dispatch_async(dispatch_get_main_queue(), ^{
            //                    NSLog(@"倒计时：%ld", self->timeout);
            //                    self.currentBlock(self->timeout);
            //                });
        }
        else {
            // 如果是无限循环模式
            dispatch_async(dispatch_get_main_queue(), ^{
                //                    NSLog(@"无限循环timer");
                self->count += 1;
                if (self.currentBlock) {
                    self.currentBlock(self->count);
                }
            });
        }
    });
}


// 开始计时
- (void)startTimerCompletion:(void(^)(NSInteger count))block {
    if (block) {
        self.currentBlock = block;
    }

    if (self.timer) {
        if (_isTimerFirstCreation) {
            [self creatTimer];
            _isTimerFirstCreation = NO;
        }
        else {
            if (_isTimerStart) {
//                [self stopTimerWithCompletion:nil];
                [self stopTimer];
                [self creatTimer];
            }
            else {
                if (_isTimerSuspend == NO) {
                    [self creatTimer];
                }
                else { }
            }
        }

        __weak typeof(self) weakself = self;
        dispatch_barrier_sync(self.queue, ^{
            dispatch_resume(weakself.timer);
            weakself.isTimerStart = YES;

            if (![GCDTimerManager isBlankString:weakself.identifier]) {
                NSLog(@"%@ 计时开始 >>>>>>>", weakself.identifier);
            }

            if (weakself.isTimerSuspend == YES) {
                weakself.isTimerSuspend = NO;
            }
        });
    }
}


// 挂起计时器(暂停)
- (void)suspendTimer {
    __weak typeof(self) weakself = self;
    dispatch_barrier_sync(self.queue, ^{
        dispatch_suspend(weakself.timer);
        weakself.isTimerStart = NO;
    });
}

// 继续倒计时
- (void)resumeTimer {
    __weak typeof(self) weakself = self;
    dispatch_barrier_sync(self.queue, ^{
        dispatch_resume(weakself.timer);
    });
}

// 停止计时器
- (void)stopTimer {
    if (_timer == nil) {
//        if (completionHandler) {
//            completionHandler();
//        }
        return;
    }

    __weak typeof(self) weakself = self;
    dispatch_barrier_sync(self.queue, ^{
        dispatch_cancel(weakself.timer);
        weakself.isTimerStart = NO;
        weakself.isTimerSuspend = NO;
        weakself.timer = nil;
        self->count = 0;

        if (![GCDTimerManager isBlankString:weakself.identifier]) {
            NSLog(@"%@ 计时结束 <<<<<<<", weakself.identifier);
        }
        else {
            NSLog(@"倒计时结束 <<<<<<<");
        }

//        if (completionHandler) {
//            completionHandler();
//        }
    });
}



#pragma mark - Private Func

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

//- (NSString *)getCaller {
//    NSArray<NSString *> *callStackSymbols = [NSThread callStackSymbols];
//    NSLog(@"%@", callStackSymbols);
//
//    NSString *caller = [[[callStackSymbols objectAtIndex:1] componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"[]"]] objectAtIndex:1];
//    return caller;
//}


@end
