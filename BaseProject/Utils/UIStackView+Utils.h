//
//  UIStackView+Utils.h
//  LDDriverSide
//
//  Created by shandiangou on 2018/7/5.
//  Copyright © 2018年 lightingdog. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIStackView (Utils)

/// 移除其中排列的1组View
- (void)removeArrangedSubviews:(NSArray<UIView *> *)views;

@end
