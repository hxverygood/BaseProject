//
//  DeviceAuthorizationHelper.h
//  HSRongyiBao
//
//  Created by 韩啸 on 2018/5/10.
//  Copyright © 2018年 hoomsun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AuthorizationTool.h"

@protocol ImageChooseControlDelegate <NSObject>

@optional
- (void)imageDidChooseFinished:(UIImage *)image;
- (void)imageDidChooseCancel;

@end

@interface DeviceAuthorizationHelper : NSObject

@property (nonatomic, copy) NSString * pickerTitle;
@property (nonatomic, weak) UIViewController * superViewController;
@property (nonatomic, assign) BOOL allowsEditing;

@property (nonatomic, assign) id<ImageChooseControlDelegate> delegate;
@property (nonatomic, strong, readonly) UIImage * image;

+ (void)cameraIsNotAuthorizedAndShowAlertWithCompletion:(void (^)(BOOL needAlert))completion;
+ (void)photoLibraryIsNotAuthorizedAndShowAlertWithCompletion:(void (^)(BOOL needAlert))completion;

//- (void)photoSelection;
- (void)photoSelectionWithCompletion:(void (^)(NSString *errorInfo, UIImage *image, BOOL isCancel))completion;
- (void)photoFromShotWithCompletion:(void (^)(NSString *errorInfo, UIImage *image, BOOL isCancel))completion;

+ (void)locationIsNotAuthorizedAndShowAlertWithCompletion:(void (^)(BOOL needAlert, NSString *message))completion;

- (void)force_dealloc;

@end


@interface DeviceAuthorizationPhone : NSObject

+ (void)call:(NSString *)phone
  completion:(void (^)(BOOL finished, NSString *errorMessage))completion;

@end
