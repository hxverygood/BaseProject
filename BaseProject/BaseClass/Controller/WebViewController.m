//
//  WebViewController.m
//  HSAdvisorAPP
//
//  Created by hoomsun on 2017/3/3.
//  Copyright © 2017年 hoomsun. All rights reserved.
//

#import "WebViewController.h"
#import "WKWebView+Utils.h"
#import "UIView+Utils.h"
#import "NSDictionary+Accessors.h"
#import "PublicFunction.h"
#import <KVOController/KVOController.h>
#import "HUD.h"

//static NSString *const scriptMessageHandlerName = @"messageHandlerName";

@interface WebViewController () <WKUIDelegate, WKNavigationDelegate, WKScriptMessageHandler, NSURLSessionDelegate>
//@property (weak, nonatomic) IBOutlet WKWebView *webView;
@property (nonatomic, strong) WKWebViewConfiguration *wkWebConfig;
@property (nonatomic, strong) UIProgressView *progressView;
/// 导航栏左上角关闭按钮
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UILabel *waterMarkLabel;
@property (nonatomic, strong) UIImageView *waterMarkImageView;
@end

@implementation WebViewController

#define POST_JS @"function my_post(path, params) {\
var method = \"POST\";\
var form = document.createElement(\"form\");\
form.setAttribute(\"method\", method);\
form.setAttribute(\"action\", path);\
form.setAttribute(\"accept-charset\", \"UTF-8\");\
for(var key in params){\
if (params.hasOwnProperty(key)) {\
var hiddenFild = document.createElement(\"input\");\
hiddenFild.setAttribute(\"type\", \"hidden\");\
hiddenFild.setAttribute(\"name\", key);\
hiddenFild.setAttribute(\"value\", params[key]);\
}\
form.appendChild(hiddenFild);\
}\
document.body.appendChild(form);\
form.submit();\
}"


#pragma mark - Getter

- (UIProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[UIProgressView alloc] init];
        _progressView.frame = CGRectZero;
        //设置进度条的高度，进度条的宽度变为原来的1倍，高度变为原来的1.5倍.
        _progressView.transform = CGAffineTransformMakeScale(1.0, 3.0);
        _progressView.trackTintColor = [UIColor clearColor];
        _progressView.progressTintColor = _progressViewColor ? : MAIN_COLOR;
        [self.view addSubview:self.progressView];
    }
    return _progressView;
}

- (WKWebView *)webView {
    if (!_webView) {
        
        _webView.backgroundColor = [[UIColor alloc] initWithRed:251/255.0 green:251/255.0 blue:251/255.0f alpha:1];
        
        self.wkWebConfig = [[WKWebViewConfiguration alloc] init];
        self.wkWebConfig.allowsInlineMediaPlayback = YES;

        if (![WebViewController isBlankString:_scriptMessageHandlerName]) {
            WKUserContentController *userCC = self.wkWebConfig.userContentController;
            [userCC addScriptMessageHandler:self name:_scriptMessageHandlerName];
            self.wkWebConfig.userContentController = userCC;
        }

        CGRect frame = [UIView fullScreenFrame];
        if (self.navbarIsTranslucent) {
            frame.size.height = [[UIScreen mainScreen] bounds].size.height;
        }
        _webView = [[WKWebView alloc] initWithFrame:frame configuration:self.wkWebConfig];
        [self.view addSubview:_webView];
    }
    return _webView;
}

- (UILabel *)waterMarkLabel {
    if (!_waterMarkLabel) {
        UILabel *waterMarkLabel = [[UILabel alloc] init];
        waterMarkLabel.frame = CGRectMake(0.0, 0.0, 100.0, 100.0);
        waterMarkLabel.center = self.view.center;
        waterMarkLabel.numberOfLines = 0;
        
        _waterMarkLabel = waterMarkLabel;
    }
    return _waterMarkLabel;
}



#pragma mark - Setter

- (void)setWebViewInsets:(UIEdgeInsets)webViewInsets {
    _webViewInsets = webViewInsets;
    
    self.webView.scrollView.contentInset = webViewInsets;
}

- (void)setUrlStr:(NSString *)urlStr {
    _urlStr = urlStr;
}

-(void)setParamStr:(NSString *)paramStr {
    _paramStr = paramStr;
}

- (void)setShowCloseButton:(BOOL)showCloseButton {
    _showCloseButton = showCloseButton;

    _closeButton.hidden = !showCloseButton;
}



