//
//  UIViewController+Utils.m
//

#import "UIViewController+Utils.h"

@implementation UIViewController (Util)

/// 获取当前VC
+ (UIViewController *)currentViewController {
    // Find best view controller
    UIViewController *viewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    return [UIViewController findBestViewController:viewController];
}

+ (UIViewController *)findBestViewController:(UIViewController *)vc {
    if (vc.presentedViewController) {
        // Return presented view controller
        return [UIViewController findBestViewController:vc.presentedViewController];
    } else if ([vc isKindOfClass:[UISplitViewController class]]) {
        // Return right hand side
        UISplitViewController *svc = (UISplitViewController *) vc;
        if (svc.viewControllers.count > 0)
            return [UIViewController findBestViewController:svc.viewControllers.lastObject];
        else
            return vc;
    } else if ([vc isKindOfClass:[UINavigationController class]]) {
        // Return top view
        UINavigationController *svc = (UINavigationController *) vc;
        if (svc.viewControllers.count > 0)
            return [UIViewController findBestViewController:svc.topViewController];
        else
            return vc;
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        // Return visible view
        UITabBarController *svc = (UITabBarController *) vc;
        if (svc.viewControllers.count > 0)
            return [UIViewController findBestViewController:svc.selectedViewController];
        else
            return vc;
    } else {
        // Unknown view controller type, return last child view controller
        return vc;
    }
}

- (CGFloat)naviHeight
{
    BOOL navIsTranlucent = [UINavigationBar appearance].translucent;
    
    BOOL isIPhoneXSeries = [self isIPhoneXSeries];
    CGFloat navHeight = isIPhoneXSeries ? 88.0 : 64.0;
    CGFloat heightDiff = navIsTranlucent ? 0.0 : navHeight;
    return heightDiff;
}

/// 配置状态栏样式
//- (void)configStatusBarStyle:(UIStatusBarStyle)style {
//    [[UIApplication sharedApplication] setStatusBarStyle:style animated:YES];
//}



#pragma mark - Navigation Stack

/// 从导航栈中移除某个UIViewController
- (void)removeViewControllerFromNavigationStackWith:(Class)viewControllerClass {
    
    NSMutableArray *viewControllers = [[NSMutableArray alloc] initWithArray:self.navigationController.childViewControllers];
    
    for (int i = 0; i < viewControllers.count; i++) {
        UIViewController *vc = viewControllers[i];
        if ([vc isKindOfClass:viewControllerClass]) {
            [viewControllers removeObject:vc];
        }
    }
    
    self.navigationController.viewControllers = viewControllers;
    
//    NSArray* tempVCA = [self.navigationController viewControllers];
//    
//    for(UIViewController *tempVC in tempVCA)
//    {
//        if([tempVC isKindOfClass:viewControllerClass])
//        {
//            [tempVC removeFromParentViewController];
//        }
//    }
}

/// 从导航栈中移除fromViewControllerClasses 到[self class]之间的VC（使用ViewController的name进行查找）
- (void)removeViewControllerWithStartControllerClassNames:(NSArray *)startClassNames {
    for (int i = 0; i < startClassNames.count; i++) {
        Class startClass = NSClassFromString(startClassNames[i]);
        BOOL flag;
        flag = [self canRemoveViewControllerFrom:startClass to:[self class]];
        if (flag) {
            break;
        }
    }
}

/// 从导航栈中移除fromViewControllerClasses 到[self class]之间的VC
- (void)removeViewControllerWithStartControllerClasses:(NSArray *)startClasses {
    for (int i = 0; i < startClasses.count; i++) {
        Class startClass = startClasses[i];
        BOOL flag;
        flag = [self canRemoveViewControllerFrom:startClass to:[self class]];
        if (flag) {
            break;
        }
    }
}

