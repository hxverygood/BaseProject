//
//  DataService.h
//  network-test
//
//  Created by hans on 2016/11/30.
//  Copyright © 2016年 hans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

FOUNDATION_EXPORT NSString *const kAPIBaseURL;

/// 本地接口错误信息
typedef NS_ENUM(NSUInteger, DataServiceStatus) {
    kDataServiceStatusOK = 0,
    kDataServiceStatusNetworkError,
    kDataServiceStatusRequestFaild,
    kDataServiceStatusRequestParamsBadFormat,
    kDataServiceStatusResponseBadFormat,
    kDataServiceStatusResponseServerError,
    kDataServiceStatusUnknown
};


@interface DataService : NSObject

@property (nonatomic, strong) NSString *baseUrlString;

+ (instancetype)sharedDataService;

@property (nonatomic, copy) AFHTTPSessionManager * manager;
@property (nonatomic, copy) AFHTTPResponseSerializer * responseSerializer;
@end
