//
//  NSMutableAttributedString+MyAttributedString.m
//  BaiLi
//
//  Created by xabaili on 15/10/29.
//  Copyright © 2015年 Hans. All rights reserved.
//

#import "NSMutableAttributedString+Utils.h"


@implementation NSMutableAttributedString (Utils)

/**
 *  对段落进行设置
 *
 *  @param string      要处理的NSString
 *  @param fontSize    文字字号
 *  @param fontColor   文字颜色
 *  @param alignment   段落文字对齐方式
 *  @param lineSpacing 行间距
 *
 *  @return NSMutableAttributedString
 */
+ (instancetype)attributedWithString:(NSString *)string
                            fontSize:(CGFloat)fontSize
                           fontColor:(UIColor *)fontColor
                  paragraphAlignment:(NSTextAlignment)alignment
                         lineSpacing:(CGFloat)lineSpacing {
    return [[NSMutableAttributedString alloc] initWithString:string fontSize:fontSize fontColor:fontColor paragraphAlignment:alignment lineSpacing:lineSpacing];
}

- (instancetype)initWithString:(NSString *)string
                      fontSize:(CGFloat)fontSize
                     fontColor:(UIColor *)fontColor
            paragraphAlignment:(NSTextAlignment)alignment
                   lineSpacing:(CGFloat)lineSpacing {
    NSMutableParagraphStyle *paragraphStyles = [[NSMutableParagraphStyle alloc] init];
    paragraphStyles.alignment = alignment;
    paragraphStyles.firstLineHeadIndent = 0.001f;
    paragraphStyles.lineSpacing = lineSpacing;
    
    UIFont *font = [UIFont systemFontOfSize:fontSize];
    
    NSDictionary *attributes = @{NSParagraphStyleAttributeName: paragraphStyles, NSFontAttributeName:font, NSForegroundColorAttributeName:fontColor};
    
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string attributes:attributes];
    
    return attributedString;
}

/**
*  设置段落间距、首行缩进、字号、颜色等
*
*  @param string      要处理的NSString
*  @param fontSize    文字字号
*  @param fontColor   文字颜色
*  @param alignment   段落文字对齐方式
*  @param lineSpacing 行间距
*  @param headIndent  首行缩进
*
*  @return NSMutableAttributedString
*/
+ (instancetype)attributedWithString:(NSString *)string
                            fontSize:(CGFloat)fontSize
                           fontColor:(UIColor *)fontColor
                  paragraphAlignment:(NSTextAlignment)alignment
                         lineSpacing:(CGFloat)lineSpacing
                 firstLineHeadIndent:(CGFloat)headIndent {
    return [[NSMutableAttributedString alloc] initWithString:string fontSize:fontSize fontColor:fontColor paragraphAlignment:alignment lineSpacing:lineSpacing];
}

- (instancetype)initWithString:(NSString *)string
                      fontSize:(CGFloat)fontSize
                     fontColor:(UIColor *)fontColor
            paragraphAlignment:(NSTextAlignment)alignment
                   lineSpacing:(CGFloat)lineSpacing
           firstLineHeadIndent:(CGFloat)headIndent {
    NSMutableParagraphStyle *paragraphStyles = [[NSMutableParagraphStyle alloc] init];
    paragraphStyles.alignment = alignment;
    paragraphStyles.firstLineHeadIndent = headIndent;
    paragraphStyles.lineSpacing = lineSpacing;
    
    UIFont *font = [UIFont systemFontOfSize:fontSize];
    
    NSDictionary *attributes = @{NSParagraphStyleAttributeName: paragraphStyles, NSFontAttributeName:font, NSForegroundColorAttributeName:fontColor};
    
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string attributes:attributes];
    
    return attributedString;
}


/**
 *  根据需要改变内容的起始和结束位置生成带属性的字符串
 *  此方法更具通用性，推荐使用
 *
 *  @param string     原字符串
 *  @param startIndex 起始位置
 *  @param toIndex    结束位置
 *  @param size       需要改变的字符大小
 *  @param otherSize  不需要改变的字符大小
 *  @param color      需要改变的字符颜色
 *  @param otherColor 不需要改变的字符颜色
 *  @param fontWeight 字体粗细
 *  @param lineHeight 行高
 *  @return NSMutableAttributedString
 */
+ (instancetype)attributedWithString:(NSString *)string
                           fromIndex:(NSInteger)startIndex
                             toIndex:(NSInteger)toIndex
                            withSize:(CGFloat)size
                        andOtherSize:(CGFloat)otherSize
                           withColor:(UIColor *)color
                       andOtherColor:(UIColor *)otherColor
                      withFontWeight:(CGFloat)fontWeight
                      andOtherWeight:(CGFloat)otherFontWeight
                          lineHeight:(CGFloat)lineHeight {
    return [[NSMutableAttributedString alloc] initWithString:string fromIndex:startIndex toIndex:toIndex withSize:size andOtherSize:otherSize withColor:color andOtherColor:otherColor withFontWeight:fontWeight andOtherWeight:otherFontWeight lineHeight:lineHeight];
}


