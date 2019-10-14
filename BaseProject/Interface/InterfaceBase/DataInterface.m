//
//  DataInterface.m
//
//  Created by Hans on 15/12/8.
//  Copyright © 2015年. All rights reserved.
//

#import "DataInterface.h"
#import <UIKit/UIKit.h>
#import "DataServiceInternal.h"

@interface DataInterface ()

@end

@implementation DataInterface

/// GET请求数据接口
+ (void)getWithServer:(NSString *)server
            directory:(NSString *)directory
                 name:(NSString *)apiName
               params:(id)params
           completion:(void (^)(NSInteger errorCode, NSString *errorInfo, id data, NSError *error, NSInteger localErrorStatus, BOOL allSuccess))completion {
    [[DataService sharedDataService] sendWithMethod:HttpRequestMethodGet server:server mainDirectory:directory apiName:apiName params:params data:nil completion:^(DataServiceCompletionModel * _Nullable model) {
        if (completion) {
            [DataInterface handleResultWith:model completion:completion];
        }
    }];
}

///请求数据接口
+ (void)postWithServer:(NSString *)server
             directory:(NSString *)directory
                  name:(NSString *)apiName
                params:(id)params
            completion:(void (^)(NSInteger errorCode, NSString *errorInfo, id data, NSError *error, NSInteger localErrorStatus, BOOL allSuccess))completion
{
    [[DataService sharedDataService] sendWithMethod:HttpRequestMethodPost server:server mainDirectory:directory apiName:apiName params:params data:nil completion:^(DataServiceCompletionModel * _Nullable model) {
        if (completion) {
            [DataInterface handleResultWith:model completion:completion];
        }
    }];
}


/// 上传图片、文件接口
+ (void)uploadWithServer:(NSString *)server
               directory:(NSString *)directory
                    name:(NSString *)apiName
                  params:(id)params
               fileDatas:(NSArray * )fileDatas
               fileNames:(NSArray * )fileNames
              completion:(void (^)(NSInteger errorCode, NSString *errorInfo, id data, NSError *error, NSInteger localErrorStatus, BOOL allSuccess))completion
{
    [[DataService sharedDataService] sendWithServer:server mainDirectory:directory apiName:apiName params:params fileDatas:fileDatas fileNames:fileNames completion:^(DataServiceCompletionModel * _Nullable model) {
        if (completion) {
            [DataInterface handleResultWith:model completion:completion];
        }
    }];
}


+ (void)handleResultWith:(DataServiceCompletionModel *)model
              completion:(void (^)(NSInteger errorCode, NSString *errorInfo, id data, NSError *error, NSInteger localErrorStatus, BOOL allSuccess))completion {
    id data = nil;
    id errInfo ;
    if (model.apiModel.dataDictionary != nil) {
        data = model.apiModel.dataDictionary;
    } else if (model.apiModel.dataArray != nil) {
        data = model.apiModel.dataArray;
    }else{
        data = model.data;
    }
    errInfo = model.apiModel.msg;
    
    switch (model.localErrorCode) {
        case kDataServiceStatusNetworkError:
            errInfo = @"网络连接异常，请稍候再试";
            break;
        case kDataServiceStatusRequestFaild:
            errInfo = @"网络请求异常，请稍候再试";
            break;
        case kDataServiceStatusRequestParamsBadFormat:
            errInfo = @"请求参数错误，请稍候再试";
            break;
        case kDataServiceStatusResponseBadFormat:
            errInfo = @"获取数据格式错误，请稍候再试";
            break;
        case kDataServiceStatusResponseServerError: {
            NSString *newErrorDesc = [model.localErrorDescription stringByReplacingOccurrencesOfString:@"。" withString:@""];
            errInfo = newErrorDesc;
            break;
        }
        case kDataServiceStatusUnknown:
            errInfo = @"网络异常，请稍候再试";
            break;
            
        default:
            break;
    }
    
    // 如果登录失效，则不显示错误信息
//    if (model.apiModel.errCode.integerValue == 1003) {
//        complation(model.apiModel.errCode.integerValue, nil, data, nil, model.localErrorCode, model.success);
//    } else {
        // 其它情况正常显示错误信息
    if (completion) {
        completion(model.apiModel.status.integerValue, errInfo, data, nil, model.localErrorCode, model.success);
    }
//    }
//
//    //#warning fix: login invalid
//    // 登录过期，删除登录信息，弹出提示框
//    if (model.apiModel.errCode.integerValue == 1003) {
//        [LoginInfo removeSavedLoginInfo];
////                [HSLoginInfo removeRegistrationID];
////                // 删除手势、指纹密码
////                [SCSecureHelper openGesture:NO];
////                [SCSecureHelper touchIDOpen:NO];
//
//        AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//        app.loginInvalid = YES;
//    }
}

@end
