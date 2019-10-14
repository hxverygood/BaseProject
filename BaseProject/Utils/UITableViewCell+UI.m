//
//  UITableViewCell+UI.m
//  HSRongyiBao
//
//  Created by hoomsun on 2017/10/31.
//  Copyright © 2017年 hoomsun. All rights reserved.
//

#import "UITableViewCell+UI.h"

@implementation UITableViewCell (UI)

/// 分隔线左侧是否留有空间
- (void)leftSpaceForSeparator:(BOOL)needShow {
    if (needShow) {
        [self changeSeparatorLeftInset:15.0];
    } else {
        self.separatorInset = UIEdgeInsetsZero;
        self.layoutMargins = UIEdgeInsetsZero;
        self.preservesSuperviewLayoutMargins = NO;
    }
}

/// 分隔线距左侧距离
- (void)separatorLeftSpace:(CGFloat)leftSpace {
    if (leftSpace < 0.0) {
        return;
    }
    [self changeSeparatorLeftInset:leftSpace];
}

/// 分割线距离左右两边距离相等时
- (void)separatorLeftAndRightSpace:(CGFloat)space {
    [self changeSeparatorLeftAndRightInset:space];
}

/// 是否显示分隔线
- (void)showSeparator:(BOOL)needShow {
    if (needShow) {
        [self changeSeparatorLeftInset:15.0];
    }
    else {
        [self changeSeparatorLeftInset:[UIScreen mainScreen].bounds.size.width];
    }
}



#pragma mark - Private Func

- (void)changeSeparatorLeftInset:(CGFloat)leftInset {
    if (leftInset < 0.0) {
        return;
    }
    
    UIEdgeInsets insets = UIEdgeInsetsMake(0.0, leftInset, 0.0, 0.0);
    self.separatorInset = insets;
    self.layoutMargins = insets;
    self.preservesSuperviewLayoutMargins = leftInset <= 0.1 ? NO : YES;
}

- (void)changeSeparatorLeftAndRightInset:(CGFloat)twoSideInset {
    if (twoSideInset < 0.0) {
        return;
    }
    UIEdgeInsets insets = UIEdgeInsetsMake(0.0, twoSideInset, 0.0, twoSideInset);
    self.preservesSuperviewLayoutMargins = (twoSideInset <= 0.1 ? NO : YES);
    self.separatorInset = insets;
    self.layoutMargins = insets;
}

@end
