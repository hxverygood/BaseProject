//
//  UIScrollView+Refresh.m
//  AirHospital
//
//  Created by C_HAO on 16/1/14.
//  Copyright © 2016年 C_HAO. All rights reserved.
//

#import "UIScrollView+Refresh.h"
#import "MJRefresh.h"

@implementation UIScrollView (Refresh)

- (void)addGifHeaderRefresh:(void (^)(void))complete {
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        // 进入刷新状态就会回调这个Block
        if (complete) {
            complete();
        }
    }];
    
//    [header setImages:[HSHelper sharedHelper].imagesForIdleState forState:MJRefreshStateIdle];
//    [header setImages:[HSHelper sharedHelper].imagesForPullingState forState:MJRefreshStatePulling];
//    [header setImages:[HSHelper sharedHelper].imagesForRefreshingState forState:MJRefreshStateRefreshing];
//
////    header.ignoredScrollViewContentInsetTop = adViewHeight+kSegmentButtonHeight-10.0f;
//    header.lastUpdatedTimeLabel.hidden = YES;
//    header.stateLabel.hidden = YES;
    header.stateLabel.textColor = GRAY180;
    header.lastUpdatedTimeLabel.textColor = GRAY180;
    self.mj_header = header;
}

- (void)addHeaderRefresh:(void (^)(void))complete
{
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 进入刷新状态就会回调这个Block
        if (complete) {
            complete();
        }
    }];
    header.stateLabel.textColor = GRAY180;
    header.lastUpdatedTimeLabel.textColor = GRAY180;
    self.mj_header = header;
}

- (void)addFooterRefresh:(void (^)(void))complete
{
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        // 进入刷新状态就会回调这个Block
        if (complete) {
            complete();
        }
    }];

    [footer setTitle:@"加载更多信息……" forState:MJRefreshStateRefreshing];
    [footer setTitle:@"已显示全部信息" forState:MJRefreshStateNoMoreData];
    // 设置刷新字体字号和颜色
    footer.stateLabel.font = [UIFont systemFontOfSize:14.0];
    footer.stateLabel.textColor = GRAY180;

    self.mj_footer = footer;
}

- (void)addHeaderWithRefreshingTarget:(id)target refreshingAction:(SEL)action
{
    self.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:target refreshingAction:action];
}

- (void)addFooterWithRefreshingTarget:(id)target refreshingAction:(SEL)action
{
    self.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:target refreshingAction:action];
}

- (void)beginHeaderRefreshing
{
    [self.mj_header beginRefreshing];
}

- (void)beginFooterRefreshing
{
    [self.mj_footer beginRefreshing];
}

- (void)endHeaderRefreshing
{
    [self.mj_header endRefreshing];
}

- (void)endFooterRefreshing
{
    [self.mj_footer endRefreshing];
}

- (void)endFooterRefreshingWithDataCount:(NSInteger)count
{
    if (count == 0) {
        [self.mj_footer endRefreshingWithNoMoreData];
    }
    else {
        self.mj_footer.hidden = NO;
        [self.mj_footer resetNoMoreData];
    }
}

- (void)hiddenHeader:(BOOL)hidden
{
    [self.mj_header setHidden:hidden];
}

- (void)hiddenFooter:(BOOL)hidden
{
    [self.mj_footer setHidden:hidden];
}

- (BOOL)isHeaderRefreshing
{
    return [self.mj_header isRefreshing];
}

- (BOOL)isFooterRefreshing
{
    return [self.mj_footer isRefreshing];
}



@end
