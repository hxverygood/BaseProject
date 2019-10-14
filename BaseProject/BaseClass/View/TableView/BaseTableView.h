//
//  HSBaseTableView.h
//  HSAdvisorAPP
//
//  Created by hoomsun on 2017/1/19.
//  Copyright © 2017年 hoomsun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MJRefresh/MJRefresh.h>

typedef void (^Handler)(BOOL needRefresh);

@interface BaseTableView : UITableView

@property (nonatomic, copy) NSString *placeholderContent;
@property (nonatomic, copy) NSString *placeholderImageName;

/* 无数据背景区域的大小（默认等于整个tableView
   但遇到talbeView上有banner需要滑动的时候，左右滑动的手势可能跟其它控件冲突）
 */
@property (nonatomic, assign) CGRect noDataViewFrame;

- (CGSize)preferredContentSize;

@end
