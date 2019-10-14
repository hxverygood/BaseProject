//
//  BaseCollectionViewFlowLayout.h
//  LDDriverSide
//
//  Created by shandiangou on 2018/9/8.
//  Copyright © 2018年 lightingdog. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseCollectionViewFlowLayout : UICollectionViewFlowLayout


/**
 初始化CollectionViewFlowLayout

 @param totalWidth 总宽度
 @param bothSideSpacing 两边留白宽度
 @param itemNumbersPerRow 每行Item的个数
 @param itemSpacing item之间的间距
 @return BaseCollectionViewFlowLayout实例
 */
- (instancetype)initWithTotalWidth:(CGFloat)totalWidth
                   bothSideSpacing:(CGFloat)bothSideSpacing
                 itemNumbersPerRow:(NSInteger)itemNumbersPerRow
                       itemSpacing:(CGFloat)itemSpacing
                            height:(CGFloat)height;

@end
