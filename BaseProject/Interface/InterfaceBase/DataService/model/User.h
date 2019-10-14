//
//  User.h
//
//  Created by hans on 2016/12/9.
//  Copyright © 2016年 hans. All rights reserved.
//

#import "BaseYYModel.h"

@interface User : BaseYYModel

/// 用户id
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *token;

@end

