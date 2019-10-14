 //
//  DataService+DataServiceInternal.m
//  network-test
//
//  Created by hoomsun on 2016/11/30.
//  Copyright © 2016年 hoomsun. All rights reserved.
//

#import "DataService+DataServiceInternal.h"
#import "DataServiceInternal.h"


@implementation DataService (DataServiceInternal)

#pragma mark - Getter

- (nonnull NSString *)apiBaseURLString {
    return self.baseUrlString;
}



#pragma mark - API

- (void)sendWithMethod:(HttpRequestMethod)method
                server:(nonnull NSString *)server
         mainDirectory:(nullable NSString *)mainDirectory
               apiName:(nonnull NSString *)apiName
                params:(nonnull id)params
                  data:(NSArray * __nullable )fileData
            completion:(void (^ __nullable)(DataServiceCompletionModel * __nullable model))completion {
    
    /// 新方法
    NSString *urlString = nil;
    if (!server || [DataService isBlankString:server]) {
        server = @"";
    }
    urlString = server;

    if (mainDirectory && ![DataService isBlankString:mainDirectory]) {
        if ([DataService isBlankString:urlString]) {
            urlString = mainDirectory;
        }
        else {
            urlString = [NSString stringWithFormat:@"%@/%@", urlString, mainDirectory];
        }
    }


    if (![DataService isBlankString:apiName]) {
        if ([DataService isBlankString:urlString]) {
            urlString = apiName;
        }
        else {
            urlString = [NSString stringWithFormat:@"%@/%@", urlString, apiName];
        }
    }

    self.baseUrlString = urlString;

    
    id newParams;
    NSMutableDictionary *body = nil;

    // 如果参数是“空对象”，则直接给 newParmas 赋值
    if ([params isKindOfClass:[NSNull class]]) {
        newParams = params;
    }
    else {
        body = [[NSMutableDictionary alloc] initWithDictionary:params];
        // 如果需要包含Token
        if ([self excludeTokenForAPIName:apiName] == NO &&
            ![body.allKeys containsObject:@"token"]) {
            body[@"token"] = [LoginInfo savedLoginInfo].token;
        }
        newParams = body;
    }

    NSLog(@"\n%@\n%@", urlString, [newParams isKindOfClass:[NSNull class]] ? @"NSNull params" : newParams);


    HttpSessionManager *manager = [HttpSessionManager sharedSessionManager];

    /// 参数需要放到httpbody中
    if ([self excludeJsonBodyForAPIName:apiName] == NO) {
        NSMutableURLRequest *req = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:urlString parameters:nil error:nil];
        [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [req setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        req.timeoutInterval = timeoutInterval;

        NSError *jsonError = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:newParams options:0 error:&jsonError];

        if (jsonError) {
            NSLog(@"json转data时出错: %@", jsonError.userInfo);
            return;
        }
        [req setHTTPBody:jsonData];
        [[manager dataTaskWithRequest:req uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
            [self apiCompletionWithServer:server mainDirectory:mainDirectory apiName:apiName params:params responseObject:responseObject error:error completion:^(DataServiceCompletionModel * _Nullable model) {
                completion(model);
            }];
        }] resume];
        return;
    }
    else {
        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    }
    
    // 设置网络访问超时时间
    manager.requestSerializer.timeoutInterval = timeoutInterval;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/plain", nil];
    
//    if ([self excludeSignInHttpHeaderForAPIName:apiName] == YES) {
//        NSString *sign = [LoginInfo savedLoginInfo].sign;
//        if (![NSString isBlankString:sign]) {
//            [manager.requestSerializer setValue:sign forHTTPHeaderField:@"sign"];
//        }
//    }

    switch (method) {
        case HttpRequestMethodGet:
            {
                NSURLSessionDataTask *dataTask = [manager GET:urlString parameters:newParams progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    [self apiCompletionWithServer:server mainDirectory:mainDirectory apiName:apiName params:params responseObject:responseObject error:nil completion:^(DataServiceCompletionModel * _Nullable model) {
                        completion(model);
                    }];
                    
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    DataServiceCompletionModel *compModel = [self errorHandleWithApiName:apiName error:error];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completion(compModel);
                    });
                }];
                
                [dataTask resume];
            }
            break;
            
        case HttpRequestMethodPost:
        {
            NSURLSessionDataTask *dataTask = [manager POST:urlString parameters:newParams progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                [self apiCompletionWithServer:server mainDirectory:mainDirectory apiName:apiName params:params responseObject:responseObject error:nil completion:^(DataServiceCompletionModel * _Nullable model) {
                    completion(model);
                }];
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                DataServiceCompletionModel *compModel = [self errorHandleWithApiName:apiName error:error];
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(compModel);
                });
            }];
            
            [dataTask resume];
        }
            break;
            
        default:
            break;
    }
}