/// 从导航栈中移除fromViewControllerClass 到 toViewControllerClass之间的VC
- (BOOL)canRemoveViewControllerFrom:(Class)fromClass
                                 to:(Class)toClass {
    NSMutableArray *viewControllers = [[NSMutableArray alloc] initWithArray:self.navigationController.viewControllers];
    // 将要删除的VC放到该数组中
    NSMutableArray *removedVCs = [NSMutableArray array];
    
    NSInteger fromIndex = -1;
    NSInteger toIndex = -1;
    /// 是否发现起始VC
    BOOL flag = NO;
    
    for (int i = 0; i < viewControllers.count; i++) {
        UIViewController *vc = viewControllers[i];
        if ([vc isKindOfClass:fromClass]) {
            fromIndex = i;
            flag = YES;
        } else if ([vc isKindOfClass:toClass]) {
            toIndex = i;
        }
        
        // 如果已发现起始VC，并且viewController不为要删除的VC时，记录到要删除的数组中
        if (flag == YES &&
            i != fromIndex &&
            i != toIndex) {
            [removedVCs addObject:vc];
        }
    }
    
//    if (flag == NO &&
//        (fromIndex == -1 || toIndex == -1) ||
//        fromIndex >= toIndex) {
    if (flag == NO) {
        return NO;
    }
    
    for (UIViewController *vc in removedVCs) {
        [viewControllers removeObject:vc];
    }
    
    self.navigationController.viewControllers = viewControllers;
    return YES;
}


/// 跳转至指定UIViewController集中的某一个，依次对比，只要找到就直接跳转
- (BOOL)popToViewControllerWithClassNames:(NSArray<NSString *> *)classNames {
    for (NSString *className in classNames) {
        Class cls = NSClassFromString(className);
        if ([self popToViewControllerWithClass:cls] == YES) {
            return YES;
        }
    }
    return NO;
}


/// 跳转至某个UIViewController，如果找不到该Controller则什么也不做
- (BOOL)popToViewControllerWithClass:(Class)viewControllerClass {
    if (!self) {
        return NO;
    }
    
    BOOL flag = NO;
    UIViewController *destController = nil;
    NSArray *childControllers = self.navigationController.childViewControllers;
    for (UIViewController *vc in childControllers) {
        if ([vc isKindOfClass: viewControllerClass]) {
            flag = YES;
            destController = vc;
            break;
        }
    }
    
    if (flag == YES) {
        [self.navigationController popToViewController:destController animated:YES];
    }
    return flag;
}

/// 跳转至某个UIViewController，从数组中查找，找到就跳转
- (BOOL)popToViewControllerWithClasses:(NSArray<Class> *)viewControllerClasses {
    if (!self) {
        return NO;
    }
    
    BOOL flag = NO;
    UIViewController *destController = nil;
    NSArray *childControllers = [[self.navigationController.childViewControllers reverseObjectEnumerator] allObjects];
    for (UIViewController *vc in childControllers) {
        for (Class cls in viewControllerClasses) {
            if ([vc isKindOfClass: cls]) {
                flag = YES;
                destController = vc;
                break;
            }
        }
        if (flag == YES) {
            break;
        }
    }
    
    if (flag == YES) {
        [self.navigationController popToViewController:destController animated:YES];
    }
    return flag;
}

/// 跳转至某之前的第一个相同的UIViewController（返回YES）
- (BOOL)popToFirstSameViewControllerWith:(Class)viewControllerClass {
    if (!self) {
        return NO;
    }
    
    NSMutableArray *lastSomeVCArray = [NSMutableArray array];
    NSArray *childControllers = self.navigationController.childViewControllers;
    for (UIViewController *vc in childControllers) {
        if ([vc isKindOfClass: viewControllerClass]) {
            [lastSomeVCArray addObject:vc];
        }
    }
    if (lastSomeVCArray.count > 0) {
        [self.navigationController popToViewController:[lastSomeVCArray firstObject] animated:YES];
        return YES;
    } else {
        return NO;
    }
}

