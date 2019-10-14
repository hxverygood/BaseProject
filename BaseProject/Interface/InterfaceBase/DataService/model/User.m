//
//  User.m
//
//  Created by hans on 2016/12/9.
//  Copyright © 2016年 hans. All rights reserved.
//

#import "User.h"

@implementation User

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"ID" : @"id"};
}

@end