#pragma mark - 上传参数和file

/// 上传图片
- (void)uploadImageWithServer:(nonnull NSString *)server
                mainDirectory:(nullable NSString *)mainDirectory
                      apiName:(nonnull NSString *)apiName
                       params:(nonnull id)params
                    fileDatas:(NSArray * __nullable)fileDatas
                    fileNames:(NSArray * __nullable)fileNames
                   completion:(void (^ __nullable)(DataServiceCompletionModel * __nullable model))completion {

    [self sendWithServer:server mainDirectory:mainDirectory apiName:apiName params:params fileDatas:fileDatas fileNames:fileNames completion:completion];
}

/// 参数、文件一起发送
- (void)sendWithServer:(nonnull NSString *)server
         mainDirectory:(nullable NSString *)mainDirectory
               apiName:(nonnull NSString *)apiName
                params:(nonnull id)params
             fileDatas:(NSArray * __nullable)fileDatas
             fileNames:(NSArray * __nullable)fileNames
            completion:(void (^ __nullable)(DataServiceCompletionModel * __nullable model))completion {

    NSString *urlString = nil;
    if (!server || [DataService isBlankString:server]) {
        server = @"";
    }
    urlString = server;

    if (mainDirectory && ![DataService isBlankString:mainDirectory]) {
        if ([DataService isBlankString:urlString]) {
            urlString = mainDirectory;
        }
        else {
            urlString = [NSString stringWithFormat:@"%@/%@", urlString, mainDirectory];
        }
    }


    if (![DataService isBlankString:apiName]) {
        if ([DataService isBlankString:urlString]) {
            urlString = apiName;
        }
        else {
            urlString = [NSString stringWithFormat:@"%@/%@", urlString, apiName];
        }
    }

    self.baseUrlString = urlString;

    NSString *encodedString= [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];

    NSDictionary *newParams;
    NSMutableDictionary *body = [[NSMutableDictionary alloc] initWithDictionary:params];

//    // 如果需要包含Token
//    if ([self excludeTokenForAPIName:apiName] == NO) {
//        body[@"token"] = [LoginInfo savedLoginInfo].token;
//    }
    newParams = body;
    NSLog(@"\n%@\n%@", urlString, newParams);



    HttpSessionManager *manager = [HttpSessionManager sharedSessionManager];

//    /// 参数需要放到httpbody中
//    if ([self excludeJsonBodyForAPIName:apiName] == NO) {
//        NSMutableURLRequest *req = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:urlString parameters:nil error:nil];
//        [req setValue:@"multipart/form-data" forHTTPHeaderField:@"Content-Type"];
//        [req setValue:@"application/json" forHTTPHeaderField:@"Accept"];
//        req.timeoutInterval = timeoutInterval;
//
//        NSError *jsonError = nil;
//        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:newParams options:0 error:&jsonError];
//
//        if (jsonError) {
//            NSLog(@"json转data时出错: %@", jsonError.userInfo);
//            return;
//        }
//        [req setHTTPBody:jsonData];
//
//        [[manager uploadTaskWithRequest:req fromData:fileDatas[0] progress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
//            [self apiCompletionWithIP:server mainDirectory:mainDirectory apiName:apiName params:params responseObject:responseObject error:error completion:^(DataServiceCompletionModel * _Nullable model) {
//                completion(model);
//            }];
//        }] resume];
//
//
////        [[manager dataTaskWithRequest:req uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
////            [self apiCompletionWithIP:server mainDirectory:mainDirectory apiName:apiName params:params responseObject:responseObject error:error completion:^(DataServiceCompletionModel * _Nullable model) {
////                completion(model);
////            }];
////        }] resume];
//        return;
//    }


    // 设置网络访问超时时间
    manager.requestSerializer.timeoutInterval = timeoutInterval;
    
    // 编码格式
    manager.requestSerializer.stringEncoding = NSUTF8StringEncoding;
    [manager.requestSerializer setValue:@"multipart/form-data" forHTTPHeaderField:@"Content-Type"];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/plain", nil];

    NSURLSessionDataTask *dataTask = [manager POST:encodedString parameters:newParams constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (int i = 0; i < [fileDatas count]; i++) {
            NSData *imageData = fileDatas[i];
            NSString *fileName = fileNames[i];
            NSLog(@"上传文件名：%@", fileName);
            if (imageData != nil)
            {
                [formData appendPartWithFileData:imageData name:fileName fileName:fileName mimeType:@"image/jpeg"];
            }
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self apiCompletionWithServer:server mainDirectory:mainDirectory apiName:apiName params:params responseObject:responseObject error:nil completion:^(DataServiceCompletionModel * _Nullable model) {
            completion(model);
        }];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DataServiceCompletionModel *compModel = [self errorHandleWithApiName:apiName error:error];
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(compModel);
        });
    }];

    [dataTask resume];
}




