//
//  DataServiceCompletionModel.h
//  network-test
//
//  Created by hoomsun on 2016/11/30.
//  Copyright © 2016年 hoomsun. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DataServiceResponseModel;

@interface DataServiceCompletionModel : NSObject

@property (nonnull, nonatomic, strong) NSString *apiName; // 接口名称
@property (nullable, nonatomic, strong) DataServiceResponseModel *apiModel; // 接口返回的数据模型

/// 接口返回的对象，经过转换后的模型
/// 可以是模型对象，或者模型数组对象
@property (nullable, nonatomic, strong) id transformedModel;

@property (nonatomic) NSInteger localErrorCode; // 本地状态码
@property (nonnull, nonatomic, strong) NSString *localErrorDescription; // 本地错误信息描述，无错误为空字符串
@property (nullable,nonatomic, assign) id data ;
@property (nonnull, nonatomic, strong) NSMutableArray<NSError *> *errorArray; // 存放访问数据过程中的错误信息
@property (nonatomic, assign, readonly) BOOL success; // 接口状态是否成功，只有本地和远程都正确时，才视为成功

@end
