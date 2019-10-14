//
//  BaseYYModel.m
//  LDDriverSide
//
//  Created by shandiangou on 2018/9/20.
//  Copyright © 2018年 lightingdog. All rights reserved.
//

#import "BaseYYModel.h"
#import <YYKit/YYKit.h>

@implementation BaseYYModel

- (id)copyWithZone:(NSZone *)zone {
    return [self modelCopy];
}

- (NSUInteger)hash {
    return [self modelHash];
}

- (BOOL)isEqual:(id)object {
    return [self modelIsEqual:object];
}

@end
