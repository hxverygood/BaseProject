//
//  NSString+HXString.m
//  Baili
//
//  Created by xabaili on 16/3/1.
//  Copyright © 2016年 Baili. All rights reserved.
//

#import "NSString+Handle.h"
#import <sys/utsname.h>
#import <ifaddrs.h>
#import <arpa/inet.h>
#import <net/if.h>


#define IOS_CELLULAR    @"pdp_ip0"
#define IOS_WIFI        @"en0"
#define IOS_VPN         @"utun0"
#define IP_ADDR_IPv4    @"ipv4"
#define IP_ADDR_IPv6    @"ipv6"


@implementation NSString (Blank)

/// 判断字符串是否为空
+ (BOOL)isBlankString:(NSString *)string {
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}

/// 过滤字符串（空格、换行）
+ (NSString *)filterWithString:(NSString *)string {
    NSString *newStr = [string stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    newStr = [newStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    return [newStr copy];
}

/// 获取字符串中指定字符后的子字符串
- (NSString *)substringBehindCharacter:(NSString *)chracter {
    NSRange range = [self rangeOfString:chracter];
    NSString *subStr = [self substringFromIndex:range.location+1];
    return subStr;
}




#pragma mark - 隐藏部分字符

/// 隐藏中文名字
- (NSString * _Nullable)hidePartialName {
    if (!self) {
        return  nil;
    }

    NSString *result;
    NSInteger frontCount = 0;
    NSInteger endCount = 0;

    if (self.length == 0) {
        return nil;
    }
    else if (self.length == 1) {
        return self;
    }
    else if (self.length >= 2) {
        frontCount = 1;
        endCount = 0;
    }

    result = [self hideStringWithFrontPartialCount:frontCount endPartialCount:endCount];

    return result;
}

/// 隐藏身份证部分数字
- (NSString * _Nullable)hidePartialIdCardNumber {
    if (!self) {
        return  nil;
    }
    
    NSString *result;
    result = [self hideStringWithFrontPartialCount:3 endPartialCount:4];
    
    return result;
}

/// 隐藏手机号部分数字
- (NSString * _Nullable)hidePhoneNumber {
    if (!self) {
        return  nil;
    }
    
    NSString *result;
    result = [self hideStringWithFrontPartialCount:3 endPartialCount:4];
    
    return result;
}

/// 隐藏部分Email
- (NSString * _Nullable)hideEmail {
    if (!self) {
        return nil;
    }
    
    NSString *result;
    NSString *subString = [self substringBehindCharacter:@"@"];
    result = [self hideStringWithFrontPartialCount:0 endPartialCount:(subString.length+1)];
    return result;
}

/// 截取银行卡号后4位
- (NSString * _Nullable)bankCardNumberLast4Digits {
    if (!self) {
        return nil;
    }
    
    if ([NSString isBlankString:self]) {
        return nil;
    }
    
    if (self.length < 4) {
        return self;
    }
    
    NSString *result = [self substringFromIndex:self.length - 4];
    return result;
}

- (NSString *)hideStringWithFrontPartialCount:(NSInteger)frontPartialCount
                              endPartialCount:(NSInteger)endPartialCount {
    if ((self == nil ||
         self == NULL ||
         [self isKindOfClass:[NSNull class]] ||
         [[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0)
        && (self.length < (frontPartialCount+endPartialCount))) {
        return nil;
    }
    
    // 截取前1/3部分字符串
    NSRange frontRange = NSMakeRange(0, frontPartialCount);
    NSString *frontStr = [self substringWithRange:frontRange];
    
    // 截取最后的部分
    NSRange endRange = NSMakeRange(self.length-endPartialCount, endPartialCount);
    NSString *endStr = [self substringWithRange:endRange];
    
    
    NSString *replacedStr = @"";
    // 改变中部为星号
    for (int i = 0; i< (self.length-(frontPartialCount+endPartialCount)); i++) {
        replacedStr = [replacedStr stringByAppendingString:@"*"];
    }
    
    NSString *result = [NSString stringWithFormat:@"%@%@%@", frontStr, replacedStr, endStr];
    
    return result;
}



#pragma mark - 其它

- (BOOL)isUrl {
    if (self == nil) {
        return NO;
    }
    
    NSURL *candidateURL = [NSURL URLWithString:self];
    return candidateURL && candidateURL.scheme && candidateURL.host;
}


/// 转换为UTF8
- (NSString *)toUTF8 {
    NSString *convertStr = [self stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    return convertStr;
}



#pragma mark - 获取设备信息

//判断用户手机型号
+ (NSString * _Nonnull)deviceName
{
    // 需要#import "sys/utsname.h"
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString * deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    //iPhone
    if ([deviceString isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([deviceString isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([deviceString isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([deviceString isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone3,2"])    return @"Verizon iPhone 4";
    if ([deviceString isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([deviceString isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone5,2"])    return @"iPhone 5 (GSM+CDMA)";
    if ([deviceString isEqualToString:@"iPhone5,3"])    return @"iPhone 5c (GSM)";
    if ([deviceString isEqualToString:@"iPhone5,4"])    return @"iPhone 5c (GSM+CDMA)";
    if ([deviceString isEqualToString:@"iPhone6,1"])    return @"iPhone 5s (GSM)";
    if ([deviceString isEqualToString:@"iPhone6,2"])    return @"iPhone 5s (GSM+CDMA)";
    if ([deviceString isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    if ([deviceString isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([deviceString isEqualToString:@"iPhone8,1"])    return @"iPhone 6s";
    if ([deviceString isEqualToString:@"iPhone8,2"])    return @"iPhone 6s Plus";
    if ([deviceString isEqualToString:@"iPhone8,4"])    return @"iPhone SE";
    // 日行两款手机型号均为日本独占，可能使用索尼FeliCa支付方案而不是苹果支付
    if ([deviceString isEqualToString:@"iPhone9,1"])    return @"国行、日版、港行iPhone 7";
    if ([deviceString isEqualToString:@"iPhone9,2"])    return @"港行、国行iPhone 7 Plus";
    if ([deviceString isEqualToString:@"iPhone9,3"])    return @"美版、台版iPhone 7";
    if ([deviceString isEqualToString:@"iPhone9,4"])    return @"美版、台版iPhone 7 Plus";
    if ([deviceString isEqualToString:@"iPhone10,1"])   return @"国行(A1863)、日行(A1906)iPhone 8";
    if ([deviceString isEqualToString:@"iPhone10,4"])   return @"美版(Global/A1905)iPhone 8";
    if ([deviceString isEqualToString:@"iPhone10,2"])   return @"国行(A1864)、日行(A1898)iPhone 8 Plus";
    if ([deviceString isEqualToString:@"iPhone10,5"])   return @"美版(Global/A1897)iPhone 8 Plus";
    if ([deviceString isEqualToString:@"iPhone10,3"])   return @"国行(A1865)、日行(A1902)iPhone X";
    if ([deviceString isEqualToString:@"iPhone10,6"])   return @"美版(Global/A1901)iPhone X";
    if ([deviceString isEqualToString:@"iPhone11,2"])   return @"iPhone XS";
    if ([deviceString isEqualToString:@"iPhone11,4"])   return @"iPhone XS Max";
    if ([deviceString isEqualToString:@"iPhone11,6"])   return @"iPhone XS Max";
    if ([deviceString isEqualToString:@"iPhone11,8"])   return @"iPhone XR";
    if ([deviceString isEqualToString:@"iPod1,1"])     return @"iPod Touch 1G";
    if ([deviceString isEqualToString:@"iPod2,1"])    return @"iPod Touch 2G";
    if ([deviceString isEqualToString:@"iPod3,1"]) return @"iPod Touch 3G";
    if ([deviceString isEqualToString:@"iPod4,1"]) return @"iPod Touch 4G";
    if ([deviceString isEqualToString:@"iPod5,1"]) return @"iPod Touch 5G";
    if ([deviceString isEqualToString:@"iPod6,1"]) return @"iPod Touch 6G";
    if ([deviceString isEqualToString:@"iPad1,1"]) return @"iPad 1G";
    if ([deviceString isEqualToString:@"iPad2,1"]) return @"iPad 2";
    if ([deviceString isEqualToString:@"iPad2,2"]) return @"iPad 2";
    if ([deviceString isEqualToString:@"iPad2,3"]) return @"iPad 2";
    if ([deviceString isEqualToString:@"iPad2,4"]) return @"iPad 2";
    if ([deviceString isEqualToString:@"iPad2,5"]) return @"iPad Mini 1G";
    if ([deviceString isEqualToString:@"iPad2,6"]) return @"iPad Mini 1G";
    if ([deviceString isEqualToString:@"iPad2,7"]) return @"iPad Mini 1G";
    if ([deviceString isEqualToString:@"iPad3,1"]) return @"iPad 3";
    if ([deviceString isEqualToString:@"iPad3,2"]) return @"iPad 3";
    if ([deviceString isEqualToString:@"iPad3,3"]) return @"iPad 3";
    if ([deviceString isEqualToString:@"iPad3,4"]) return @"iPad 4";
    if ([deviceString isEqualToString:@"iPad3,5"]) return @"iPad 4";
    if ([deviceString isEqualToString:@"iPad3,6"]) return @"iPad 4";
    if ([deviceString isEqualToString:@"iPad4,1"]) return @"iPad Air";
    if ([deviceString isEqualToString:@"iPad4,2"]) return @"iPad Air";
    if ([deviceString isEqualToString:@"iPad4,3"]) return @"iPad Air";
    if ([deviceString isEqualToString:@"iPad4,4"]) return @"iPad Mini 2G";
    if ([deviceString isEqualToString:@"iPad4,5"]) return @"iPad Mini 2G";
    if ([deviceString isEqualToString:@"iPad4,6"]) return @"iPad Mini 2G";
    if ([deviceString isEqualToString:@"iPad4,7"]) return @"iPad Mini 3";
    if ([deviceString isEqualToString:@"iPad4,8"]) return @"iPad Mini 3";
    if ([deviceString isEqualToString:@"iPad4,9"]) return @"iPad Mini 3";
    if ([deviceString isEqualToString:@"iPad5,1"]) return @"iPad Mini 4";
    if ([deviceString isEqualToString:@"iPad5,2"]) return @"iPad Mini 4";
    if ([deviceString isEqualToString:@"iPad5,3"]) return @"iPad Air 2";
    if ([deviceString isEqualToString:@"iPad5,4"]) return @"iPad Air 2";
    if ([deviceString isEqualToString:@"iPad6,3"]) return @"iPad Pro 9.7";
    if ([deviceString isEqualToString:@"iPad6,4"]) return @"iPad Pro 9.7";
    if ([deviceString isEqualToString:@"iPad6,7"]) return @"iPad Pro 12.9";
    if ([deviceString isEqualToString:@"iPad6,8"]) return @"iPad Pro 12.9";
    if ([deviceString isEqualToString:@"i386"]) return @"iPhone Simulator";
    if ([deviceString isEqualToString:@"x86_64"]) return @"iPhone Simulator";

    if ([NSString isBlankString:deviceString]) {
        deviceString = @"";
    }
    
    return deviceString;
}

// 获取系统版本号
+ (NSString * _Nonnull)systemVersion {
    NSString *systemVersion = [UIDevice currentDevice].systemVersion;
    if ([NSString isBlankString:systemVersion]) {
        systemVersion = @"";
    }
    return systemVersion;
}



#pragma mark - Json String

/// JsonString转NSDictionary
- (NSDictionary *_Nullable)dictionaryWithJsonString {
    if (self == nil) {
        return nil;
    }
    
    NSData *jsonData = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

/// JsonString加转义字符
- (NSString *)addEscapeCharacter {
    NSString *escapeCharacter = [self stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    return escapeCharacter;
}



#pragma mark - 沙盒路径

/// 获取沙盒Documents路径
+ (NSString * _Nullable)sandboxDocumentDirectoryPath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths objectAtIndex:0];
    return docDir;
}




#pragma mark - Private

/// 将字符串转换为数字，如果不是数字，则返回nil
- (NSNumber * _Nullable)convertToNumber {
    if (!self) {
        return nil;
    }
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumber *numberObj = [formatter numberFromString:self];
    return numberObj;
}

@end
