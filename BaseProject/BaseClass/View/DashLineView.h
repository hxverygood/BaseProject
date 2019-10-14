//
//  DashLineView.h
//  LDDriverSide
//
//  Created by shandiangou on 2018/6/26.
//  Copyright © 2018年 lightingdog. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, DashDirectionType) {
    DashDirectionTypeHorizontal,
    DashDirectionTypeVertical
};



@interface DashLineView : UIView

@property (nonatomic, assign) CGFloat lineLength;
@property (nonatomic, assign) CGFloat lineSpacing;
@property (nonatomic, strong) UIColor *lineColor;
@property (nonatomic, assign) DashDirectionType direction;

@end
