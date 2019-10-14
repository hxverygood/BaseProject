//
//  DataService.m
//  network-test
//
//  Created by hoomsun on 2016/11/30.
//  Copyright © 2016年 hoomsun. All rights reserved.
//

#import "DataService.h"

@implementation DataService

+ (instancetype)sharedDataService {
    static DataService *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[DataService alloc] init];
    });
    return instance;
}

- (AFHTTPSessionManager *)manager {
    if (!_manager) {
        _manager = [AFHTTPSessionManager manager];
        _manager.responseSerializer = self.responseSerializer;
//        _manager.securityPolicy = [self customSecurityPolicy];
    }
    return _manager;
}

- (AFHTTPResponseSerializer *)responseSerializer {
    if (!_responseSerializer) {
        _responseSerializer = [AFHTTPResponseSerializer serializer];
    }
    return _responseSerializer;
}

///// 自定义 SecurityPolicy
//- (AFSecurityPolicy*)customSecurityPolicy {
//    // /先导入证书
//    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"https" ofType:@"pem"];//证书的路径
//    NSData *certData = [NSData dataWithContentsOfFile:cerPath];
//    // AFSSLPinningModeCertificate 使用证书验证模式
//    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
//    // allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO
//    // 如果是需要验证自建证书，需要设置为YES
//    securityPolicy.allowInvalidCertificates = YES;
//
//    //validatesDomainName 是否需要验证域名，默认为YES；
//    //假如证书的域名与你请求的域名不一致，需把该项设置为NO；如设成NO的话，即服务器使用其他可信任机构颁发的证书，也可以建立连接，这个非常危险，建议打开。
//    //置为NO，主要用于这种情况：客户端请求的是子域名，而证书上的是另外一个域名。因为SSL证书上的域名是独立的，假如证书上注册的域名是www.google.com，那么mail.google.com是无法验证通过的；当然，有钱可以注册通配符的域名*.google.com，但这个还是比较贵的。
//    //如置为NO，建议自己添加对应域名的校验逻辑。
//    securityPolicy.validatesDomainName = YES;
//    securityPolicy.pinnedCertificates = [NSSet setWithObject:certData];
//
//    return securityPolicy;
//}

@end
