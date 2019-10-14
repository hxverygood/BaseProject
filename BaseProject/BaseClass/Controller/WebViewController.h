//
//  WebViewController.h
//  HSAdvisorAPP
//
//  Created by hoomsun on 2017/3/3.
//  Copyright © 2017年 hoomsun. All rights reserved.
//

#import "BaseViewController.h"
#import <WebKit/WebKit.h>

@class WebViewController;

@protocol WebViewControllerProtocol <NSObject>

@optional

- (void)wk_userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message;

- (void)closeButtonActionForWebViewController:(WebViewController *)WebViewController;

@end



@interface WebViewController : BaseViewController

@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, copy) NSString *titleStr;
@property (nonatomic, copy) NSString *urlStr;
@property (nonatomic, copy) NSString *scriptMessageHandlerName;
@property (nonatomic, assign) UIEdgeInsets webViewInsets;
@property (nonatomic, assign) UIStatusBarStyle statusBarStyle;
@property (nonatomic, copy) NSString *waterMarkContent;

@property (nonatomic, copy) NSString *paramStr;

@property (nonatomic, strong) UIColor *progressViewColor;
@property (nonatomic, assign) BOOL showProgressHUD;
@property (nonatomic, assign) BOOL allowRotation;

/**
 是否显示关闭按钮
 显示关闭按钮时需重写 webView:decidePolicyForNavigationAction:decisionHandler: 方法
 不需要跳转至新的 webViewController 而只在当前 controller 刷新页面
 */
@property (nonatomic, assign) BOOL showCloseButton;

/// 关闭 webVC 后不删除缓存
@property (nonatomic, assign) BOOL noDeleteCacheAfterClose;

// 完成某项工作后是否pop回上一个VC
@property (nonatomic, assign) BOOL needPop;

@property (nonatomic, weak) id<WebViewControllerProtocol> delegate;

- (void)setupView;


//- (void)sendJSDataWithUserContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message;

@end
