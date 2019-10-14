//
//  UITextField+Restrict.h
//

#import <UIKit/UIKit.h>
#import "TextRestrict.h"

@class TextRestrict;

@interface UITextField (Restrict)

/// 设置后生效
@property (nonatomic, assign) RestrictType restrictType;
/// 文本最长长度
@property (nonatomic, assign) NSUInteger maxTextLength;
/// 设置自定义正则，配合HSRestrictTypeCustom使用
@property (nonatomic, strong) NSString *predicateStr;
/// 设置自定义的文本限制
@property (nonatomic, strong) TextRestrict *textRestrict;

@end
