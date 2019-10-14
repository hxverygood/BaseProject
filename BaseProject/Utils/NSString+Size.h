//
//  NSString+Size.h
//  BaseProject
//
//  Created by apple on 2019/10/14.
//  Copyright © 2019 shawnhans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIkit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Size)

/// 指定text高度，计算text显示需要的宽度
- (CGFloat)textWidthWithFont:(UIFont * _Nullable)font
                      height:(CGFloat)height;

/// 指定text宽度，计算text显示需要的高度
- (CGFloat)textHeightWithFont:(UIFont * _Nullable)font
                        width:(CGFloat)width;

/// 计算text是否需要多行显示
- (BOOL)textNeedMoreLineCountWithFont:(UIFont * _Nullable)font
                                width:(CGFloat)width
                               height:(CGFloat)height;

/// 使用SVProgressHUD时，根据文字多少计算HUD要显示的时间。计算方法来自SVProgressHUD
- (CGFloat)hudShowDuration;

@end

NS_ASSUME_NONNULL_END
