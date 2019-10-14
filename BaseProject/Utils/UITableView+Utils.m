//
//  UITableView+Utils.m
//  LDDriverSide
//
//  Created by shandiangou on 2018/7/4.
//  Copyright © 2018年 lightingdog. All rights reserved.
//

#import "UITableView+Utils.h"

@implementation UITableView (Utils)

/// 用nibname注册tableViewCell
- (void)registerNibWithNibNames:(NSArray<NSString *> *)nibNames {
    for (NSString *nibName in nibNames) {
        UINib *nib = [UINib nibWithNibName:nibName bundle:nil];
        [self registerNib:nib forCellReuseIdentifier:nibName];
    }
}

/// 用class注册tableViewCell
- (void)registerClassWithClassNames:(NSArray<NSString *> *)classNames {
    for (NSString *className in classNames) {
        [self registerClass:NSClassFromString(className) forCellReuseIdentifier:className];
    }
}

///// 用nibname注册tableViewCell
//- (void)registerClassWithNames:(NSArray<NSString *> *)names {
//    for (NSString *className in names) {
//        UINib *nib = [UINib nibWithNibName:nibName bundle:nil];
//        [self registerNib:nib forCellReuseIdentifier:nibName];
//    }
//}

@end
