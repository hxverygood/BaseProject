//
//  UITextField+Utils.m
//  HSRongyiBao
//
//  Created by hoomsun on 2017/12/9.
//  Copyright © 2017年 hoomsun. All rights reserved.
//

#import "UITextField+Utils.h"

@implementation UITextField (Utils)

- (void)placeholderFontSize:(CGFloat)fontSize {
    CGFloat size = fontSize > 0.0 ? fontSize : 15.0;
    [self setValue:[UIFont boldSystemFontOfSize:size] forKeyPath:@"_placeholderLabel.font"];
    self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
}

- (BOOL)bankcard_shouldChangeCharactersInRange:(NSRange)range replacementSting:(NSString *)string {
    NSString *inputedStr = self.text;
    //得到输入框的内容
    NSString *inputingStr = [inputedStr stringByReplacingCharactersInRange:range withString:string];
    NSString *trimInputingStr = TRIM([inputingStr copy]);

    // 删除字符
    if ([string isEqualToString:@""]) {
        if (trimInputingStr.length > 0 &&
            trimInputingStr.length % 4 == 0 &&
            inputedStr.length <= 21) {
            self.text = [inputedStr substringToIndex:inputedStr.length - 2];
            return NO;
        }
        return YES;
    }

    //检测是否为纯数字
    //        if ([CheckInput validateNumberWithString:toBeString]) {
    if ([self isPureInt:trimInputingStr]) {
        // 只要30位数字
        if ([inputingStr length] >= 19+4+11) {
            inputingStr = [inputingStr substringToIndex:19+4+11];
            self.text = inputingStr;
            [self resignFirstResponder];
            return NO;
        }

        // 添加空格，每4位之后，4组之后不加空格，格式为xxxx xxxx xxxx xxxx xxxxxxxxxxxxxx
        if ((trimInputingStr.length % 4 == 0) && (trimInputingStr.length < 16)) {
            self.text = [NSString stringWithFormat:@"%@ ", inputingStr];
            return NO;
        }

        if (trimInputingStr.length == 17) {
            self.text = [NSString stringWithFormat:@"%@ ", inputedStr];
        }
    }
    else{
        return NO;
    }

    return YES;
}



#pragma mark - Func

//检测是否为纯数字

- (BOOL)isPureInt:(NSString *)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}

@end
