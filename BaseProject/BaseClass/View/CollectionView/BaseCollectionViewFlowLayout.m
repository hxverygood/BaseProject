//
//  BaseCollectionViewFlowLayout.m
//  LDDriverSide
//
//  Created by shandiangou on 2018/9/8.
//  Copyright © 2018年 lightingdog. All rights reserved.
//

#import "BaseCollectionViewFlowLayout.h"

@implementation BaseCollectionViewFlowLayout

- (instancetype)initWithTotalWidth:(CGFloat)totalWidth
                   bothSideSpacing:(CGFloat)bothSideSpacing
                 itemNumbersPerRow:(NSInteger)itemNumbersPerRow
                       itemSpacing:(CGFloat)itemSpacing
                            height:(CGFloat)height {
    self = [super init];
    if (self) {
        CGFloat width = (totalWidth - bothSideSpacing * 2 - (itemNumbersPerRow-1) * itemSpacing) / itemNumbersPerRow;

        self.itemSize = CGSizeMake(width, height);
        self.minimumInteritemSpacing = itemSpacing;
        self.minimumLineSpacing = 0.0;
        self.scrollDirection = UICollectionViewScrollDirectionVertical;
        self.sectionInset = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
    }
    return self;
}

@end
