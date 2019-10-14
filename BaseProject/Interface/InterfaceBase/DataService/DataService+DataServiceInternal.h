//
//  DataService+DataServiceInternal.h
//  network-test
//
//  Created by hoomsun on 2016/11/30.
//  Copyright © 2016年 hoomsun. All rights reserved.
//

#import "DataService.h"

typedef NS_ENUM(NSInteger, HttpRequestMethod) {
    HttpRequestMethodGet,
    HttpRequestMethodPost
};

@class DataServiceCompletionModel;

/// 提交请求信息
/// 仅供BLWDataService类内部使用
@interface DataService (DataServiceInternal)

/// 接口api前缀
//- (nonnull NSString *)apiBaseURLString;

/** 提交请求信息
    @params server 服务器基地址
    @params mainDirectory  主目录
    @params apiName 接口名称
    @params params 参数 没有参数传空字典
    @params completion 接口回调
 */
- (void)sendWithMethod:(HttpRequestMethod)method
                server:(nonnull NSString *)server
         mainDirectory:(nullable NSString *)mainDirectory
               apiName:(nonnull NSString *)apiName
                params:(nonnull id)params
                  data:(NSArray * __nullable )fileData
            completion:(void (^ __nullable)(DataServiceCompletionModel * __nullable model))completion;

/// 参数、文件一起发送
- (void)sendWithServer:(nonnull NSString *)server
         mainDirectory:(nullable NSString *)mainDirectory
               apiName:(nonnull NSString *)apiName
                params:(nonnull id)params
             fileDatas:(NSArray * __nullable)fileDatas
             fileNames:(NSArray * __nullable)fileNames
            completion:(void (^ __nullable)(DataServiceCompletionModel * __nullable model))completion;

/// 上传图片
- (void)uploadImageWithServer:(nonnull NSString *)server
                mainDirectory:(nullable NSString *)mainDirectory
                      apiName:(nonnull NSString *)apiName
                       params:(nonnull id)params
                    fileDatas:(NSArray * __nullable)fileDatas
                    fileNames:(NSArray * __nullable)fileNames
                   completion:(void (^ __nullable)(DataServiceCompletionModel * __nullable model))completion;



@end
