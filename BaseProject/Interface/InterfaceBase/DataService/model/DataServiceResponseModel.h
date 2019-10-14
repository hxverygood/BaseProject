//
//  DataServiceResponseModel.h
//  network-test
//
//  Created by hoomsun on 2016/11/30.
//  Copyright © 2016年 hoomsun. All rights reserved.
//

#import "BaseYYModel.h"

/// 服务器接口返回对象
@interface DataServiceResponseModel : BaseYYModel

@property (nullable, nonatomic, strong) NSNumber *status; // 错误码
@property (nullable, nonatomic, strong) NSString *msg; // 错误信息描述
//@property (nullable, nonatomic, strong) NSString *sessionId; // 缓存id，每次调用接口都会返回。需要保存到本地，供下次接口访问使用。

// 接口返回json中的data字段。可能返回数组，也可能返回字典
// 以下两个只会使用其一
@property (nonnull, nonatomic, strong) NSArray *dataArray;
@property (nonnull, nonatomic, strong) NSDictionary *dataDictionary;

// 使用以下两个方法，将接口返回的data字段对象转换为实际所用的模型对象或模型对象数组
/// 接口返回结果的model列表
/// @params cls 模型类型
- (nonnull __kindof NSArray *)modelsWithClass:(nonnull Class)cls;

/// 接口返回结果的对象
/// @params cls 模型类型
- (nullable __kindof id)modelWithClass:(nonnull Class)cls;

@end
