//
//  HSHttpSessionManager.h
//  HSRongyiBao
//
//  Created by hoomsun on 2017/1/16.
//  Copyright © 2017年 hoomsun. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

@interface HttpSessionManager : AFHTTPSessionManager

+ (instancetype)sharedSessionManager;

@end
