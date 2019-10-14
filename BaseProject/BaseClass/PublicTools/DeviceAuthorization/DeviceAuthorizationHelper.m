//
//  DeviceAuthorizationHelper.m
//  HSRongyiBao
//
//  Created by 韩啸 on 2018/5/10.
//  Copyright © 2018年 hoomsun. All rights reserved.
//

#import "DeviceAuthorizationHelper.h"
#import "HUD.h"

#define kButtonColor    [UIColor colorWithRed:255/255.0 green:157/255.0 blue:4/255.0 alpha:1.0]

//static BOOL allowsEditing = YES;

typedef NS_ENUM(NSInteger, PhotoSelectionOption) {
    PhotoSelectionByAll,
    PhotoSelectionByPhotoLibrary,
    PhotoSelectionByShot
};



@interface DeviceAuthorizationHelper () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

//@property (nonatomic, strong) UIImagePickerController *imagePicker;
@property (nonatomic, copy) void (^photoSelectCompletion)(NSString *errorInfo, UIImage *image, BOOL isCancel);

@end



@implementation DeviceAuthorizationHelper

#pragma mark - Getter

//- (UIImagePickerController *)imagePicker {
//    if (!_imagePicker) {
//        _imagePicker = [[UIImagePickerController alloc] init];
////        _imagePicker.delegate = self;
//    }
//    return _imagePicker;
//}



#pragma mark - Initializer

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initData];
    }
    return self;
}

- (void)initData{
    _pickerTitle = @"选择";
    _image       = nil;

//    _imagePicker = [[UIImagePickerController alloc] init];
//    _imagePicker.delegate = self;
}

- (void)dealloc {
    NSLog(@"%s", __func__);
}



#pragma mark - Func

+ (void)cameraIsNotAuthorizedAndShowAlertWithCompletion:(void (^)(BOOL needAlert))completion {
    NSString *title = @"提示";
    NSString *message = @"请打开相机访问权限";
    __block BOOL authorized;

    [AuthorizationTool requestCameraAuthorization:^(AuthorizationStatus status) {
        authorized = [self getAuthorizationBoolStatus:status];
        if (completion) {
            completion(!authorized);
        }

        if (authorized == NO) {
            [self showAlertControllerWithTitle:title message:message style:UIAlertControllerStyleAlert actionBlock:nil];
        }
    }];
}

+ (void)photoLibraryIsNotAuthorizedAndShowAlertWithCompletion:(void (^)(BOOL needAlert))completion {
    NSString *title = @"提示";
    NSString *message = @"请打开相册访问权限";
    __block BOOL authorized;

    [AuthorizationTool requestImagePickerAuthorization:^(AuthorizationStatus status) {
        authorized = [self getAuthorizationBoolStatus:status];
        if (completion) {
            completion(!authorized);
        }

        if (authorized == NO) {
            [self showAlertControllerWithTitle:title message:message style:UIAlertControllerStyleAlert actionBlock:nil];
        }
    }];
}

- (void)photoSelectionWithCompletion:(void (^)(NSString *errorInfo, UIImage *image, BOOL isCancel))completion {
    self.photoSelectCompletion = completion;
    [self photoSelectionWithOption:PhotoSelectionByAll];
}

- (void)photoFromShotWithCompletion:(void (^)(NSString *errorInfo, UIImage *image, BOOL isCancel))completion {
    self.photoSelectCompletion = completion;
    [self photoSelectionWithOption:PhotoSelectionByShot];
}

