//
//  XAlertView.h
//  LDDriverSide
//
//  Created by shandiangou on 2018/6/5.
//  Copyright © 2018年 lightingdog. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XAlertView : UIView

@property (nonatomic, strong) UIButton * btn1;
@property (nonatomic, strong) UIButton * btn2;
@property (nonatomic, strong) UIButton * btn3;
- (instancetype)initWithTitle:(NSString *)title content:(NSString *)content;
- (void)dissmiss;
- (void)show;

@end
