//
//  DataServiceCompletionModel.m
//  network-test
//
//  Created by hoomsun on 2016/11/30.
//  Copyright © 2016年 hoomsun. All rights reserved.
//

#import "DataServiceCompletionModel.h"
#import "DataServiceResponseModel.h"
#import "DataService.h"

@implementation DataServiceCompletionModel

- (NSMutableArray<NSError *> *)errorArray {
    if (!_errorArray) {
        _errorArray = [[NSMutableArray alloc] init];
    }
    return _errorArray;
}

- (BOOL)success {
    // 如果获取了接口提供的数据模型
    if (!self.apiModel) {
        return NO;
    }
    
    // 如果有错误代码
//    if (self.apiModel.errorCode) {
//        return NO;
//    }
    
    if (self.apiModel.status.integerValue != 0) {
        return NO;
    }
    
    // 如果接口状态OK
    if (self.localErrorCode != kDataServiceStatusOK) {
        return NO;
    }
    
    return YES;
}

@end
