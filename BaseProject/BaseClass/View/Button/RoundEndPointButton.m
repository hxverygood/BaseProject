//
//  RoundEndPointButton.m
//  LDDriverSide
//
//  Created by shandiangou on 2018/6/22.
//  Copyright © 2018年 lightingdog. All rights reserved.
//

#import "RoundEndPointButton.h"

@implementation RoundEndPointButton

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {

        self.layer.cornerRadius = self.bounds.size.height/2;
        self.layer.masksToBounds = YES;
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];

    self.layer.cornerRadius = self.bounds.size.height/2;
    self.layer.masksToBounds = YES;
}

@end