/// pop次数
- (void)popToViewControllerWithCount:(NSInteger)count {
    NSInteger naviStackCount = self.navigationController.viewControllers.count;
    if (naviStackCount-count > 0) {
        UIViewController *vc = (__kindof UIViewController *)self.navigationController.viewControllers[self.navigationController.viewControllers.count-count-1];
        [self.navigationController popToViewController:vc  animated:YES];
    }
}

/// 导航栈是否包含某个控制器
- (BOOL)containViewControllerWithClassName:(NSString *)className {
    Class cls = NSClassFromString(className);
    BOOL containVC = [self containViewControllerWith:cls];
    return containVC;
}


/// 在 viewDidAppear 时判断当前界面是 push 了新界面还是 pop 出去
- (BOOL)isPopWhenDidDisappear {
    NSArray *viewControllers = self.navigationController.viewControllers;

    if (viewControllers == nil || viewControllers.count == 0) {
        return YES;
    }
    else if (viewControllers.count > 1 && [viewControllers objectAtIndex:viewControllers.count-2] == self) {
        //push
        return NO;
    } else if ([viewControllers indexOfObject:self] == NSNotFound) {
        //pop
        return YES;
    }
    else {
        return NO;
    }
}



#pragma mark - Gesture

/// 禁用右滑返回手势
- (void)popGestureClose
{
    
    if (self.navigationController == nil) {
        return;
    }
    
    // 禁用侧滑返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        //这里对添加到右滑视图上的所有手势禁用
        for (UIGestureRecognizer *popGesture in self.navigationController.interactivePopGestureRecognizer.view.gestureRecognizers) {
            popGesture.enabled = NO;
        }
        //若开启全屏右滑，不能再使用下面方法，请对数组进行处理
        //VC.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

/// 开启右滑返回手势
- (void)popGestureOpen
{
    if (self.navigationController == nil) {
        return;
    }
    
    // 启用侧滑返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        //这里对添加到右滑视图上的所有手势启用
        for (UIGestureRecognizer *popGesture in self.navigationController.interactivePopGestureRecognizer.view.gestureRecognizers) {
            popGesture.enabled = YES;
        }
        //若开启全屏右滑，不能再使用下面方法，请对数组进行处理
        //VC.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}



#pragma mark - Private Func


- (BOOL)containViewControllerWith:(Class)viewControllerClass {
    NSMutableArray *viewControllers = [[NSMutableArray alloc] initWithArray:self.navigationController.viewControllers];
    BOOL flag = NO;
    
    for (int i = 0; i < viewControllers.count; i++) {
        UIViewController *vc = viewControllers[i];
        if ([vc isKindOfClass:viewControllerClass]) {
            flag = YES;
            break;
        }
    }
    return flag;
}

- (BOOL)isIPhoneXSeries {
    BOOL iPhoneXSeries = NO;
    if (UIDevice.currentDevice.userInterfaceIdiom != UIUserInterfaceIdiomPhone) {
        return iPhoneXSeries;
    }

    if (@available(iOS 11.0, *)) {
        UIWindow *mainWindow = [[[UIApplication sharedApplication] delegate] window];
        if (mainWindow.safeAreaInsets.bottom > 0.0) {
            iPhoneXSeries = YES;
        }
    }

    return iPhoneXSeries;
}

@end


@implementation UINavigationController (ShouldPopOnBackButton)


- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item {
    
    if ([self.viewControllers count] < [navigationBar.items count]) {
        return YES;
    }
    
    BOOL shouldPop = YES;
    UIViewController* vc = [self topViewController];
    if ([vc respondsToSelector:@selector(navigationShouldPopOnBackButton)]) {
        shouldPop = [vc navigationShouldPopOnBackButton];
    }
    
    if(shouldPop) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self popViewControllerAnimated:YES];
        });
    } else {
        // 取消 pop 后，复原返回按钮的状态
        for (UIView *subview in [navigationBar subviews]) {
            if(0. < subview.alpha && subview.alpha < 1.) {
                [UIView animateWithDuration:.25 animations:^{
                    subview.alpha = 1.;
                }];
            }
        }
    }
    return NO;
}

@end


