//
//  NSString+Size.m
//  BaseProject
//
//  Created by apple on 2019/10/14.
//  Copyright © 2019 shawnhans. All rights reserved.
//

#import "NSString+Size.h"


@implementation NSString (Size)

/// 指定text高度，计算text显示需要的宽度
- (CGFloat)textWidthWithFont:(UIFont * _Nullable)font
                     height:(CGFloat)height {
    NSDictionary *attrsDictionary = @{@"NSFontAttributeName":font};
    NSAttributedString *text = [[NSAttributedString alloc] initWithString:self attributes:attrsDictionary];
    
    NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin |
    NSStringDrawingUsesFontLeading;
    
    CGRect boundingRect = [text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, height) options:options context:nil];
    return boundingRect.size.width;
}

/// 指定text宽度，计算text显示需要的gao'du
- (CGFloat)textHeightWithFont:(UIFont * _Nullable)font
                        width:(CGFloat)width {
    NSDictionary *attrsDictionary = @{@"NSFontAttributeName":font};
    NSAttributedString *text = [[NSAttributedString alloc] initWithString:self attributes:attrsDictionary];

    NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin;

    CGRect boundingRect = [text boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:options context:nil];
    return boundingRect.size.width;
}

- (BOOL)textNeedMoreLineCountWithFont:(UIFont *)font
                                width:(CGFloat)width
                               height:(CGFloat)height {
    NSDictionary *attrsDictionary = @{@"NSFontAttributeName":font};
    NSAttributedString *text = [[NSAttributedString alloc] initWithString:self attributes:attrsDictionary];
   
    NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin |
    NSStringDrawingUsesFontLeading;
    
    CGRect boundingRect = [text boundingRectWithSize:CGSizeMake(width - 14, CGFLOAT_MAX) options:options context:nil];
    
    if (ceil(boundingRect.size.height) > height) {
        return YES;
    }
    return NO;
}

/// 使用SVProgressHUD时，根据文字多少计算HUD要显示的时间。计算方法来自SVProgressHUD
- (CGFloat)hudShowDuration {
    if (!self) {
        return 0.0;
    }
    CGFloat minimum = MAX((CGFloat)self.length * 0.16 + 0.5, 0.8);
    return MIN(minimum, 5.0);
}

@end
