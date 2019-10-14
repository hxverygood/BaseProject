//
//  HSConfig.m
//  
//
//  Created by hoomsun on 2016/11/30.
//  Copyright © 2016年 hoomsun. All rights reserved.
//

#import "Config.h"

#if DEBUG
NSString *const kMapApiKey = @"";
#else
NSString *const kMapApiKey = @"";
#endif

/*
  NSNotification Name
 */
NSString *const kNotification_LoginSuccess = @"LoginSuccess";


#if DEBUG

#pragma mark - 本地

#warning fix: test
NSString *const kAPIBaseURL = @"";


/// 使用帮助
NSString *const kWebUrl_help = @"";

#else

NSString *const kAPIBaseURL = @"";


/// 使用帮助
NSString *const kWebUrl_help = @"";

#endif
