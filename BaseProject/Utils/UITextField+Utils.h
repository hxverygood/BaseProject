//
//  UITextField+Utils.h
//  HSRongyiBao
//
//  Created by hoomsun on 2017/12/9.
//  Copyright © 2017年 hoomsun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (Utils)

/// 设置placeholder文字尺寸
- (void)placeholderFontSize:(CGFloat)fontSize;
/// 用于textField输入银行卡号时4位为一组，中间加空格
- (BOOL)bankcard_shouldChangeCharactersInRange:(NSRange)range replacementSting:(NSString *)string;

@end
