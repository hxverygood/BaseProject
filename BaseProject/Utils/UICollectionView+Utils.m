//
//  UICollectionView+Utils.m
//  LDDriverSide
//
//  Created by shandiangou on 2018/9/18.
//  Copyright © 2018年 lightingdog. All rights reserved.
//

#import "UICollectionView+Utils.h"

@implementation UICollectionView (Utils)

/// 用nibname注册collectionViewCell
- (void)registerNibWithNibNames:(NSArray<NSString *> *)nibNames {
    for (NSString *nibName in nibNames) {
        UINib *nib = [UINib nibWithNibName:nibName bundle:nil];
        [self registerNib:nib forCellWithReuseIdentifier:nibName];
    }
}

@end
