//
//  HSHttpSessionManager.m
//  HSRongyiBao
//
//  Created by hoomsun on 2017/1/16.
//  Copyright © 2017年 hoomsun. All rights reserved.
//

#import "HttpSessionManager.h"

@implementation HttpSessionManager

+ (instancetype)sharedSessionManager {
    static HttpSessionManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[HttpSessionManager alloc] initWithBaseURL:[NSURL URLWithString:kAPIBaseURL]];
        instance.responseSerializer = [AFHTTPResponseSerializer serializer];
        instance.securityPolicy = [instance customSecurityPolicy];
    });
    return instance;
}

/// 自定义 SecurityPolicy
- (AFSecurityPolicy*)customSecurityPolicy {
    // /先导入证书
    NSString *cerPath = nil;//证书的路径
    cerPath = [[NSBundle mainBundle] pathForResource:@"https" ofType:@"pem"];
    NSData *certData = [NSData dataWithContentsOfFile:cerPath];

    // AFSSLPinningModeCertificate 使用证书验证模式
//#if DEV
#if DEBUG
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    // allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO
    // 如果是需要验证自建证书，需要设置为
    securityPolicy.allowInvalidCertificates = YES;

    //validatesDomainName 是否需要验证域名，默认为YES；
    //假如证书的域名与你请求的域名不一致，需把该项设置为NO；如设成NO的话，即服务器使用其他可信任机构颁发的证书，也可以建立连接，这个非常危险，建议打开。
    //置为NO，主要用于这种情况：客户端请求的是子域名，而证书上的是另外一个域名。因为SSL证书上的域名是独立的，假如证书上注册的域名是www.google.com，那么mail.google.com是无法验证通过的；当然，有钱可以注册通配符的域名*.google.com，但这个还是比较贵的。
    //如置为NO，建议自己添加对应域名的校验逻辑。
    securityPolicy.validatesDomainName = NO;
#else
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    // allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO
    // 如果是需要验证自建证书，需要设置为YES
    securityPolicy.allowInvalidCertificates = NO;

    //validatesDomainName 是否需要验证域名，默认为YES；
    //假如证书的域名与你请求的域名不一致，需把该项设置为NO；如设成NO的话，即服务器使用其他可信任机构颁发的证书，也可以建立连接，这个非常危险，建议打开。
    //置为NO，主要用于这种情况：客户端请求的是子域名，而证书上的是另外一个域名。因为SSL证书上的域名是独立的，假如证书上注册的域名是www.google.com，那么mail.google.com是无法验证通过的；当然，有钱可以注册通配符的域名*.google.com，但这个还是比较贵的。
    //如置为NO，建议自己添加对应域名的校验逻辑。
    securityPolicy.validatesDomainName = YES;
#endif

    NSMutableSet *certSet = [NSMutableSet set];
    if (certData != nil) {
        [certSet addObject:certData];
    }
    securityPolicy.pinnedCertificates = certSet;

    return securityPolicy;
}

@end
