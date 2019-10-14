//
//  TextRestrict.m
//

#import "TextRestrict.h"

typedef BOOL(^StringFilter)(NSString * aString);

static inline NSString * kFilterString(NSString * handleString, StringFilter subStringFilter)
{
    NSMutableString * modifyString = handleString.mutableCopy;
    for (NSInteger idx = 0; idx < modifyString.length;) {
        NSString * subString = [modifyString substringWithRange: NSMakeRange(idx, 1)];
        if (subStringFilter(subString)) {
            idx++;
        } else {
            [modifyString deleteCharactersInRange: NSMakeRange(idx, 1)];
        }
    }
//    NSLog(@"%@", modifyString);
    return [modifyString copy];
}

static inline BOOL kMatchStringFormat(NSString * aString, NSString * matchFormat)
{
    NSPredicate * predicate = [NSPredicate predicateWithFormat: @"SELF MATCHES %@", matchFormat];
    return [predicate evaluateWithObject: aString];
}



#pragma mark -

@interface TextRestrict ()

@property (nonatomic, readwrite) RestrictType restrictType;

@end

@implementation TextRestrict

+ (instancetype)textRestrictWithRestrictType:(RestrictType)restrictType
                               maxTextLength:(NSInteger)maxTextLength
{
    TextRestrict * textRestrict;
    switch (restrictType) {
        case RestrictTypeOnlyNumber:
            textRestrict = [[NumberTextRestrict alloc] init];
            break;
            
        case RestrictTypeOnlyDecimal:
            textRestrict = [[DecimalTextRestrict alloc] init];
            break;
            
        case RestrictTypeOnlyCharacter:
            textRestrict = [[CharacterTextRestrict alloc] init];
            break;
            
        case RestrictTypeCharacterCount:
            textRestrict = [[CharacterCountTextRestrict alloc] init];
            break;
            
        case RestrictTypeCharacterAndNumber:
            textRestrict = [[CharacterAndNumberTextRestrict alloc] init];
            break;
            
        case RestrictTypeChineseAndCharAndNumber:
            textRestrict = [[ChineseAndCharAndNumberTextRestrict alloc] init];
            break;
        
        case RestrictTypeIdCard:
            textRestrict = [[IdCardTextRestrict alloc] init];
            break;
            
        case RestrictTypeCustom:
            textRestrict = [[CustomTextRestrict alloc] init];
            break;
            
        default:
            
            break;
    }
    textRestrict.maxLength = (maxTextLength == 0) ? NSUIntegerMax : maxTextLength;
    textRestrict.restrictType = restrictType;
    return textRestrict;
}

- (void)textDidChanged: (UITextField *)textField {

}

@end



#pragma mark - 子类实现

// 数字
@implementation NumberTextRestrict

- (void)textDidChanged:(UITextField *)textField
{
    if (self.maxLength > 0 && textField.text.length > self.maxLength) {
        textField.text = [textField.text substringToIndex:self.maxLength];
        return;
    }
    
    textField.text = kFilterString(textField.text, ^BOOL(NSString *aString) {
        return kMatchStringFormat(aString, @"^\\d$");
    });
}

@end

// 小数
@implementation DecimalTextRestrict

- (void)textDidChanged:(UITextField *)textField
{
    if (self.maxLength > 0 && textField.text.length > self.maxLength) {
        textField.text = [textField.text substringToIndex:self.maxLength];
        return;
    }
    
    textField.text = kFilterString(textField.text, ^BOOL(NSString *aString) {
        return kMatchStringFormat(aString, @"^[0-9.]$");
    });
}

@end
// 只允许非中文输入
@implementation CharacterTextRestrict

- (void)textDidChanged:(UITextField *)textField
{
    if (self.maxLength > 0 && textField.text.length > self.maxLength) {
        textField.text = [textField.text substringToIndex:self.maxLength];
        return;
    }
    
    textField.text = kFilterString(textField.text, ^BOOL(NSString *aString) {
        return kMatchStringFormat(aString, @"^[^[\\u4e00-\\u9fa5]]$");
    });
}

@end

// 只允许中文输入
@implementation ChineseTextRestrict

- (void)textDidChanged:(UITextField *)textField
{
    if (self.maxLength > 0 && textField.text.length > self.maxLength) {
        textField.text = [textField.text substringToIndex:self.maxLength];
        return;
    }
    
    textField.text = kFilterString(textField.text, ^BOOL(NSString *aString) {
        return kMatchStringFormat(aString, @"[^x00-xff]{1,}");
    });
}

@end


/// 判断字符数量
@implementation CharacterCountTextRestrict

- (void)textDidChanged:(UITextField *)textField
{
    if (self.maxLength > 0 && textField.text.length > self.maxLength) {
        textField.text = [textField.text substringToIndex:self.maxLength];
    }
}

@end


/// 判断字母和数字
@implementation CharacterAndNumberTextRestrict

- (void)textDidChanged:(UITextField *)textField
{
    if (self.maxLength > 0 && textField.text.length > self.maxLength) {
        textField.text = [textField.text substringToIndex:self.maxLength];
        return;
    }
    textField.text = kFilterString(textField.text, ^BOOL(NSString *aString) {
        return kMatchStringFormat(aString, @"^[A-Za-z0-9]+$");
    });
}

@end


/// 判断中文、字母和数字
@implementation ChineseAndCharAndNumberTextRestrict

- (void)textDidChanged:(UITextField *)textField
{
    if (self.maxLength > 0 && textField.text.length > self.maxLength) {
        textField.text = [textField.text substringToIndex:self.maxLength];
        return;
    }
    textField.text = kFilterString(textField.text, ^BOOL(NSString *aString) {
        return kMatchStringFormat(aString,@"^[a-zA-Z0-9\\u4e00-\\u9fa5]+");
    });
}

@end


///  判断身份证
@implementation IdCardTextRestrict

- (void)textDidChanged:(UITextField *)textField
{
    if (self.maxLength > 0 && textField.text.length > self.maxLength) {
        textField.text = [textField.text substringToIndex:self.maxLength];
        return;
    }
    textField.text = kFilterString(textField.text, ^BOOL(NSString *aString) {
        BOOL result = kMatchStringFormat(aString, @"^[Xx0-9]+$");
//        NSLog(@"%@", result ? @"YES" : @"NO");
        return result;
    });
}

@end



// 自定义正则
@implementation CustomTextRestrict

- (void)textDidChanged:(UITextField *)textField
{
    if (self.maxLength > 0 && textField.text.length > self.maxLength) {
        textField.text = [textField.text substringToIndex:self.maxLength];
    }
    
    if ([self isBlankString:self.predicateStr]) {
        return;
    }
    
    textField.text = kFilterString(textField.text, ^BOOL(NSString *aString) {
        return kMatchStringFormat(aString, self.predicateStr);
    });
    
//    NSMutableString * modifyString = textField.text.mutableCopy;
//    for (NSInteger idx = 0; idx < modifyString.length;) {
//        NSString * subString = [modifyString substringWithRange: NSMakeRange(idx, 1)];
//        NSPredicate * predicate = [NSPredicate predicateWithFormat: @"SELF MATCHES %@", self.predicateStr];
//        if ([predicate evaluateWithObject: subString]) {
//            idx++;
//        } else {
//            [modifyString deleteCharactersInRange: NSMakeRange(idx, 1)];
//        }
//    }
//    textField.text = modifyString;
}



#pragma mark - Private Func

- (BOOL)isBlankString:(NSString *)string {
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}

@end


