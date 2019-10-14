//
//  BaseViewController.h
//
//  Created by hans on 2017/8/10.
//  Copyright © 2017年. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocationManager.h"
#import "User.h"

@interface BaseViewController : UIViewController

@property (nonatomic, assign) BOOL navbarIsTranslucent;
@property (nonatomic, assign) BOOL navbarIsDark;


/**
 是否使用 isUseNavbarIsTrans 个别界面使用
 */
@property (nonatomic, assign) BOOL isUseNavbarIsTrans;

// 用户信息
@property (nonatomic, copy, readonly) User *user;

//定位管理
//@property (nonatomic, strong) LocationManager *locationManager;


//- (void)changeNavigationBar;

@end
