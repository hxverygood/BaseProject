//
//  TextRestrict.h
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, RestrictType)
{
    RestrictTypeNone = 0,                     /// 不限制输入的内容
    RestrictTypeOnlyNumber = 1,               ///< 只允许输入数字
    RestrictTypeOnlyDecimal,                  ///<  只允许输入实数，包括.
    RestrictTypeOnlyCharacter,                ///<  只允许输入非中文字符
    RestrictTypeOnlyChinese,                  /// 只允许输入中文
    RestrictTypeCharacterCount,               ///< 只判断字符数量，需配合maxLength属性使用
    RestrictTypeCharacterAndNumber,           /// 判断字母和数字
    RestrictTypeChineseAndCharAndNumber,      /// 判断中文、字母和数字
    RestrictTypeIdCard,                       ///  判断身份证
    RestrictTypeNumberOrCharacter,            /// 只允许输入数字和字母
    RestrictTypeCustom,                       ///< 自定义规则
};



#pragma mark -

@interface TextRestrict : NSObject

@property (nonatomic, assign) NSUInteger maxLength;
@property (nonatomic, assign, readonly) RestrictType restrictType;
@property (nonatomic, strong) NSString *predicateStr;

// 工厂
+ (instancetype)textRestrictWithRestrictType:(RestrictType)restrictType
                               maxTextLength:(NSInteger)maxTextLength;
// 子类实现来限制文本内容
- (void)textDidChanged: (UITextField *)textField;

@end



@interface NUmberTextOrCharacter : TextRestrict
@end;

@interface NumberTextRestrict : TextRestrict
@end

@interface DecimalTextRestrict : TextRestrict
@end

@interface CharacterTextRestrict : TextRestrict
@end

@interface ChineseTextRestrict : TextRestrict
@end

@interface CharacterCountTextRestrict : TextRestrict
@end

@interface CharacterAndNumberTextRestrict : TextRestrict
@end

@interface ChineseAndCharAndNumberTextRestrict : TextRestrict
@end

@interface IdCardTextRestrict : TextRestrict
@end

@interface CustomTextRestrict : TextRestrict
@end

