//
//  WKWebView+Utils.m
//  HSAdvisorAPP
//
//  Created by hoomsun on 2017/4/6.
//  Copyright © 2017年 hoomsun. All rights reserved.
//

#import "WKWebView+Utils.h"

@implementation WKWebView (Utils)

/// 清除web缓存
- (void)deleteWebCache {
    if (@available(iOS 9.0, *)) {
        
//        NSSet *websiteDataTypes
//        
//        = [NSSet setWithArray:@[
//                                
//                                WKWebsiteDataTypeDiskCache,
//                                
//                                //WKWebsiteDataTypeOfflineWebApplicationCache,
//                                
//                                WKWebsiteDataTypeMemoryCache,
//                                
//                                //WKWebsiteDataTypeLocalStorage,
//                                
//                                //WKWebsiteDataTypeCookies,
//                                
//                                //WKWebsiteDataTypeSessionStorage,
//                                
//                                //WKWebsiteDataTypeIndexedDBDatabases,
//                                
//                                //WKWebsiteDataTypeWebSQLDatabases
//                                
//                                ]];
        
        //// All kinds of data
        NSSet *websiteDataTypes = [WKWebsiteDataStore allWebsiteDataTypes];
        
        /// Date from
        NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
        
        /// Execute
        [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
            NSLog(@"WKWebView缓存已删除");
        }];
    } else {
        NSString *bundleId = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
        NSString *libraryPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *cookiesFolderPath = [libraryPath stringByAppendingString:@"/Cookies"];
        NSString *webKitFolderInCaches = [NSString stringWithFormat:@"%@/Caches/%@/WebKit", libraryPath,bundleId];
        NSError *errors;
        [[NSFileManager defaultManager] removeItemAtPath:cookiesFolderPath error:&errors];
        [[NSFileManager defaultManager] removeItemAtPath:webKitFolderInCaches error:&errors];
        NSLog(@"WKWebView缓存已删除");
    }
}

@end
