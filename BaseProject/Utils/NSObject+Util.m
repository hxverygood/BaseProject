//
//  NSObject+Util.m
//  HSRongyiBao
//
//  Created by 韩啸 on 2018/1/5.
//  Copyright © 2018年 hoomsun. All rights reserved.
//

#import "NSObject+Util.h"
#import <UIKit/UIKit.h>


@implementation NSObject (Util)

/// 打印引用计数
- (void)printRetainCount {
    NSLog(@"\n\n************** %@: retain count = %ld **************\n\n", NSStringFromClass([self class]), CFGetRetainCount((__bridge CFTypeRef)(self)));
}

/// 收起键盘
- (void)hideKeyboard {
    [[[UIApplication sharedApplication].windows firstObject] endEditing:YES];
}

@end
