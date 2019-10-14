//
//  UIViewController+Utils.h
//

#import <UIKit/UIKit.h>

@protocol BackButtonHandlerProtocol <NSObject>
@optional
// 重写下面的方法以拦截导航栏返回按钮点击事件，返回 YES 则 pop，NO 则不 pop
- (BOOL)navigationShouldPopOnBackButton;
@end



@interface UIViewController (Util)<BackButtonHandlerProtocol>

/// 设置下一个退出界面的返回图标
//- (void)backBarButtonItemWithImageName:(NSString *)imageName;
/// 设置当前VC的返回按钮
//- (void)currentVCBackBarButtonItemWithName:(NSString *)imageName;

/// 获取当前VC
+ (UIViewController *)currentViewController;

/// 获取当前UIViewController的导航栏高度，透明时为0。
- (CGFloat)naviHeight;


/**
 设置状态栏的风格

 @param style 系统的枚举
 */
//- (void)configStatusBarStyle:(UIStatusBarStyle)style;



#pragma mark - Navigation Stack

/// 从导航栈中移除某个UIViewController
- (void)removeViewControllerFromNavigationStackWith:(Class)viewControllerClass;

/// 从导航栈中移除fromViewControllerClasses 到[self class]之间的VC（使用ViewController的name进行查找）
- (void)removeViewControllerWithStartControllerClassNames:(NSArray *)startClassNames;

/// 从导航栈中移除fromViewControllerClasses 到[self class]之间的VC
- (void)removeViewControllerWithStartControllerClasses:(NSArray *)startClasses;

/// 从导航栈中移除fromViewControllerClass 到 toViewControllerClass之间的VC
- (BOOL)canRemoveViewControllerFrom:(Class)fromClass
                                 to:(Class)toClass;


/// 跳转至指定UIViewController集中的某一个，依次对比，只要找到就直接跳转
- (BOOL)popToViewControllerWithClassNames:(NSArray<NSString *> *)classNames;

/// 跳转至某个UIViewController
- (BOOL)popToViewControllerWithClass:(Class)viewControllerClass;
/// 跳转至某个UIViewController，从数组中查找，找到就跳转
- (BOOL)popToViewControllerWithClasses:(NSArray<Class> *)viewControllerClasses;
/// 跳转至某之前的第一个相同的UIViewController（返回YES）
- (BOOL)popToFirstSameViewControllerWith:(Class)viewControllerClass;
/// pop次数
- (void)popToViewControllerWithCount:(NSInteger)count;

/// 导航栈是否包含某个控制器
- (BOOL)containViewControllerWithClassName:(NSString *)className;

/// 在 viewDidAppear 时判断当前界面是 push 了新界面还是 pop 出去
- (BOOL)isPopWhenDidDisappear;



#pragma mark - Gesture

/// 禁用右滑返回手势
- (void)popGestureClose;
/// 开启右滑返回手势
- (void)popGestureOpen;

@end
