//
//  DataInterface.h
//
//  Created by Hans on 15/12/8.
//  Copyright © 2015年. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifdef DEBUG
static CGFloat const timeoutInterval = 20.0;
#else
static CGFloat const timeoutInterval = 40.0;
#endif


@interface DataInterface : NSObject

/// GET请求数据接口
+ (void)getWithServer:(NSString *)server
            directory:(NSString *)directory
                 name:(NSString *)apiName
               params:(id)params
           completion:(void (^)(NSInteger errorCode, NSString *errorInfo, id data, NSError *error, NSInteger localErrorStatus, BOOL allSuccess))completion;

/// POST请求数据接口
+ (void)postWithServer:(NSString *)server
             directory:(NSString *)directory
                  name:(NSString *)apiName
                params:(id)params
            completion:(void (^)(NSInteger errorCode, NSString *errorInfo, id data, NSError *error, NSInteger localErrorStatus, BOOL allSuccess))completion;

/// 上传图片数据接口
+ (void)uploadWithServer:(NSString *)server
               directory:(NSString *)directory
                    name:(NSString *)apiName
                  params:(id)params
               fileDatas:(NSArray * )fileDatas
               fileNames:(NSArray * )fileNames
              completion:(void (^)(NSInteger errorCode, NSString *errorInfo, id data, NSError *error, NSInteger localErrorStatus, BOOL allSuccess))completion;

/////上传文件接口
//+ (void)HS_UploadWithName:(NSString *)apiName
//                   params:(NSDictionary *)params
//                     data:(NSArray *)data
//                 mimeType:(NSString *)mimeType
//               complation:(void (^)(NSInteger errorCode, NSString *errorInfo, id data, NSError *error, NSInteger localErrorStatus, BOOL allSuccess))complation;
//
///**
// *  上传单个文件接口
// */
//+ (void)HS_UploadWithName:(NSString *)apiName
//                   params:(NSDictionary *)params
//                 fileData:(NSData *)fileData
//                 fileName:(NSString *)fileName
//                 mimeType:(NSString *)mimeType
//               complation:(void (^)(NSInteger errorCode, NSString *errorInfo, id data, NSError *error, NSInteger localErrorStatus, BOOL allSuccess))complation;


@end
