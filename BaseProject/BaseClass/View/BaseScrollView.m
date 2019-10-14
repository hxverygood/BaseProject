//
//  BaseScrollView.m
//  LDDriverSide
//
//  Created by shandiangou on 2018/9/19.
//  Copyright © 2018年 lightingdog. All rights reserved.
//

#import "BaseScrollView.h"

@implementation BaseScrollView

- (void)awakeFromNib {
    [super awakeFromNib];

    self.backgroundColor = BACKGROUND_COLOR;

    if (@available(iOS 11.0, *)) {
        self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
}

@end