#pragma mark - Life Cycle

- (void)dealloc {
//    if ([self isViewLoaded]) {
//        @try {
//            [_webView removeObserver:self forKeyPath:@"estimatedProgress" context:nil];
//        }
//        @catch (NSException *exception) {}
//    }
    _webView.scrollView.delegate = nil;
    _webView.navigationDelegate = nil;

    if (_noDeleteCacheAfterClose == NO) {
        [_webView deleteWebCache];
    }

    _webView = nil;

    [[NSNotificationCenter defaultCenter] removeObserver:self];

    [_closeButton removeFromSuperview];
    _closeButton = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (_statusBarStyle) {
        [[UIApplication sharedApplication] setStatusBarStyle:_statusBarStyle animated:YES];
    }

//    CGRect frame = [UIView fullScreenFrame];
//    if (self.navbarIsTranslucent) {
//        frame.size.height = [[UIScreen mainScreen] bounds].size.height;
//    }
//    self.webView.frame = frame;
}


- (void)viewDidDisappear:(BOOL)animated {
    if (![WebViewController isBlankString:_scriptMessageHandlerName]) {
        [_wkWebConfig.userContentController removeScriptMessageHandlerForName:_scriptMessageHandlerName];
    }
//    [_webView deleteWebCache];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupView];
}

- (void)setupView {
    // 关闭按钮
    _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_closeButton setImage:[UIImage imageNamed:@"icon_close_black"] forState:UIControlStateNormal];
    _closeButton.frame = CGRectMake(40.0, 5.0, 40.0, 34.0);
    [_closeButton addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.navigationBar addSubview:_closeButton];
    _closeButton.hidden = !_showCloseButton;



    self.view.backgroundColor = [UIColor whiteColor];
    if ([WebViewController isBlankString:self.titleStr] == NO) {
        self.title = self.titleStr;
    }

    self.webView.navigationDelegate = self;
    self.webView.allowsBackForwardNavigationGestures = NO;
    self.webView.UIDelegate = self;
    self.webView.navigationDelegate = self;
    //    [self.webView reloadFromOrigin];

    // 添加“加载进度”的监听
    __weak typeof(self) weakself = self;
    [self.KVOController observe:_webView keyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change) {
        if (object == weakself.webView)
        {
            if (weakself.progressView.progress < 1.0)
            {
                weakself.progressView.progress = weakself.webView.estimatedProgress;
            }
        }
    }];
