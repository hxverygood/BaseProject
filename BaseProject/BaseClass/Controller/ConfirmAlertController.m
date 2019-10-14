//
//  ConfirmAlertController.m
//  HSRongyiBao
//
//  Created by hoomsun on 2016/12/28.
//  Copyright © 2016年 hoomsun. All rights reserved.
//

#import "ConfirmAlertController.h"

@interface ConfirmAlertController ()

@property (nonatomic, copy) void(^ __nullable actionBlock)(NSInteger confirmIndex, UIAlertAction * __nullable cancelAction);
@property (nonatomic, weak) UIViewController *vc;

@end



@implementation ConfirmAlertController

#pragma mark - Setter

- (void)setAttrMessage:(NSMutableAttributedString *)attrMessage {
    _attrMessage = attrMessage;

    [self setValue:attrMessage forKey:@"attributedMessage"];
}

- (void)setTextAlignment:(TextAlignmentOption)textAlignment {
    _textAlignment = textAlignment;
    
    if ([ConfirmAlertController isBlankString:self.message]) {
        return;
    }
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:3.0];
    switch (textAlignment) {
        case TextAlignmentOptionCenter:
            paragraphStyle.alignment = NSTextAlignmentCenter;
            break;
            
        case TextAlignmentOptionLeft:
            paragraphStyle.alignment = NSTextAlignmentLeft;
            break;
            
        case TextAlignmentOptionRight:
            paragraphStyle.alignment = NSTextAlignmentRight;
            break;
            
        case TextAlignmentOptionJustified:
            paragraphStyle.alignment = NSTextAlignmentJustified;
            break;
            
        default:
            break;
    }
    
    NSMutableAttributedString *mutStr = [[NSMutableAttributedString alloc] initWithString:self.message];
    NSRange range = NSMakeRange(0, self.message.length);
    [mutStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:range];
    self.attrMessage = mutStr;
}



#pragma mark - Initializer

/**
 显示界面中间弹出的提示框(1个按钮)，message是attributedString
 只有确定按钮有回调
 */
+ (instancetype _Nullable)oneButtonAlertWithTitle:(NSString * __nullable)title
                                     confirmTitle:(NSString * __nullable)confirmTitle
                                      actionStyle:(UIAlertActionStyle)actionStyle
                                   viewController:(UIViewController * __nonnull)viewController
                                      actionBlock:(void(^ __nullable)(NSInteger confirmIndex, UIAlertAction * __nullable cancelAction))actionBlock {
    ConfirmAlertController *alertViewController = [[ConfirmAlertController alloc] initWithTitle:title message:nil buttonCount:1 confirmTitles:confirmTitle ? @[confirmTitle] : @[@"确定"] cancelTitle:nil style:UIAlertControllerStyleAlert actionStyle:actionStyle viewController:viewController actionBlock:actionBlock];
    
    return alertViewController;
}

/// 显示ActionSheet
+ (void)actionSheetWithTitle:(NSString * __nullable)title
                     message:(NSString * __nullable)message
                confirmTitle:(NSString * __nullable)confirmTitle
                 cancelTitle:(NSString * __nullable)cancelTitle
                 actionStyle:(UIAlertActionStyle)actionStyle
              viewController:(UIViewController * __nonnull)viewController
                 actionBlock:(void(^ __nullable)(NSInteger confirmIndex, UIAlertAction * __nullable cancelAction))actionBlock {
    
    __weak typeof(viewController) weakVC = viewController;
    ConfirmAlertController *alertViewController = [[ConfirmAlertController alloc] initWithTitle:title message:message buttonCount:2 confirmTitles:confirmTitle ? @[confirmTitle] : @[@"确定"] cancelTitle:cancelTitle style:UIAlertControllerStyleActionSheet actionStyle:actionStyle viewController:viewController actionBlock:actionBlock];
    [weakVC presentViewController:alertViewController animated:YES completion:nil];
}

/**
 在当前ViewController界面中间弹出的提示框
 */
