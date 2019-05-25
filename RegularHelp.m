//
//  RegularHelp.m
//  正则表达式
//
//  Created by GoodWill on 15/11/27.
//  Copyright © 2015年 GoodWill. All rights reserved.
//

#import "RegularHelp.h"

@implementation RegularHelp

+(BOOL)validateEmail:(NSString *)email{
    
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    BOOL isMatch = [emailTest evaluateWithObject:email];
    return isMatch;
}


+(BOOL)validateMobile:(NSString *)mobile{
    
    NSString *MOBILE = @"^(13[0-9]|14[5-9]|15[0-9]|16[1-24-7]|17[0-8]|18[0-9]|19[0-9]|92[0-9]|98[0-9])\\d{8}$";
    NSPredicate *regexTestMobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",MOBILE];
    BOOL isMatch = [regexTestMobile evaluateWithObject:mobile];
    return isMatch;

}


+(BOOL)validateCarNo:(NSString *)carNo{
    
    NSString *carRegex = @"^[\u4e00-\u9fa5]{1}[a-zA-Z]{1}[a-zA-Z_0-9]{4}[a-zA-Z_0-9_\u4e00-\u9fa5]$";
    NSPredicate *carTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",carRegex];
//    NSLog(@"carTest is %@",carTest);
    BOOL isMatch = [carTest evaluateWithObject:carNo];
    return isMatch;
}


+ (BOOL) validateCarType:(NSString *)CarType{
    
    NSString *CarTypeRegex = @"^[\u4E00-\u9FFF]+$";
    NSPredicate *carTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",CarTypeRegex];
    BOOL isMatch = [carTest evaluateWithObject:CarType];
    return isMatch;
}


+ (BOOL) validateUserName:(NSString *)name{
    
    NSString *userNameRegex = @"^[A-Za-z0-9]{4,20}+$";
    NSPredicate *userNamePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",userNameRegex];
    BOOL isMatch = [userNamePredicate evaluateWithObject:name];
    return isMatch;
}


+ (BOOL) validatePassword:(NSString *)passWord{
    
    NSString *passWordRegex = @"^[a-zA-Z0-9]{6,20}+$";
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",passWordRegex];
    BOOL isMatch = [passWordPredicate evaluateWithObject:passWord];
    return isMatch;
}


+ (BOOL) validateNickname:(NSString *)nickname{
    
    NSString *nicknameRegex = @"([\u4e00-\u9fa5]{2,5})(&middot;[\u4e00-\u9fa5]{2,5})*";
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",nicknameRegex];
    BOOL isMatch = [passWordPredicate evaluateWithObject:nickname];
    return isMatch;
}

+ (BOOL)validateIDCardNumber:(NSString *)value {
    value=[value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if([value length]!=18){
        return NO;
    }
    NSString*mmdd=@"(((0[13578]|1[02])(0[1-9]|[12][0-9]|3[01]))|((0[469]|11)(0[1-9]|[12][0-9]|30))|(02(0[1-9]|[1][0-9]|2[0-8])))";
    NSString*leapMmdd=@"0229";
    NSString*year=@"(19|20)[0-9]{2}";
    NSString*leapYear=@"(19|20)(0[48]|[2468][048]|[13579][26])";
    NSString*yearMmdd=[NSString stringWithFormat:@"%@%@",year,mmdd];
    NSString*leapyearMmdd=[NSString stringWithFormat:@"%@%@",leapYear,leapMmdd];
    NSString*yyyyMmdd=[NSString stringWithFormat:@"((%@)|(%@)|(%@))",yearMmdd,leapyearMmdd,@"20000229"];
    NSString*area=@"(1[1-5]|2[1-3]|3[1-7]|4[1-6]|5[0-4]|6[1-5]|82|[7-9]1)[0-9]{4}";
    NSString*regex=[NSString stringWithFormat:@"%@%@%@",area,yyyyMmdd,@"[0-9]{3}[0-9Xx]"];
    
    NSPredicate*regexTest= [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    
    if(![regexTest evaluateWithObject:value]){
        return NO;
    }
    int summary=([value substringWithRange:NSMakeRange(0,1)].intValue+[value substringWithRange:NSMakeRange(10,1)].intValue)*7
    +([value substringWithRange:NSMakeRange(1,1)].intValue+[value substringWithRange:NSMakeRange(11,1)].intValue)*9
    +([value substringWithRange:NSMakeRange(2,1)].intValue+[value substringWithRange:NSMakeRange(12,1)].intValue)*10
    +([value substringWithRange:NSMakeRange(3,1)].intValue+[value substringWithRange:NSMakeRange(13,1)].intValue)*5
    +([value substringWithRange:NSMakeRange(4,1)].intValue+[value substringWithRange:NSMakeRange(14,1)].intValue)*8
    +([value substringWithRange:NSMakeRange(5,1)].intValue+[value substringWithRange:NSMakeRange(15,1)].intValue)*4
    +([value substringWithRange:NSMakeRange(6,1)].intValue+[value substringWithRange:NSMakeRange(16,1)].intValue)*2
    +[value substringWithRange:NSMakeRange(7,1)].intValue*1+[value substringWithRange:NSMakeRange(8,1)].intValue*6
    +[value substringWithRange:NSMakeRange(9,1)].intValue*3;
    NSInteger remainder=summary%11;
    NSString*checkBit=@"";
    NSString*checkString=@"10X98765432";
    checkBit=[checkString substringWithRange:NSMakeRange(remainder,1)];//判断校验位
    return[checkBit isEqualToString:[[value substringWithRange:NSMakeRange(17,1)]uppercaseString]];
    
    
}

+ (BOOL) validateBankCardNumber: (NSString *)bankCardNumber{
    
    BOOL flag;
    if (bankCardNumber.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{15,30})";
    NSPredicate *bankCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    BOOL isMatch = [bankCardPredicate evaluateWithObject:bankCardNumber];
    return isMatch;
}


+ (BOOL) validateBankCardLastNumber: (NSString *)bankCardNumber{
    
    BOOL flag;
    if (bankCardNumber.length != 4) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{4})";
    NSPredicate *bankCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    BOOL isMatch = [bankCardPredicate evaluateWithObject:bankCardNumber];
    return isMatch;
}


+ (BOOL) validateCVNCode: (NSString *)cvnCode{
    
    BOOL flag;
    if (cvnCode.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{3})";
    NSPredicate *cvnCodePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    BOOL isMatch = [cvnCodePredicate evaluateWithObject:cvnCode];
    return isMatch;
}


+ (BOOL) validateMonth: (NSString *)month{
    
    BOOL flag;
    if (month.length != 2) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"(^(0)([0-9])$)|(^(1)([0-2])$)";
    NSPredicate *monthPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    BOOL isMatch = [monthPredicate evaluateWithObject:month];
    return isMatch;
}


+ (BOOL) validateYear: (NSString *)year{
    
    BOOL flag;
    if (year.length != 2) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^([1-3])([0-9])$";
    NSPredicate *yearPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    BOOL isMatch = [yearPredicate evaluateWithObject:year];
    return isMatch;
}


+ (BOOL) validateVerifyCode: (NSString *)verifyCode{
    
    BOOL flag;
    if (verifyCode.length != 6) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{6})";
    NSPredicate *verifyCodePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    BOOL isMatch = [verifyCodePredicate evaluateWithObject:verifyCode];
    return isMatch;
}


