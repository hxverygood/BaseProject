//
//  HSCountDownButton.m
//  HSRongyiBao
//
//  Created by 韩啸 on 2018/4/23.
//  Copyright © 2018年 hoomsun. All rights reserved.
//

#import "CountDownButton.h"

@interface CountDownButton ()

@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) UIColor *bgColor;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger originCount;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, assign) CountDownStatus countDownStatusInside;

@end



@implementation CountDownButton

#pragma mark - Getter

- (NSTimer *)timer {
    if (!_timer) {
        _count = _originCount == 0 ? COUNT_DOWN_TIME : _originCount;
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
    }
    return _timer;
}

- (CountDownStatus)countDownStatus {
    return _countDownStatusInside;
}

- (NSInteger)remainCount {
    return _count;
}



#pragma mark -

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.countDownStatusInside = CountDownTimerIsIdle;
        self.titleLabel.font = [UIFont systemFontOfSize:15.0];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.countDownStatusInside = CountDownTimerIsIdle;
    self.titleLabel.font = [UIFont systemFontOfSize:15.0];
}



#pragma mark - Public Func

- (void)setCountDown:(NSInteger)count {
    _title = self.titleLabel.text;
    _bgColor = self.defaultBackgrouodColor;
    _originCount = count > 0 ? count : 60;
}

- (void)setTitle:(NSString *)title
           count:(NSInteger)count {
    _title = title;
    [self setTitle:title forState:UIControlStateNormal];
    _originCount = count > 0 ? count : 60;
}

- (void)setTitle:(NSString *)title
 backgroundColor:(UIColor *)backgroundColor
           count:(NSInteger)count {
    _title = title;
    [self setTitle:title forState:UIControlStateNormal];
    _bgColor = backgroundColor;
    self.backgroundColor = backgroundColor;
    _originCount = count > 0 ? count : 60;
}

- (void)timerStart {
//    if (self.statusBlock) {
//        self.statusBlock(CountDownTimerIsCounting);
//    }
//    _countDownStatusInside = CountDownTimerIsCounting;
//    NSLog(@"change countdown status: counting");
    
    [self.timer fire];
}


//- (void)hideCountDownStatus {
//    [self setupCodeButtonIsEnabled:YES];
//}



#pragma mark - Private Func

- (void)countDown {
    if (self.count == 0) {
        [self timerStop];
        [self setupCodeButtonIsEnabled:YES];
        
        return;
    }

    if (_countDownStatusInside == CountDownTimerIsCounting) {
        [self setCountDownTitleWithText:self.count];
    }
    else {
        [self setupCodeButtonIsEnabled:NO];
    }
    
    _count -= 1;
}

- (void)timerStop {
    NSLog(@"停止 倒计时按钮 的倒计时");

    [self.timer invalidate];
    _timer = nil;
    
    _countDownStatusInside = CountDownTimerIsIdle;
    NSLog(@"change countdown status: idle");
    
    if (self.statusBlock) {
        self.statusBlock(CountDownTimerIsIdle);
    }
}

- (void)setupCodeButtonIsEnabled:(BOOL)enable {
    self.enabled = enable;
    if (enable) {
        [self setTitle:@"获取验证码" forState:UIControlStateNormal];
        [self setTitleColor:[UIColor colorWithRed:107/255.0 green:65/255.0 blue:19/255.0 alpha:1.0] forState:UIControlStateNormal];
        self.backgroundColor = _bgColor ? : self.defaultBackgrouodColor;
    }
    else {
        _countDownStatusInside = CountDownTimerIsCounting;
        [self setTitleColor:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0] forState:UIControlStateNormal];
        self.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0];
        NSLog(@"change countdown status: counting");
    }
}

- (void)setCountDownTitleWithText:(NSInteger)count {
    NSString *countingText = [NSString stringWithFormat:@"%lds", (long)count];
    self.titleLabel.text = countingText;
    [self setTitle:countingText forState:UIControlStateNormal];
}

@end
