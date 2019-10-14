//
//  UIScrollView+Refresh.h
//  AirHospital
//
//  Created by C_HAO on 16/1/14.
//  Copyright © 2016年 C_HAO. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (Refresh)

/// 添加gif图下拉刷新
- (void)addGifHeaderRefresh:(void (^)(void))complete;

/**
 *  添加下来刷新
 *
 */
- (void)addHeaderRefresh:(void (^)(void))complete;

/**
 *  添加上拉加载
 *
 */
- (void)addFooterRefresh:(void (^)(void))complete;

/**
 *  添加下来刷新
 *
 */
- (void)addHeaderWithRefreshingTarget:(id)target refreshingAction:(SEL)action;

/**
 *  添加上拉加载
 *
 */
- (void)addFooterWithRefreshingTarget:(id)target refreshingAction:(SEL)action;

/**
 *  自动刷新
 */
- (void)beginHeaderRefreshing;

/**
 *  自动加载
 */
- (void)beginFooterRefreshing;

/**
 *  结束刷新
 */
- (void)endHeaderRefreshing;

/**
 *  结束加载
 */
- (void)endFooterRefreshing;

/**
 *  结束加载 （网络请求返回条数为0会自动隐藏上拉加载）
 *  @param count 内容条数
 */
- (void)endFooterRefreshingWithDataCount:(NSInteger)count;

/**
 *  隐藏下拉刷新
 *
 */
- (void)hiddenHeader:(BOOL)hidden;

/**
 *  隐藏上拉加载
 *
 */
- (void)hiddenFooter:(BOOL)hidden;

/**
 *  判断是否正在下拉刷新
 *
 */
- (BOOL)isHeaderRefreshing;

/**
 *  判断是否正在上拉加载
 *
 */
- (BOOL)isFooterRefreshing;


@end
