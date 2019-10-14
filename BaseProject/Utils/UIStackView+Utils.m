//
//  UIStackView+Utils.m
//  LDDriverSide
//
//  Created by shandiangou on 2018/7/5.
//  Copyright © 2018年 lightingdog. All rights reserved.
//

#import "UIStackView+Utils.h"

@implementation UIStackView (Utils)

/// 移除其中排列的1组View
- (void)removeArrangedSubviews:(NSArray<UIView *> *)views {
    for (UIView *view in views) {
        [self removeArrangedSubview:view];
    }
}

@end