- (void)photoSelectionWithOption:(PhotoSelectionOption)option {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];

    switch (option) {
        case PhotoSelectionByAll:
        {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:_pickerTitle message:nil preferredStyle:UIAlertControllerStyleActionSheet];

            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            [alertController addAction:cancel];

            __weak typeof(self) weakself = self;
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
                UIAlertAction *photoAction = [UIAlertAction actionWithTitle:@"从相册选取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [DeviceAuthorizationHelper photoLibraryIsNotAuthorizedAndShowAlertWithCompletion:^(BOOL needAlert) {
                        if (needAlert) {
                            return;
                        }
                        else {
                            imagePicker.sourceType    = UIImagePickerControllerSourceTypePhotoLibrary;
                            imagePicker.delegate      = weakself;
                            imagePicker.allowsEditing = weakself.allowsEditing;
                            imagePicker.navigationBar.tintColor = kButtonColor;
                            [weakself.superViewController presentViewController:imagePicker animated:YES completion:^(){
                                [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
                            }];
                        }
                    }];
                }];
                [alertController addAction:photoAction];
            }

            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [DeviceAuthorizationHelper cameraIsNotAuthorizedAndShowAlertWithCompletion:^(BOOL needAlert) {
                        if (needAlert) {
                            return;
                        }
                        else {
                            imagePicker.sourceType    = UIImagePickerControllerSourceTypeCamera;
                            imagePicker.delegate      = weakself;
                            imagePicker.allowsEditing = weakself.allowsEditing;
                            imagePicker.navigationBar.tintColor = kButtonColor;
                            [weakself.superViewController presentViewController:imagePicker animated:YES completion:^(){
                                [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
                            }];
                        }
                    }];
                }];
                [alertController addAction:cameraAction];
            }

            [self.superViewController presentViewController:alertController animated:YES completion:nil];
        }
            break;

        case PhotoSelectionByPhotoLibrary:
        {
            __weak typeof(self) weakself = self;
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
                [DeviceAuthorizationHelper photoLibraryIsNotAuthorizedAndShowAlertWithCompletion:^(BOOL needAlert) {
                    if (needAlert) {
                        return;
                    }
                    else {
                        imagePicker.sourceType    = UIImagePickerControllerSourceTypePhotoLibrary;
                        imagePicker.delegate      = weakself;
                        imagePicker.allowsEditing = weakself.allowsEditing;
                        imagePicker.navigationBar.tintColor = kButtonColor;
                        [weakself.superViewController presentViewController:imagePicker animated:YES completion:^(){
                            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
                        }];
                    }
                }];
            }
            else {
                if (self.photoSelectCompletion) {
                    self.photoSelectCompletion(@"该设备无法读取相册", nil, NO);
                }
            }
        }
            break;

        case PhotoSelectionByShot:
        {
            __weak typeof(self) weakself = self;
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                [DeviceAuthorizationHelper cameraIsNotAuthorizedAndShowAlertWithCompletion:^(BOOL needAlert) {
                    if (needAlert) {
                        return;
                    }
                    else {
                        imagePicker.sourceType    = UIImagePickerControllerSourceTypeCamera;
                        imagePicker.delegate      = weakself;
                        imagePicker.allowsEditing = weakself.allowsEditing;
                        imagePicker.navigationBar.tintColor = kButtonColor;
                        [weakself.superViewController presentViewController:imagePicker animated:YES completion:^(){
                            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
                        }];
                    }
                }];
            }
            else {
                if (self.photoSelectCompletion) {
                    self.photoSelectCompletion(@"该设备无法使用摄像头", nil, NO);
                }
            }
        }
            break;

        default:
            break;
    }
}

+ (void)locationIsNotAuthorizedAndShowAlertWithCompletion:(void (^)(BOOL needAlert, NSString *message))completion {
    __weak typeof(self) weakself = self;
    __block NSString *message = nil;
    [AuthorizationTool requestLocationAuthorization:^(LocationAuthorizationStatus status) {
        if (status == LocationAuthorizationStatusNotDetermined) {
            if (completion) {
                completion(YES, @"请进入 通用-隐私-定位服务，检查app的定位权限是否开启");
            }
//            if (completion) {
//                completion(YES, nil);
//            }
            return;
        }
        else if (status == LocationAuthorizationStatusAuthorizedWhenInUse) {
            if (completion) {
                completion(YES, nil);
            }
            message = @"您需要修改定位权限为“始终”，才能持续定位并记录您的行车路径";
        }
        else if (status == LocationAuthorizationStatusAuthorizedAlways) {
            if (completion) {
                completion(NO, nil);
            }
            return;
        }
        else if (status == LocationAuthorizationStatusDenied ||
                 status == LocationAuthorizationStatusRestricted) {
            if (completion) {
                completion(YES, nil);
            }
            message = @"您需要开启定位访问权限";
        }
        else if (status == LocationAuthorizationStatusNotSuppot) {
            if (completion) {
                completion(YES, @"该设备可能不支持定位。也可请进入 通用-隐私-定位服务，检查app的定位权限是否开启");
            }
            return;
        }

        [weakself showAlertControllerWithTitle:@"提示" message:message style:UIAlertControllerStyleAlert actionBlock:nil];
    }];
}