//+ (instancetype _Nullable)showAlertWithTitle:(NSString * __nullable)title
//                                     message:(NSString * __nullable)message
//                                confirmTitle:(NSString * __nullable)confirmTitle
//                                 cancelTitle:(NSString * __nullable)cancelTitle
//                                 actionStyle:(UIAlertActionStyle)actionStyle
//                                 actionBlock:(void(^ __nullable)(NSInteger confirmIndex, UIAlertAction * __nullable cancelAction))actionBlock {
//    UIViewController *viewController = [self currentViewController];
//    __weak typeof(viewController) weakVC = viewController;
//    ConfirmAlertController *alertViewController = [[ConfirmAlertController alloc] initWithTitle:title message:message buttonCount:2 confirmTitles:confirmTitle ? @[confirmTitle] : @[@"确定"] cancelTitle:cancelTitle style:UIAlertControllerStyleAlert actionStyle:actionStyle  viewController:viewController actionBlock:actionBlock];
//    [weakVC presentViewController:alertViewController animated:YES completion:nil];
//    
//    return alertViewController;
//}


/**
 显示界面中间弹出的提示框
 */
+ (instancetype _Nullable)showAlertWithTitle:(NSString * __nullable)title
                                     message:(NSString * __nullable)message
                                confirmTitle:(NSString * __nullable)confirmTitle
                                 cancelTitle:(NSString * __nullable)cancelTitle
                                 actionStyle:(UIAlertActionStyle)actionStyle
                              viewController:(UIViewController * __nonnull)viewController
                                 actionBlock:(void(^ __nullable)(NSInteger confirmIndex, UIAlertAction * __nullable cancelAction))actionBlock {
    
    __weak typeof(viewController) weakVC = viewController;
    ConfirmAlertController *alertViewController = [[ConfirmAlertController alloc] initWithTitle:title message:message buttonCount:2 confirmTitles:confirmTitle ? @[confirmTitle] : @[@"确定"] cancelTitle:cancelTitle style:UIAlertControllerStyleAlert actionStyle:actionStyle  viewController:viewController actionBlock:actionBlock];
    [weakVC presentViewController:alertViewController animated:YES completion:nil];
 
    return alertViewController;
}

/**
 显示界面中间弹出的提示框，多个“确定按钮”和1个“取消按钮”
 
 @param title 标题
 @param message 信息
 @param confirmTitles 确定按钮组的文字
 @param cancelTitle 取消按钮文字
 @param viewController 要显示弹框的viewController
 @param actionBlock 按钮回调
 */
+ (void)showAlertWithTitle:(NSString * __nullable)title
                   message:(NSString * __nullable)message
             confirmTitles:(NSArray<NSString *> * __nullable)confirmTitles
               cancelTitle:(NSString * __nullable)cancelTitle
               actionStyle:(UIAlertActionStyle)actionStyle
            viewController:(UIViewController * __nonnull)viewController
               actionBlock:(void(^ __nullable)(NSInteger confirmIndex, UIAlertAction * __nullable cancelAction))actionBlock{
    
    __weak typeof(viewController) weakVC = viewController;
    ConfirmAlertController *alertViewController = [[ConfirmAlertController alloc] initWithTitle:title message:message buttonCount:confirmTitles.count+1 confirmTitles:confirmTitles cancelTitle:cancelTitle style:UIAlertControllerStyleAlert actionStyle:actionStyle  viewController:viewController actionBlock:actionBlock];
    [weakVC presentViewController:alertViewController animated:YES completion:nil];
}



/**
 显示界面中间弹出的提示框(1个按钮)
 只有确定按钮有回调
 */