+(BOOL)validateURL:(NSString *)url{
    
    NSString *urlRegex = @"^[0-9A-Za-z]{1,50}";
    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegex];
    BOOL isMatch = [urlTest evaluateWithObject:url];
    return isMatch;
}


+(BOOL)validateSpecialSymbol:(NSString *)specialSymbol{
    
    NSString *regex2 = @"[a-zA-Z0-9_]{6,20}";
    //@"^([a-zA-Z]|[a-zA-Z0-9_]|[0-9]){6,18}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    BOOL isMatch = [predicate evaluateWithObject:specialSymbol];
    return isMatch;
}


+(BOOL)validatePositiveNumber:(NSString *)numberStr{
    
    NSString *regex2 = @"^(([1-9]{1}\\d*)|([0]{1}))(\\.(\\d){1,2})?$";
    NSPredicate *positiveNumberTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    BOOL isMatch = [positiveNumberTest evaluateWithObject:numberStr];
    return isMatch;
}


+ (BOOL) validateUserAge:(NSString *)str{
    
    NSString *regex2 =@"^[0-9]{1,2}$";
    NSPredicate *regularexpression = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    BOOL isMatch = [regularexpression evaluateWithObject:str];
    return isMatch;

}


+ (BOOL) validateMoney:(NSString *)str{
    
    NSString *regex2 =@"^([0-9]*[.])?[0-9]+$";
    NSPredicate *regularexpression = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    BOOL isMatch = [regularexpression evaluateWithObject:str];
    return isMatch;
}

+ (BOOL)stringContainsEmoji:(NSString *)string {
  __block BOOL returnValue = NO;
  
  [string enumerateSubstringsInRange:NSMakeRange(0, [string length])
                             options:NSStringEnumerationByComposedCharacterSequences
                          usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                            const unichar hs = [substring characterAtIndex:0];
                            if (0xd800 <= hs && hs <= 0xdbff) {
                              if (substring.length > 1) {
                                const unichar ls = [substring characterAtIndex:1];
                                const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                                if (0x1d000 <= uc && uc <= 0x1f77f) {
                                  returnValue = YES;
                                }
                              }
                            } else if (substring.length > 1) {
                              const unichar ls = [substring characterAtIndex:1];
                              if (ls == 0x20e3) {
                                returnValue = YES;
                              }
                            } else {
                              if (0x2100 <= hs && hs <= 0x27ff) {
                                returnValue = YES;
                              } else if (0x2B05 <= hs && hs <= 0x2b07) {
                                returnValue = YES;
                              } else if (0x2934 <= hs && hs <= 0x2935) {
                                returnValue = YES;
                              } else if (0x3297 <= hs && hs <= 0x3299) {
                                returnValue = YES;
                              } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                                returnValue = YES;
                              }
                            }
                          }];
  
  return returnValue;
}



@end
