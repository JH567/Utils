//
//  RegularHelp.h
//  正则表达式
//
//  Created by GoodWill on 15/11/27.
//  Copyright © 2015年 GoodWill. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RegularHelp : NSObject

// 正则匹配 邮箱
+ (BOOL) validateEmail:(NSString *)email;
// 正则匹配 手机号
+ (BOOL) validateMobile:(NSString *)mobile;
// 正则匹配 车牌号
+ (BOOL) validateCarNo:(NSString *)carNo;
// 正则匹配 车型
+ (BOOL) validateCarType:(NSString *)CarType;
// 正则匹配 用户名
+ (BOOL) validateUserName:(NSString *)name;
// 正则匹配 密码
+ (BOOL) validatePassword:(NSString *)passWord;
// 正则匹配 昵称
+ (BOOL) validateNickname:(NSString *)nickname;
// 正则匹配 身份证号
+ (BOOL)validateIDCardNumber:(NSString *)value;
// 正则匹配 银行卡
+ (BOOL) validateBankCardNumber:(NSString *)bankCardNumber;
// 正则匹配 银行卡后四位
+ (BOOL) validateBankCardLastNumber:(NSString *)bankCardNumber;
// 正则匹配 CVN
+ (BOOL) validateCVNCode:(NSString *)cvnCode;
// 正则匹配 month
+ (BOOL) validateMonth:(NSString *)month;
// 正则匹配 year
+ (BOOL) validateYear:(NSString *)year;
// 正则匹配 verifyCode
+ (BOOL) validateVerifyCode:(NSString *)verifyCode;
// 正则匹配 URL
+ (BOOL) validateURL:(NSString *)url;
// 正则匹配 是否有特殊符号
+ (BOOL) validateSpecialSymbol:(NSString *)specialSymbol;
// 正则匹配 是否为正数
+ (BOOL) validatePositiveNumber:(NSString *)str;
// 正则匹配 两位数年龄
+ (BOOL) validateUserAge:(NSString *)str;
// 正则匹配 money
+ (BOOL) validateMoney:(NSString *)str;
//是否含有表情
+ (BOOL)stringContainsEmoji:(NSString *)string;






@end