+ (void)showOneButtonAlertWithTitle:(NSString * __nullable)title
                            message:(NSString * __nullable)message
                       confirmTitle:(NSString * __nullable)confirmTitle
                        actionStyle:(UIAlertActionStyle)actionStyle
                     viewController:(UIViewController * __nonnull)viewController
                        actionBlock:(void(^ __nullable)(NSInteger confirmIndex, UIAlertAction * __nullable cancelAction))actionBlock {
    
    __weak typeof(viewController) weakVC = viewController;
    ConfirmAlertController *alertViewController = [[ConfirmAlertController alloc] initWithTitle:title message:message buttonCount:1 confirmTitles:confirmTitle ? @[confirmTitle] : @[@"确定"] cancelTitle:nil style:UIAlertControllerStyleAlert actionStyle:actionStyle  viewController:viewController actionBlock:actionBlock];
    [weakVC presentViewController:alertViewController animated:YES completion:nil];
}

- (instancetype)initWithTitle:(NSString * __nullable)title
                      message:(NSString * __nullable)message
                  buttonCount:(NSInteger)buttonCount
                confirmTitles:(NSArray<NSString *> * __nullable)confirmTitles
                  cancelTitle:(NSString * __nullable)cancelTitle
                        style:(UIAlertControllerStyle)style
                  actionStyle:(UIAlertActionStyle)actionStyle
               viewController:(UIViewController * __nonnull)viewController
                  actionBlock:(void(^ __nullable)(NSInteger confirmIndex, UIAlertAction * __nullable cancelAction))actionBlock {
    self = [super init];
    if (self) {
        ConfirmAlertController *alertController = [ConfirmAlertController alertControllerWithTitle:title message:message preferredStyle:style];
        self = alertController;
        self.title = title;
        self.message = message;
        self.actionBlock = actionBlock;
        self.vc = viewController;
        
        __weak typeof(alertController) weakAlertController = alertController;
        
        // 取消按钮
        if (buttonCount > 1) {
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:cancelTitle ? cancelTitle : @"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                if (weakAlertController.actionBlock) {
                    weakAlertController.actionBlock(-1, action);
                }
            }];
            [alertController addAction:cancel];
        }
        
        for (int i=0; i<confirmTitles.count; i++) {
            NSString *confirmTitle = confirmTitles[i];
            // 确认按钮
            UIAlertAction *confirm = [UIAlertAction actionWithTitle:confirmTitle style:actionStyle handler:^(UIAlertAction * _Nonnull action) {
                if (weakAlertController.actionBlock) {
                    weakAlertController.actionBlock(i, nil);
                }
            }];
            [alertController addAction:confirm];
        }
    }
    return self;
}



#pragma mark - UI

- (void)viewDidLoad {
    [super viewDidLoad];
    
}


#pragma mark - Func

- (void)show {
    [self.vc presentViewController:self animated:YES completion:nil];
}



#pragma mark - Private Func

/// 获取当前VC
- (UIViewController *)currentViewController {
    // Find best view controller
    UIViewController *viewController = [[UIApplication sharedApplication].windows firstObject].rootViewController;
    return [self findBestViewController:viewController];
}

- (UIViewController *)findBestViewController:(UIViewController *)vc {
    if (vc.presentedViewController) {
        // Return presented view controller
        return [self findBestViewController:vc.presentedViewController];
    } else if ([vc isKindOfClass:[UISplitViewController class]]) {
        // Return right hand side
        UISplitViewController *svc = (UISplitViewController *) vc;
        if (svc.viewControllers.count > 0)
            return [self findBestViewController:svc.viewControllers.lastObject];
        else
            return vc;
    } else if ([vc isKindOfClass:[UINavigationController class]]) {
        // Return top view
        UINavigationController *svc = (UINavigationController *) vc;
        if (svc.viewControllers.count > 0)
            return [self findBestViewController:svc.topViewController];
        else
            return vc;
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        // Return visible view
        UITabBarController *svc = (UITabBarController *) vc;
        if (svc.viewControllers.count > 0)
            return [self findBestViewController:svc.selectedViewController];
        else
            return vc;
    } else {
        // Unknown view controller type, return last child view controller
        return vc;
    }
}

/// 判断字符串是否为空
+ (BOOL)isBlankString:(NSString *)string {
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}



#pragma mark - 内存警告

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
