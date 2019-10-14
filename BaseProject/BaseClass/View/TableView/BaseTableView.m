//
//  HSBaseTableView.m
//  HSAdvisorAPP
//
//  Created by hoomsun on 2017/1/19.
//  Copyright © 2017年 hoomsun. All rights reserved.
//

#import "BaseTableView.h"
#import "CYLTableViewPlaceHolder.h"
#import "NoDataCustomeView.h"


#define BACKGROUNDCOLOR    [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0]


@interface BaseTableView () <CYLTableViewPlaceHolderDelegate>

@property (nonatomic, strong) NoDataCustomeView *noDataView;

@end



@implementation BaseTableView

#pragma mark - Initializer

- (instancetype)initWithFrame:(CGRect)frame
                        style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.backgroundColor = BACKGROUNDCOLOR;
        self.separatorColor = BACKGROUNDCOLOR;
        
        if (@available(iOS 11.0, *)) {
            self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            self.estimatedRowHeight = 0;
            self.estimatedSectionHeaderHeight = 0;
            self.estimatedSectionFooterHeight = 0;
        }
        
//        self.contentInset = UIEdgeInsetsMake(0.0, 0.0, [self isIPhoneX] ? 34.0 : 0.0, 0.0);
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = BACKGROUNDCOLOR;
        self.separatorColor = BACKGROUNDCOLOR;
//        self.separatorStyle = UITableViewCellSeparatorStyleNone;

        if (@available(iOS 11.0, *)) {
            self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            self.estimatedRowHeight = 0;
            self.estimatedSectionHeaderHeight = 0;
            self.estimatedSectionFooterHeight = 0;
        }
        
//        self.contentInset = UIEdgeInsetsMake(0.0, 0.0, [self isIPhoneX] ? 34.0 : 0.0, 0.0);
    }
    
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.backgroundColor = BACKGROUNDCOLOR;
    self.separatorColor = BACKGROUNDCOLOR;
    
    if (@available(iOS 11.0, *)) {
        self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        self.estimatedRowHeight = 0;
        self.estimatedSectionHeaderHeight = 0;
        self.estimatedSectionFooterHeight = 0;
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];

    if (CGRectEqualToRect(_noDataViewFrame, CGRectZero)) {
        _noDataView.frame = self.bounds;
    }
    else {
        _noDataView.frame = CGRectMake(0.0, 0.0, CGRectGetWidth(_noDataViewFrame), CGRectGetHeight(_noDataViewFrame));
        _noDataView.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    }
}



- (CGSize)preferredContentSize {
    // Force the table view to calculate its height
    [self layoutIfNeeded];
    return self.contentSize;
}



#pragma mark - CYLTableViewPlaceHolder Delegate

- (UIView *)makePlaceHolderView {
    if (CGRectEqualToRect(_noDataViewFrame, CGRectZero)) {
        _noDataView = [[NoDataCustomeView alloc] initWithFrame:self.bounds imageName:_placeholderImageName content:_placeholderContent];
    }
    else {
        _noDataView = [[NoDataCustomeView alloc] initWithFrame:CGRectMake(0.0, 0.0, CGRectGetWidth(_noDataViewFrame), CGRectGetHeight(_noDataViewFrame)) imageName:_placeholderImageName content:_placeholderContent];
        _noDataView.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    }

    return _noDataView;
}
 
- (BOOL)enableScrollWhenPlaceHolderViewShowing {
    return YES;
}



#pragma mark - Private Func

- (BOOL)isBlankString:(NSString *)string {
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}

@end