- (void)force_dealloc {
//    _imagePicker.delegate = nil;
//    _imagePicker = nil;
    _photoSelectCompletion = nil;
    _superViewController = nil;
}



#pragma mark - ImagePickerController Delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [HUD show];

    UIImage *image = nil;
    if (_allowsEditing) {
        image = [info objectForKey:UIImagePickerControllerEditedImage];
        if (image == nil) {
            image = [info objectForKey:UIImagePickerControllerOriginalImage];
        }
    }
    else {
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
        if (image == nil) {
            image = [info objectForKey:UIImagePickerControllerEditedImage];
        }
    }

    _image = image;

    if (!image) {
        NSLog(@"image error");
    }

//    __block UIImagePickerController *pickerController = picker;
    __weak typeof(self) weakself = self;
    [picker dismissViewControllerAnimated:YES completion:^{
        [HUD dismiss];

        if ([self.delegate respondsToSelector:@selector(imageDidChooseFinished:)]) {
            [self.delegate imageDidChooseFinished:image];
        }

        if (weakself.photoSelectCompletion != nil) {
            weakself.photoSelectCompletion(nil, [image copy], NO);
        }

//        [weakself force_dealloc];

//        pickerController = nil;
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    if ([self.delegate respondsToSelector:@selector(imageDidChooseCancel)]) {
        [self.delegate imageDidChooseCancel];
    }

    __weak typeof(self) weakself = self;
    [picker dismissViewControllerAnimated:YES completion:^{
        if (weakself.photoSelectCompletion != nil) {
            weakself.photoSelectCompletion(nil, nil, YES);
        }

//        [weakself force_dealloc];
    }];
}




#pragma mark - Private Func

+ (NSString *)bundleID {
    return [[NSBundle mainBundle] bundleIdentifier];
}

+ (BOOL)getAuthorizationBoolStatus:(AuthorizationStatus)status {
    if (status == AuthorizationStatusAuthorized) {
        return YES;
    }
    return NO;
}

+ (void)showAlertControllerWithTitle:(NSString *)title message:(NSString *)message style:(UIAlertControllerStyle)style actionBlock:(void(^ __nullable)(BOOL confirm))actionBlock {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:style];

    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        if (actionBlock) {
            actionBlock(NO);
        }
    }];
    [alertController addAction:cancel];

    // 确认按钮
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (actionBlock) {
            actionBlock(YES);
        }

        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];

        if (@available(iOS 10, *)) {
            if (@available(iOS 10.0, *)) {
                if( [[UIApplication sharedApplication] canOpenURL:url] ) {
                    [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
                }
            }
        } else {
            if( [[UIApplication sharedApplication] canOpenURL:url] ) {
                [[UIApplication sharedApplication] openURL:url];
            }
        }
    }];
    [alertController addAction:confirm];

    __kindof UIViewController *vc = [self currentViewController];
    [vc presentViewController:alertController animated:YES completion:nil];
}


/// 获取当前VC
+ (UIViewController *)currentViewController {
    // Find best view controller
    UIViewController *viewController = [[UIApplication sharedApplication].windows firstObject].rootViewController;
    return [self findBestViewController:viewController];
}

+ (UIViewController *)findBestViewController:(UIViewController *)vc {
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

@end



@implementation DeviceAuthorizationPhone

+ (void)call:(NSString *)phone
  completion:(void (^)(BOOL finished, NSString *errorMessage))completion {
    if (!phone) {
        if (completion) {
            completion(NO, @"电话号码不存在");
        }
        return;
    }

    NSString *phoneUrlStr = [NSString stringWithFormat:@"tel://%@", phone];
    NSURL *url = [NSURL URLWithString:phoneUrlStr];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[UIApplication sharedApplication] openURL:url];
            if (completion) {
                completion(YES, nil);
            }
        });
    }
    else {
        if (completion) {
            completion(NO, @"该设备无法拨打电话");
        }
    }
}

@end