#pragma mark - 接口返回结果处理

- (void)apiCompletionWithServer:(nonnull NSString *)server
                  mainDirectory:(nullable NSString *)mainDirectory
                        apiName:(nonnull NSString *)apiName
                         params:(nonnull id)params
                 responseObject:(id  _Nullable)responseObject
                          error:(NSError * _Nullable)error
                     completion:(void (^ __nullable)(DataServiceCompletionModel * __nullable model))completion {
    NSError *err = nil;
    if (!error) {
        id json = nil;
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            json = (NSDictionary *)responseObject;
        }
        else {
            json = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&err];
        }


        // 组合访问路径
//        NSString *urlString = nil;
//        if (!server || [DataService isBlankString:server]) {
//            server = @"";
//        }
//        urlString = server;
//
//        if (mainDirectory && ![DataService isBlankString:mainDirectory]) {
//            if ([DataService isBlankString:urlString]) {
//                urlString = mainDirectory;
//            }
//            else {
//                urlString = [NSString stringWithFormat:@"%@/%@", urlString, mainDirectory];
//            }
//        }
//
//
//        if (![DataService isBlankString:apiName]) {
//            if ([DataService isBlankString:urlString]) {
//                urlString = apiName;
//            }
//            else {
//                urlString = [NSString stringWithFormat:@"%@/%@", urlString, apiName];
//            }
//        }

        NSLog(@"\n\n>>>>>>>>>>>>>>>>>>>>>>>>>>> api return >>>>>>>>>>>>>>>>>>>\
>>>>>>>>\n\%@/%@/\n%@\n%@\n<<<<<<<<<<<<<<<<<<<<<\
<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<\n\n_", \
              server, mainDirectory, apiName, json);
        if (err) {
            NSLog(@"err：%@", err);
        }
        
        DataServiceCompletionModel *compModel = [DataServiceCompletionModel modelWithDictionary:json];
        compModel.apiName = apiName;
        if (!err) {
            NSError *error = nil;
            DataServiceResponseModel *respModel = [DataServiceResponseModel modelWithDictionary:json];
            if (error) {
                compModel.apiModel = nil;
                compModel.localErrorCode = kDataServiceStatusUnknown;
                compModel.localErrorDescription = error.localizedDescription;
                [compModel.errorArray addObject:err];
            } else {
                compModel.apiModel = respModel;
                compModel.localErrorCode = kDataServiceStatusOK;
                
                NSDictionary *resp = (NSDictionary *)json;
                if ([resp isKindOfClass:[NSDictionary class]]) {
                    id obj = resp[@"result"];
                    if (!obj) {
                        obj = resp;
                    }
                    if ([obj isKindOfClass:[NSArray class]]) {
                        NSArray *arr = (NSArray *)obj;
                        compModel.apiModel.dataArray = arr;
                    } else if ([obj isKindOfClass:[NSDictionary class]]) {
                        NSDictionary *dict = (NSDictionary *)obj;
                        compModel.apiModel.dataDictionary = dict;
                    } else {
                        compModel.data = obj;
                    }
                }
            }
        } else {
            compModel.apiModel = nil;
            compModel.localErrorCode = kDataServiceStatusUnknown;
            compModel.localErrorDescription = err.localizedDescription;
            [compModel.errorArray addObject:err];
        }
        
        completion(compModel);
//        dispatch_async(dispatch_get_main_queue(), ^{
//            completion(compModel);
//        });
    } else {
        DataServiceCompletionModel *compModel = [self errorHandleWithApiName:apiName error:error];
        completion(compModel);
//        dispatch_async(dispatch_get_main_queue(), ^{
//            completion(compModel);
//        });
    }
}



#pragma mark - Func

