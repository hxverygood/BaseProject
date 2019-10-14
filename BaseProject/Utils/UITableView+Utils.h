//
//  UITableView+Utils.h
//  LDDriverSide
//
//  Created by shandiangou on 2018/7/4.
//  Copyright © 2018年 lightingdog. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (Utils)

/// 用nibname注册tableViewCell
- (void)registerNibWithNibNames:(NSArray<NSString *> *)nibNames;

/// 用class注册tableViewCell
- (void)registerClassWithClassNames:(NSArray<NSString *> *)classNames;

@end
