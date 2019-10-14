//
//  BasePopView.m
//  LDDriverSide
//
//  Created by shandiangou on 2018/9/6.
//  Copyright © 2018年 lightingdog. All rights reserved.
//

#import "BasePopView.h"

static CGFloat animationDuration = 0.5;
static CGFloat animationDelay = 0.0;
static CGFloat animationDamping = 1.0;
static CGFloat animationVelocity = 0.5;



@interface BasePopView ()

@end



@implementation BasePopView

#pragma mark - Getter / Setter

- (UIView *)backgroundView {
    if (!_backgroundView) {
        CGRect bgViewFrame = [UIScreen mainScreen].bounds;
        _backgroundView = [[UIView alloc] initWithFrame:bgViewFrame];
        _backgroundView.backgroundColor = self.startColor;
    }
    return _backgroundView;
}

- (UIColor *)startColor {
    if (!_startColor) {
        _startColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.0];
    }
    return _startColor;
}

- (UIColor *)endColor {
    if (!_endColor) {
        _endColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.5];
    }
    return _endColor;
}

- (void)setCanDismissWhenTapBackground:(BOOL)canDismissWhenTapBackground {
    _canDismissWhenTapBackground = canDismissWhenTapBackground;

    if (canDismissWhenTapBackground) {
        // 添加tap手势
        UITapGestureRecognizer *gr = [[UITapGestureRecognizer alloc] init];
        [gr addTarget:self action:@selector(tapBackgroundViewAction)];
        [self.backgroundView addGestureRecognizer:gr];
    }
}



#pragma mark - Func

- (void)show {
    // 收起键盘
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];

    if (_popViewStatus == PopViewStatusWillAppear ||
        _popViewStatus == PopViewStatusDidAppear) {
        NSLog(@"popView has been shown");
        return;
    }

    NSLog(@"show popView");

    switch (self.popViewStyle) {
        case PopViewStyleCenter:
        {
            CGRect screenBounds = [UIScreen mainScreen].bounds;
            self.center = CGRectGetCenter(screenBounds);
            self.transform = CGAffineTransformMakeScale(0.0, 0.0);
        }
            break;

        case PopViewStyleFromBottom:
        {
            CGRect frameForShow = self.frame;
            frameForShow.origin.y = (kScreenHeight -CGRectGetHeight(self.frame))/2;
            self.frameForShow = frameForShow;

            CGRect frameForHidden = self.frame;
            frameForHidden.origin.y = kScreenHeight;
            self.frameForHidden = frameForHidden;

#if DEBUG
            NSAssert(!CGRectEqualToRect(self.frameForShow, CGRectZero), @"frameForShow为空，无法弹出view");
#endif
            self.frame = self.frameForHidden;
        }
            break;

        case PopViewStyleCustom:
        {
            self.frame = self.frameForHidden;
        }
            break;

        default:
            break;
    }

    UIWindow *window = [[UIApplication sharedApplication].windows firstObject];
    [window addSubview:self.backgroundView];
    [window addSubview:self];

    _popViewStatus = PopViewStatusWillAppear;
    [UIView animateWithDuration:animationDuration delay:animationDelay usingSpringWithDamping:animationDamping initialSpringVelocity:animationVelocity options:UIViewAnimationOptionCurveLinear animations:^{
        switch (self.popViewStyle) {
            case PopViewStyleCenter:
                self.transform = CGAffineTransformMakeScale(1.0, 1.0);
                break;

            case PopViewStyleFromBottom:
            case PopViewStyleCustom:
                self.frame = self.frameForShow;
                break;

            default:
                break;
        }

        self.backgroundView.backgroundColor = self.endColor;
    } completion:^(BOOL finished) {
        self->_popViewStatus = PopViewStatusDidAppear;
    }];
}

- (void)dismissWithCompletion:(void (^)(void))completion {
    NSLog(@"dismiss popView");

    _popViewStatus = PopViewStatusWillDisappear;
    [UIView animateWithDuration:animationDuration delay:animationDelay usingSpringWithDamping:animationDamping initialSpringVelocity:animationVelocity options:UIViewAnimationOptionCurveLinear animations:^{
        switch (self.popViewStyle) {
            case PopViewStyleCenter:
                self.transform = CGAffineTransformMakeScale(0.0, 0.0);
                break;

            case PopViewStyleFromBottom:
            case PopViewStyleCustom:
                self.frame = self.frameForHidden;

            default:
                break;
        }

        self.backgroundView.backgroundColor = self.startColor;
    } completion:^(BOOL finished) {
        self->_popViewStatus = PopViewStatusDidDisappear;
        [self removeFromSuperview];
        [self.backgroundView removeFromSuperview];
        if (finished && completion) {
            completion();
        }
    }];
}



#pragma mark - Action

- (void)tapBackgroundViewAction {
    [self dismissWithCompletion:nil];
}

@end