/// 将请求参数组合起来
- (NSDictionary *)combinePostParamBodyWithAPIName:(NSString *)apiName params:(id)params
{
    if (![params isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    
     NSMutableDictionary *body = [[NSMutableDictionary alloc] initWithDictionary:params];
//    if ([self shouldExcludeUUIDForAPIName:apiName] == NO) {
//       
//        NSString *UUID = [LoginInfo fetchUUID];
//        if ([NSString isBlankString:UUID] == NO) {
//            body[@"UUID"] = UUID;
//        }
//    }
    
//    // 参数拼接
//    if ([self shouldIncludeLoginInfoForAPIName:apiName]) {
//        NSString *UUID = [HSLoginInfo fetchUUID];
////        body[@"idCard"] = user.PAPERID;
//        body[@"UUID"] = UUID;
////        body[@"loginInfo"] = [HSLoginInfo loginInfo];
//    }
    
//    NSLog(@"%@", self.baseUrlString);
//    NSLog(@"%@", apiName);
//    NSLog(@"%@", body);
    
    
    //    NSString *dataValue = [dataValueString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@""]];
    //    dataValue = [dataValue stringByReplacingOccurrencesOfString:@"\\/" withString:@"/"];
    //    NSLog(@"%@",dataValueString);
    //    NSString *body = [NSString stringWithFormat:@"data=%@", dataValue];
    
    return [body copy];
}

- (BOOL)shouldExcludeUUIDForAPIName:(NSString *)apiName {
    NSArray *excludeItems = @[@"registerandlogin/isregister.do", @"version/update.do", @"person/AddressBook", @"message/getNewestApkVersion"];
    if ([excludeItems containsObject:apiName]) {
        return YES;
    }
    return NO;
}

/// 请求参数是否包含loginfo
//- (BOOL)shouldIncludeLoginInfoForAPIName:(NSString *)apiName
//{
//    // 使用loginfo作为参数的接口
//    NSArray *includeItems = @[@"register.do", @"findpwd", @"updatepwd", @"validation.do", @"homepage/getcheck.do", @"homePage/getGradePro", @"Repayment/checkpwd", @"activity/Dopostconfirm",@"activity/getDetail.do", @"msg/getdatamsg", @"PersonMesg/getMsg", @"addapply/addApply.do",@"getDetials",@"getDetailAccount",@"tabLogin.html", @"queryCredit.html"];
//    if ([includeItems containsObject:apiName]) {
//        return YES;
//    }
//    return NO;
//}

/// 请求参数不包含Token
- (BOOL)excludeTokenForAPIName:(NSString *)apiName {
    NSArray *excludeItems = @[@"getDriverIosVersion", @"message/get", @"user/register", @"user/login", @"driver/vehicle_type_app", @"user/forgetPassword", @"validateAndCacheCardInfo.json", @"be_delievered", @"thirdparty/getmuid", @"transport/robbed/list"];

    if ([excludeItems containsObject:apiName]) {
        return YES;
    }
    return NO;
}

/// 请求头不需要包含验签信息“字段sign”
//- (BOOL)excludeSignInHttpHeaderForAPIName:(NSString *)apiName {
//    // sign不作为请求头参数
//    NSArray *includeItems = @[@"registerandlogin/isregister.do", @"product/product.do", @"banner/banner.do", @"notice/getNews.do", @"registerandlogin/login.do",@"person/AddressBook"];
//    if ([includeItems containsObject:apiName]) {
//        return NO;
//    }
//    return YES;
//}

/// 接口不需要传jsonbody
- (BOOL)excludeJsonBodyForAPIName:(NSString *)apiName {
    NSArray *excludeItmes = @[@"vehicle_type/list", @"validateAndCacheCardInfo.json"];
    if ([excludeItmes containsObject:apiName]) {
        return YES;
    }
    return NO;
}
//- (BOOL)needJsonBodyForAPIName:(NSString *)apiName {
//    NSArray *includeItmes = @[];
//    if ([includeItmes containsObject:apiName]) {
//        return YES;
//    }
//    return NO;
//}


/**
 *  错误处理
 */
- (DataServiceCompletionModel *)errorHandleWithApiName:(nonnull NSString *)apiName error:(NSError * _Nonnull)error {
    DataServiceCompletionModel *compModel = [[DataServiceCompletionModel alloc] init];
    compModel.apiName = apiName;
    compModel.apiModel = nil;
    
    // 网络连接超时
    if ((error.code == -1001) ||
        (error.code == -1005) ||
        (error.code == -1009)) {
        compModel.localErrorCode = kDataServiceStatusNetworkError;
    }
    else if (error.code == -1004) {
        compModel.localErrorCode = kDataServiceStatusResponseServerError;
    }
    else if (error.code == -1011) {
        compModel.localErrorCode = kDataServiceStatusRequestFaild;
    }
    else {
        compModel.localErrorCode =  kDataServiceStatusUnknown;
    }
    
    compModel.localErrorDescription = error.localizedDescription;
    [compModel.errorArray addObject:error];
    
    NSLog(@"错误: %@", error.localizedDescription);
    return compModel;
}

/// 判断字符串是否为空
+ (BOOL)isBlankString:(NSString *)string {
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

@end
