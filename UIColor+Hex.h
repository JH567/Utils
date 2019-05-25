//
//  UIColor+Hex.h
//  HBMedicalCard
//
//  Created by GoodWill on 15/10/25.
//  Copyright © 2015年 GoodWill. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Hex)

+ (UIColor *)colorWithHexString:(NSString *)color;

//从十六进制字符串获取颜色，
//color:支持@“#123456”、 @“0X123456”、 @“123456”三种格式
+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha;



@end