//    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
//    [self.webView addObserver:self forKeyPath: @"title" options:NSKeyValueObservingOptionNew context:nil];

    if ([WebViewController isBlankString:self.paramStr]) {
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlStr]]];
    }else {
        NSString *js = [NSString stringWithFormat:@"%@my_post(\"%@\", %@)",POST_JS,self.urlStr,self.paramStr];
        [self.webView evaluateJavaScript:js completionHandler:nil];
    }


    /* 解决视频自动全屏播放结束后状态栏隐藏的问题 */
    //监听UIWindow显示
    //    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(beginFullScreen) name:UIWindowDidBecomeVisibleNotification object:nil];
    //监听UIWindow隐藏
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endFullScreen) name:UIWindowDidBecomeHiddenNotification object:nil];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.progressView.frame = CGRectMake(0.0, 0.0, [[UIScreen mainScreen] bounds].size.width, 2.0);

    CGRect frame = [UIView fullScreenFrame];

    // 导航栏透明，带返回按钮，需要重新设置 frame 和 contentInsets
    if (self.navbarIsTranslucent) {
        frame.origin.y = 0.0;
        frame.size.height = [[UIScreen mainScreen] bounds].size.height;

        if (@available(iOS 11.0, *)) {
            self.webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    self.webView.frame = frame;

    // 加水印
    if (_waterMarkContent.length > 0) {
        if (self.waterMarkImageView) {
            [self.waterMarkImageView removeFromSuperview];
            self.waterMarkImageView = nil;
        }
        BOOL navIsTranlucent = [UINavigationBar appearance].translucent;
//        CGFloat heightDiff = navIsTranlucent ? 0.0 : 64.0;
        
        UIImage *waterMarkImage = [self wateMarkImageInRect:(CGRect){CGPointMake(0.0, navIsTranlucent ? 64.0 : 0.0), CGSizeMake(CGRectGetWidth(self.webView.frame), CGRectGetHeight(self.webView.frame))} waterMarkText:_waterMarkContent];
        self.waterMarkImageView = [[UIImageView alloc] initWithImage:waterMarkImage];
        self.waterMarkImageView.frame = CGRectMake(0.0, navIsTranlucent ? 64.0 : 0.0, CGRectGetWidth(self.webView.frame), CGRectGetHeight(self.webView.frame));
        [self.view insertSubview:self.waterMarkImageView aboveSubview:self.webView];
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    if (_statusBarStyle) {
        return _statusBarStyle;
    }
    else {
        return UIStatusBarStyleDefault;
    }
}

- (BOOL)shouldAutorotate {
    return _allowRotation;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientation {
    return UIInterfaceOrientationMaskLandscape;
}



#pragma mark - WKWebView Delegate

// 开始加载
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    if (_showProgressHUD) {
        [HUD show];
    }
    
    NSLog(@"开始加载网页");
    //开始加载网页时展示出progressView
    self.progressView.hidden = NO;
    //开始加载网页的时候将progressView的Height恢复为1.5倍
    self.progressView.transform = CGAffineTransformMakeScale(1.0f, 3.0f);
    //防止progressView被网页挡住
    [self.view bringSubviewToFront:self.progressView];
}

// 加载完成
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    if (_showProgressHUD) {
        [HUD dismiss];
    }
    NSLog(@"网页加载完成");
    //加载完成后隐藏progressView
    /*
     *添加一个简单的动画，将progressView的Height变为1.4倍，在开始加载网页的代理中会恢复为1.5倍
     *动画时长0.25s，延时0.3s后开始动画
     *动画结束后将progressView隐藏
     */
    __weak typeof (self)weakSelf = self;
    [UIView animateWithDuration:0.25f delay:0.3f options:UIViewAnimationOptionCurveEaseOut animations:^{
        weakSelf.progressView.progress = 1.0;
        weakSelf.progressView.transform = CGAffineTransformMakeScale(1.0, 2.0);
    } completion:^(BOOL finished) {
        weakSelf.progressView.hidden = YES;
        [HUD dismiss];
    }];
    
    // 如果VC的标题为空，并且网页的标题不为空，则把网页标题赋值给VC标题
    NSString *webViewTitle = [webView.title copy];
    if ([WebViewController isBlankString:self.title] &&
        [WebViewController isBlankString:webViewTitle] == NO) {
//        self.navigationItem.title = webViewTitle;
    }

    self.webView.allowsBackForwardNavigationGestures = _showCloseButton;

//    else if ([webView.URL.description isEqualToString:self.urlStr] && self.webView.canGoBack)
//    {
//        self.webView.allowsBackForwardNavigationGestures = NO;
//    }else
//    {
//        self.webView.allowsBackForwardNavigationGestures = YES;
//    }
}

// 加载失败
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    if (error.code == -1001) {
        [HUD showInfoWithStatus:@"页面加载时间过长，请稍后再试"];
        return;
    }
    else if (error.code == -1003) {
        [HUD showInfoWithStatus:@"未能连接到服务器，请稍后再试"];
        return;
    }
    else if (error.code == -1100) {
        [HUD showInfoWithStatus:@"页面链接问题，请稍后再试"];
        return;
    }
    
    NSString *errorInfo = [error.userInfo ac_stringForKey:@"localizedDescription"];
    if (errorInfo) {
        [HUD showInfoWithStatus:errorInfo];
    }
    else if (_showProgressHUD) {
        [HUD dismiss];
    }
    
    //加载失败同样需要隐藏progressView
    self.progressView.progress = 0.0;
    self.progressView.hidden = YES;
    
}

