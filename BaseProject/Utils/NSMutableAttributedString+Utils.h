//
//  NSMutableAttributedString+MyAttributedString.h
//  BaiLi
//
//  Created by xabaili on 15/10/29.
//  Copyright © 2015年 Hans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSMutableAttributedString (Utils)

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
                        lineSpacing:(CGFloat)lineSpacing;


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
                 firstLineHeadIndent:(CGFloat)headIndent;


/**
 *  根据需要改变内容的起始和结束位置生成带属性的字符串
 *  此方法更具通用性，推荐使用
 *
 *  @param string           原字符串
 *  @param startIndex       起始位置
 *  @param toIndex          结束位置
 *  @param size             需要改变的字符大小
 *  @param otherSize        不需要改变的字符大小
 *  @param color            需要改变的字符颜色
 *  @param otherColor       不需要改变的字符颜色
 *  @param fontWeight       需要改变的字体粗细
 *  @param otherFontWeight  其它字体粗细
 *  @param lineHeight       行高
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
                          lineHeight:(CGFloat)lineHeight;

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
 *
 *  @return NSMutableAttributedString
 */
+ (instancetype)attributedWithString:(NSString *)string
                           fromIndex:(NSInteger)startIndex
                             toIndex:(NSInteger)toIndex
                            withSize:(CGFloat)size
                        andOtherSize:(CGFloat)otherSize
                           withColor:(UIColor *)color
                       andOtherColor:(UIColor *)otherColor
                          lineHeight:(CGFloat)lineHeight;

/// 添加删除线
+ (instancetype)attributedDeleteLineWithString:(NSString *)string
                                         color:(UIColor *)color;

/// 添加下划线
+ (instancetype)attributedUnderLineWithString:(NSString *)string
                                        color:(UIColor *)color;

/// 文字中添加图片
+ (instancetype)addPhotoWithString:(NSString *)string
                           atIndex:(NSInteger)index
                         imageName:(NSString *)imageName
                            bounds:(CGRect)bounds;

@end
