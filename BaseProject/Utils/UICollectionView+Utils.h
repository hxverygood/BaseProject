//
//  UICollectionView+Utils.h
//  LDDriverSide
//
//  Created by shandiangou on 2018/9/18.
//  Copyright © 2018年 lightingdog. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UICollectionView (Utils)

/// 用nibname注册collectionViewCell
- (void)registerNibWithNibNames:(NSArray<NSString *> *)nibNames;

@end