/**
 *  根据需要改变内容的起始和结束位置生成带属性的字符串
 *  此方法更具通用性，推荐使用
 *
 *  @param string     原字符串
 *  @param startIndex 起始位置
 *  @param toIndex    结束位置
 *  @param size       需要改变的字符大小
 *  @param otherSize  不需要改变的字符大小
 *  @param color      需要改变的字符颜色
 *  @param otherColor 不需要改变的字符颜色
 *  @param lineHeight 行高
 *  @return NSMutableAttributedString
 */
+ (instancetype)attributedWithString:(NSString *)string
                           fromIndex:(NSInteger)startIndex
                             toIndex:(NSInteger)toIndex
                            withSize:(CGFloat)size
                        andOtherSize:(CGFloat)otherSize
                           withColor:(UIColor *)color
                       andOtherColor:(UIColor *)otherColor
                          lineHeight:(CGFloat)lineHeight {
    return [[NSMutableAttributedString alloc] initWithString:string fromIndex:startIndex toIndex:toIndex withSize:size andOtherSize:otherSize withColor:color andOtherColor:otherColor withFontWeight:UIFontWeightRegular andOtherWeight:UIFontWeightRegular lineHeight:lineHeight];
}

- (instancetype)initWithString:(NSString *)string
                     fromIndex:(NSInteger)startIndex
                       toIndex:(NSInteger)toIndex
                      withSize:(CGFloat)size
                  andOtherSize:(CGFloat)otherSize
                     withColor:(UIColor *)color
                 andOtherColor:(UIColor *)otherColor
                withFontWeight:(CGFloat)fontWeight
                andOtherWeight:(CGFloat)otherFontWeight
                    lineHeight:(CGFloat)lineHeight
{
    NSInteger length = string.length;
    NSMutableAttributedString *mutStr = [[NSMutableAttributedString alloc] initWithString:string];
    NSRange range;
    if (startIndex != 0) {
        range = NSMakeRange(0, startIndex);
        [mutStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:otherSize weight:otherFontWeight] range:range];
        [mutStr addAttribute:NSForegroundColorAttributeName value:otherColor range:range];
    }
    
    range = NSMakeRange(startIndex, toIndex - startIndex + 1);
    [mutStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:size weight:fontWeight] range:range];
    [mutStr addAttribute:NSForegroundColorAttributeName value:color range:range];
    
    if (toIndex != (length - 1)) {
        range = NSMakeRange(toIndex + 1, length - 1 - toIndex);
        [mutStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:otherSize weight:otherFontWeight] range:range];
        [mutStr addAttribute:NSForegroundColorAttributeName value:otherColor range:range];
    }
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = lineHeight > 0 ? lineHeight : paragraphStyle.minimumLineHeight;
    NSRange paragraphRange = NSMakeRange(0, string.length);
    [mutStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:paragraphRange];
    
    return mutStr;
}

/// 添加删除线
+ (instancetype)attributedDeleteLineWithString:(NSString *)string
                                         color:(UIColor *)color {
    return [[NSMutableAttributedString alloc] initWithDeleteLineWithString:string color:color];
}

- (instancetype)initWithDeleteLineWithString:(NSString *)string
                                       color:(UIColor *)color {
    NSDictionary *attributes = @{NSForegroundColorAttributeName : color,
                                 NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle|NSUnderlinePatternSolid)};
    NSMutableAttributedString *attrStr =
    [[NSMutableAttributedString alloc]initWithString:string
                                          attributes:attributes];
    return attrStr;
}




/// 添加下划线
+ (instancetype)attributedUnderLineWithString:(NSString *)string
                                        color:(UIColor *)color {
    return [[NSMutableAttributedString alloc] attributedUnderLineWithString:string color:color];
}

- (instancetype)attributedUnderLineWithString:(NSString *)string
                                        color:(UIColor *)color {
    NSDictionary *attributes = @{ NSForegroundColorAttributeName : color,
                                  NSUnderlineStyleAttributeName : [NSNumber numberWithInteger:NSUnderlineStyleSingle],
                                  NSUnderlineColorAttributeName : color
                                };
    NSMutableAttributedString *attrStr =
    [[NSMutableAttributedString alloc] initWithString:string
                                           attributes:attributes];
    
    return attrStr;
}


/// 文字中添加图片
+ (instancetype)addPhotoWithString:(NSString *)string
                           atIndex:(NSInteger)index
                         imageName:(NSString *)imageName
                            bounds:(CGRect)bounds {
    return [[NSMutableAttributedString alloc] addPhotoWithString:string atIndex:index imageName:imageName bounds:bounds];
}

- (instancetype)addPhotoWithString:(NSString *)string
                           atIndex:(NSInteger)index
                         imageName:(NSString *)imageName
                            bounds:(CGRect)bounds{
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:string];

    NSTextAttachment *attch = [[NSTextAttachment alloc] init];
    attch.image = [UIImage imageNamed:imageName];
    attch.bounds = bounds;

    NSAttributedString *str = [NSAttributedString attributedStringWithAttachment:attch];
    [attri insertAttributedString:str atIndex:index];

    return attri;
}

@end