// 在发送请求之前，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {

    NSURLRequest *request = navigationAction.request;
    NSString *urlStr = request.URL.absoluteString;
    NSLog(@"加载URL: %@", urlStr);

    if ([urlStr hasPrefix:@"tel:"]) {
        [PublicFunction callWithPhoneLinks:urlStr];
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    else if ([urlStr hasSuffix:@"#"]) {
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    
    // 点击链接
    if (navigationAction.navigationType == WKNavigationTypeLinkActivated) {
        WebViewController *vc = [[WebViewController alloc] init];
        vc.urlStr = urlStr;
        
//        NSString *tmpURLStr = [urlStr lowercaseString];
//        BOOL isPDFUrl = [tmpURLStr hasSuffix:@"pdf"];
//        if (isPDFUrl) {
//            HSUser *user = [HSLoginInfo savedLoginInfo];
//            vc.waterMarkContent = user.USER_NAME ? : @"红上财富";
//        }
        
        vc.allowRotation = _allowRotation;
        vc.hidesBottomBarWhenPushed = YES;
        if (_progressViewColor) {
            vc.progressViewColor = _progressViewColor;
        }
        [self.navigationController pushViewController:vc animated:YES];
        decisionHandler(WKNavigationActionPolicyCancel);
    } else {
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}



#pragma mark - WKScriptMessageHandler

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    if (self.delegate &&
        [self.delegate respondsToSelector:@selector(wk_userContentController:didReceiveScriptMessage:)]) {
        [self.delegate wk_userContentController:userContentController didReceiveScriptMessage:message];
    }
}


//- (void)sendJSDataWithUserContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
//
//}


#pragma mark - Action

- (void)close {
    if (self.delegate &&
        [self.delegate respondsToSelector:@selector(closeButtonActionForWebViewController:)]) {
        [self.delegate closeButtonActionForWebViewController:self];
    }
    else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (BOOL)navigationShouldPopOnBackButton {
    if (self.webView.canGoBack) {
        [self.webView goBack];
    }
    else {
        [self.navigationController popViewControllerAnimated:YES];
    }
    return NO;
}



#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSString *,id> *)change
                       context:(void *)context {    
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        
        if (object == _webView)
        {
            if (self.progressView.progress < 1.0)
            {
                self.progressView.progress = self.webView.estimatedProgress;
            }
        }
        else
        {
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
        
    }
    else if ([keyPath isEqualToString:@"title"]) {
        if ([WebViewController isBlankString:self.title]) {
            self.navigationItem.title = self.webView.title;
        }
    }
    else if ([keyPath isEqualToString: @"canGoBack"]) {
        [self goBackStateChanged];
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)goBackStateChanged {
    if (self.navigationItem.leftBarButtonItem == nil && self.webView.canGoBack) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_back"] style:UIBarButtonItemStylePlain target:self action:@selector(webViewGoBack)];

    }

    if (self.webView.canGoBack == false) {
        [self.navigationItem setHidesBackButton:true animated:true];
        self.navigationItem.leftBarButtonItem = nil;
    }

}

- (void)webViewGoBack {
    [self.webView goBack];
}



#pragma mark - Func

/**
 * 加半透明水印
 * @param rect 需要加水印的区域
 * @param waterMarkText 水印文字
 * @returns 加好水印的图片
 */
- (UIImage *)wateMarkImageInRect:(CGRect)rect
                   waterMarkText:(NSString *)waterMarkText {
    
    CGFloat w = 100.0;
    CGFloat h = 40.0;
    
    UIGraphicsBeginImageContext(CGSizeMake(w, h));
    
    UIColor *color = [UIColor colorWithRed:160/255.0 green:160/255.0 blue:160/255.0 alpha:0.6];
    UIFont *font = [UIFont systemFontOfSize:16.0];
    [waterMarkText drawInRect:CGRectMake(10.0, 0.0, w, h) withAttributes:@{NSFontAttributeName:font, NSForegroundColorAttributeName:color}];
    UIImage *tmpImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    

    UIGraphicsBeginImageContext(CGSizeMake(w, h*2));
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    transform = CGAffineTransformRotate(transform, M_PI/6);
    
    CGContextRef ctx_ = UIGraphicsGetCurrentContext();
    CGContextConcatCTM(ctx_, transform);
    CGContextDrawImage(ctx_, (CGRect){CGPointMake(10.0, 0.0), tmpImage.size}, tmpImage.CGImage);
    UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();

    
    
    UIGraphicsBeginImageContext(rect.size);
    // 平铺
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextDrawTiledImage(ctx, (CGRect){CGPointZero, CGSizeMake(w, h*2)}, [smallImage CGImage]);
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return resultingImage;
}

// 结束全屏播放
- (void)endFullScreen {
    [[UIApplication sharedApplication] setStatusBarHidden:false withAnimation:UIStatusBarAnimationFade];
}

/// 判断字符串是否为空
+ (BOOL)isBlankString:(NSString *)string {
    if (![string isKindOfClass:[NSString class]]) {
        return YES;
    }

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



#pragma mark - 内存警告

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
