//
//  UITextField+HSRestrict.m
//  HSRongyiBao
//
//  Created by hoomsun on 2017/9/27.
//  Copyright © 2017年 hoomsun. All rights reserved.
//

#import "UITextField+Restrict.h"
#import <objc/runtime.h>


static char *RestrictTypeKey = "RestrictTypeKey";
static char *MaxTextLengthKey = "MaxTextLengthKey";
static char *TextRestrictKey = "TextRestrictKey";
static char *PredicateStrKey = "PredicateStrKey";

@implementation UITextField (Restrict)

- (void)setRestrictType: (RestrictType)restrictType
{
    objc_setAssociatedObject(self, RestrictTypeKey, @(restrictType), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.textRestrict = [TextRestrict textRestrictWithRestrictType:restrictType maxTextLength:self.maxTextLength];
}

- (RestrictType)restrictType {
    NSNumber *num = objc_getAssociatedObject(self, RestrictTypeKey);
    return [num integerValue];
}

- (void)setMaxTextLength:(NSUInteger)maxTextLength {
    objc_setAssociatedObject(self, MaxTextLengthKey, @(maxTextLength), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSUInteger)maxTextLength {
    NSNumber *num = objc_getAssociatedObject(self, MaxTextLengthKey);
    return [num integerValue];
}

/// 设置自定义正则，配合HSRestrictTypeCustom使用
- (void)setPredicateStr:(NSString *)predicateStr {
    objc_setAssociatedObject(self, PredicateStrKey, predicateStr, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)predicateStr {
    return objc_getAssociatedObject(self, PredicateStrKey);
}

- (void)setTextRestrict: (TextRestrict *)textRestrict
{
    if (self.textRestrict) {
        [self removeTarget: self.text action: @selector(textDidChanged:) forControlEvents: UIControlEventEditingChanged];
    }
    
    if (textRestrict == RestrictTypeNone) {
        return;
    }
    
    textRestrict.maxLength = self.maxTextLength;
    textRestrict.predicateStr = self.predicateStr;
    [self addTarget: textRestrict action: @selector(textDidChanged:) forControlEvents: UIControlEventEditingChanged];
    objc_setAssociatedObject(self, TextRestrictKey, textRestrict, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (TextRestrict *)textRestrict {
    return objc_getAssociatedObject(self, TextRestrictKey);
}

@end
