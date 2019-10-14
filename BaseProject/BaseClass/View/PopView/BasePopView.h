//
//  BasePopView.h
//  LDDriverSide
//
//  Created by shandiangou on 2018/9/6.
//  Copyright © 2018年 lightingdog. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, PopViewStyle) {
    PopViewStyleCenter,
    PopViewStyleFromBottom,
    PopViewStyleCustom,
    PopViewStyleNone
};

typedef NS_ENUM(NSInteger, PopViewStatus) {
    PopViewStatusDidDisappear,
    PopViewStatusWillAppear,
    PopViewStatusDidAppear,
    PopViewStatusWillDisappear
};



@interface BasePopView : UIView

@property (nonatomic, assign) PopViewStyle popViewStyle;
@property (nonatomic, assign) PopViewStatus popViewStatus;

/**
 popViewStyle为PopViewStyleCustom时需设置隐藏和显示的frame
 */
@property (nonatomic, assign) CGRect frameForShow;
@property (nonatomic, assign) CGRect frameForHidden;

@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIColor *startColor;
@property (nonatomic, strong) UIColor *endColor;

@property (nonatomic, assign) BOOL canDismissWhenTapBackground;

- (void)show;
- (void)dismissWithCompletion:(void (^)(void))completion;

@end
