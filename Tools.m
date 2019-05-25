//
//  Tools.m
//  YRProject
//
//  Created by GoodWill on 2017/1/6.
//  Copyright © 2017年 GoodWill. All rights reserved.
//

#import "Tools.h"
#import <sys/utsname.h>
#import <AVFoundation/AVFoundation.h>

@implementation Tools

#pragma mark ---
#pragma mark --- 获取UILabel大小
+ (CGSize)boundingRectWithLabel:(UILabel *)textLabel FontSize:(CGFloat)fontSize LineSpacing:(CGFloat)lineSpacing MaxSize:(CGSize)maxSize {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    
    paragraphStyle.lineSpacing = lineSpacing;
    
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize],NSParagraphStyleAttributeName:paragraphStyle};
    // 换行
    textLabel.numberOfLines = 0;
    // 行高
    textLabel.attributedText = [[NSMutableAttributedString alloc]initWithString:textLabel.text attributes:attributes];
    // 字符串内容高度
    CGSize labelSize = [textLabel.text boundingRectWithSize:maxSize options:\
                        NSStringDrawingTruncatesLastVisibleLine|
                        NSStringDrawingUsesLineFragmentOrigin |
                        NSStringDrawingUsesFontLeading
                                                 attributes:attributes
                                                    context:nil].size;
    
    labelSize.height = ceil(labelSize.height);
    
    labelSize.width = ceil(labelSize.width);
    
    return labelSize;
}



#pragma mark ---
#pragma mark --- 获取计算文字高度 可以处理计算带行间距的
+ (CGSize)boundingRectWithText:(NSString *)text size:(CGSize)size font:(UIFont*)font lineSpacing:(CGFloat)lineSpacing {
 
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = lineSpacing;
    [attributeString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, text.length)];
    [attributeString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, text.length)];
    NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    CGRect rect = [attributeString boundingRectWithSize:size options:options context:nil];
    
//        DLog(@"size:%@", NSStringFromCGSize(rect.size))
    
    //文本的高度减去字体高度小于等于行间距，判断为当前只有1行
    if ((rect.size.height - font.lineHeight) <= paragraphStyle.lineSpacing) {
        if ([[self class] containChinese:text]) {  //如果包含中文
            rect = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height-paragraphStyle.lineSpacing);
        }
    }
    return rect.size;
}
//判断是否包含中文
+ (BOOL)containChinese:(NSString *)str {
    for(int i=0; i< [str length];i++){
        int a = [str characterAtIndex:i];
        if( a > 0x4e00 && a < 0x9fff){
            return YES;
        }
    }
    return NO;
}


#pragma mark ---
#pragma mark --- 判断字符串是否为空
+ (BOOL)comperStingIsEmpty:(NSString *)str {
    if ([str isKindOfClass:[NSString class]] && [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length > 0) {
        return NO;
    } else {
        return YES;
    }
}

#pragma mark ---
#pragma mark --- 判断数组是否为空
+ (BOOL)comperArrayIsEmpty:(NSArray *)array {
    
    if ([array isKindOfClass:[NSArray class]] && array.count > 0) {
        return NO;
    } else {
        return YES;
    }
}

#pragma mark ---
#pragma mark --- 判断对象是否为空
+ (BOOL)isNullOrNilWithObject:(id)object {
    if (object == nil || [object isEqual:[NSNull null]]) {
        return YES;
    } else if ([object isKindOfClass:[NSString class]]) {
        if ([object stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length > 0) {
            return NO;
        } else {
            return YES;
        }
    } else if ([object isKindOfClass:[NSNumber class]]) {
        if ([object isEqualToNumber:@0]) {
            return YES;
        } else {
            return NO;
        }
    }
    return NO;
}



#pragma mark ---
#pragma mark --- 数组转json字符串
+ (NSString *)arrayToJson:(NSMutableArray *)mutableArray {
    if (mutableArray == nil) {
        return @"";
    } else {
        NSError *parseError = nil;
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:mutableArray options:NSJSONWritingPrettyPrinted error:&parseError];
        
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
}

#pragma mark ---
#pragma mark --- 字典/数组转JSON字符串
+ (NSString *)dictionaryToJson:(NSDictionary *)dic {
    
    if (dic == nil) {
        return @"";
    } else {
        NSError *parseError = nil;
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:0 error:&parseError];
        
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
}

+ (NSString *)toJSONData:(id)theData{
    
    if (theData == nil) {
        return @"";
    } else {
        NSError *error = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:theData
                                                           options:NSJSONWritingPrettyPrinted
                                                             error:&error];
        
        if ([jsonData length] > 0 && error == nil){
            return [[NSString alloc] initWithData:jsonData
                                         encoding:NSUTF8StringEncoding];
        }else{
            return nil;
        }
    }
}

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
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



#pragma mark ---
#pragma mark --- 切圆角
+ (UIView *)clipCornerWithView:(UIView *)originView
                    andTopLeft:(BOOL)topLeft
                   andTopRight:(BOOL)topRight
                 andBottomLeft:(BOOL)bottomLeft
                andBottomRight:(BOOL)bottomRight
                   cornerRadii:(CGSize)cornerSize {
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:originView.bounds
                                                   byRoundingCorners:
                              (topLeft==YES ? UIRectCornerTopLeft : 0) |
                              (topRight==YES ? UIRectCornerTopRight : 0) |
                              (bottomLeft==YES ? UIRectCornerBottomLeft : 0) |
                              (bottomRight==YES ? UIRectCornerBottomRight : 0)
                                                         cornerRadii:cornerSize];
    // 创建遮罩层
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = originView.bounds;
    maskLayer.path = maskPath.CGPath;   // 轨迹
    originView.layer.mask = maskLayer;
    
    return originView;
}


#pragma mark - 是否开启通知
+ (BOOL)isMessageNotificationServiceOpen {
    if (SYSTEM_VERSION_GREATER_THAN(@"8.0")) {
        return [[UIApplication sharedApplication] isRegisteredForRemoteNotifications];
    } else {
        return UIRemoteNotificationTypeNone != [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
    }
}

#pragma mark ---
#pragma mark --- 水印
+ (CALayer *)AddWaterMarkWithFrame:(CGRect)frame
                    superView:(UIView *)superView
                         cols:(NSInteger)cols
                        title:(NSString *)title {
  // cols = 4; // 列数
  CALayer *layer = [CALayer layer];
  layer.frame = frame;
  [superView.layer addSublayer:layer];
  
  CGFloat titleW = [title boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.f]} context:nil].size.width;
  
  NSInteger itemH = 25;
  NSInteger itemW = titleW + 10;
  
  NSInteger marginY = 2 * itemH;
  NSInteger marginX = (CGRectGetWidth(frame) - cols * itemW) / (cols - 1);
  
  for (int i = 0; i < 50; i ++) {
    
    NSInteger row = i / cols;
    NSInteger col = i % cols;
    
    //根据行号和列号来确定 子控件的坐标
    CGFloat itemX = col * marginX + col * itemW;
    CGFloat itemY = itemH * row + row * marginY;
    
    CATextLayer *textLayer = [CATextLayer layer];
    textLayer.contentsScale = [UIScreen mainScreen].scale;
    textLayer.string = title;//@"LYJ 水印 123";
    textLayer.fontSize = 12.;
    textLayer.foregroundColor = UIColorFromRGBA(0, 0, 0, 0.12).CGColor;
    textLayer.frame = CGRectMake(itemX, itemY, itemW, itemH);
    textLayer.zPosition = -1.;
    [layer addSublayer:textLayer];
    textLayer.transform = CATransform3DMakeRotation(-M_PI/9, 0, 0, 1);
  }
  return layer;
}

#pragma mark ---
#pragma mark --- 水印文字
+ (UIImage *)imageAddText:(NSString *)logoText imageRect:(CGRect)rect withAngle:(CGFloat)angle {
    // 1、 绘制一张透明图片
    CGRect rectImg=CGRectMake(0.0f, 0.0f, rect.size.width, rect.size.width);
    UIGraphicsBeginImageContext(rectImg.size);
    CGContextRef contextImg = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(contextImg, [[UIColor clearColor] CGColor]);
    CGContextFillRect(contextImg, rectImg);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // 2、 在图片上绘制文字
    NSString *mark = logoText;
    int w = rectImg.size.width ;
    int h = rectImg.size.height;
    UIGraphicsBeginImageContext(CGSizeMake(w, h));
    [[UIColor clearColor] set];
    [img drawInRect:rectImg];
    
    NSDictionary *attrDic = @{NSFontAttributeName:[UIFont fontWithName:@"Verdana-Bold" size:32],
                              NSForegroundColorAttributeName:[UIColor clearColor],
                              NSStrokeWidthAttributeName:@1.5,
                              NSStrokeColorAttributeName:[UIColor colorWithRed:191/255.0 green:200/255.0 blue:215/255.0 alpha:1.0]};

    //      总列数
    int totalColumns = 5;
    
    //       每一格的尺寸
    CGFloat cellW = 150;
    CGFloat cellH = 80;
    
    //    间隙
    CGFloat margin =(w - totalColumns * (cellW - 10)) / (totalColumns + 1);
    CGFloat marginH =(h - totalColumns * cellH) / (totalColumns + 1);
    
    for(int index = 0; index< 4; index++) {
        
        // 计算行号  和   列号
        int row = index / totalColumns;
        int col = index % totalColumns;
        //根据行号和列号来确定 子控件的坐标
        
        CGFloat cellX = margin + col * (cellW + margin);
        //        CGFloat cellY = row * (cellH + margin);
        
        
        CGFloat cellY = 0;
        if (index == 0 || index == 2) {
            cellY = (marginH - 20) + row * (h - cellH - marginH);
        } else {
            cellY = (marginH + 10) + row * (h - cellH - marginH);
        }
        
        //位置显示
        [mark drawInRect:CGRectMake(cellX, cellY, cellW, cellH) withAttributes:attrDic];
    }
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
    // 3、 旋转角度并重新绘制图片
    CGRect imageRect = CGRectMake(0, 0, newImage.size.width, newImage.size.height);
    CGFloat radian = -15 / 180 * M_PI_2;
    CGAffineTransform rotatedTransform = CGAffineTransformMakeRotation(radian);
    CGRect rotatedRect = CGRectApplyAffineTransform(imageRect, rotatedTransform);
    rotatedRect.origin.x = 0;
    rotatedRect.origin.y = 0;
    
    
    UIGraphicsBeginImageContext(rotatedRect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
//    //做CTM变换
//    CGContextTranslateCTM(context, rotatedRect.size.width / 2, rotatedRect.size.height / 2);
//    CGContextScaleCTM(context, 1.0, -1.0);
//    CGContextRotateCTM(context, radian);
//    CGContextTranslateCTM(context, -newImage.size.width / 2, -newImage.size.height / 2);
    //绘制图片
    CGContextDrawImage(context, CGRectMake(0, 0, imageRect.size.width, imageRect.size.height), newImage.CGImage);
    
    UIImage *rotatedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return rotatedImage;

}



#pragma mark ---
#pragma mark --- 图片上加水印文字
+ (UIImage *)getWaterMarkImage:(UIImage *)originalImage andTitle:(NSString *)title andMarkFont:(UIFont *)markFont andMarkColor:(UIColor *)markColor {
    
    CGFloat HORIZONTAL_SPACE = 40; //水平间距
    CGFloat VERTICAL_SPACE = 80; //竖直间距
    CGFloat CG_TRANSFORM_ROTATION = ((-15) / 180.0 * M_PI);
    
    UIFont *font = markFont;
    if (font == nil) {
        font = [UIFont systemFontOfSize:23];
    }
    UIColor *color = markColor;
    if (color == nil) {
        color = [UIColor redColor];//[self mostColor:originalImage];
    }
    //原始image的宽高
    CGFloat viewWidth = originalImage.size.width;
    CGFloat viewHeight = originalImage.size.height;
    //为了防止图片失真，绘制区域宽高和原始图片宽高一样
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(viewWidth, viewHeight),NO,[UIScreen mainScreen].scale);
    //先将原始image绘制上
    [originalImage drawInRect:CGRectMake(0, 0, viewWidth, viewHeight)];
    //sqrtLength：原始image的对角线length。在水印旋转矩阵中只要矩阵的宽高是原始image的对角线长度，无论旋转多少度都不会有空白。
    CGFloat sqrtLength = sqrt(viewWidth*viewWidth + viewHeight*viewHeight);
    //文字的属性
    NSDictionary *attr = @{
                           //设置字体大小
                           NSFontAttributeName:font,
                           //设置文字颜色
                           NSForegroundColorAttributeName:color,
                           NSBackgroundColorAttributeName:[UIColor clearColor],
                           NSStrokeWidthAttributeName:@1.5,
                           NSStrokeColorAttributeName:color
                           };
    NSString *mark = title;
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:mark attributes:attr];
    //绘制文字的宽高
    CGFloat strWidth = attrStr.size.width;
    CGFloat strHeight = attrStr.size.height;
    
    //开始旋转上下文矩阵，绘制水印文字
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //将绘制原点（0，0）调整到源image的中心
    CGContextConcatCTM(context, CGAffineTransformMakeTranslation(viewWidth/2, viewHeight/2));
    //以绘制原点为中心旋转
    CGContextConcatCTM(context, CGAffineTransformMakeRotation(CG_TRANSFORM_ROTATION));
    //将绘制原点恢复初始值，保证当前context中心和源image的中心处在一个点(当前context已经旋转，所以绘制出的任何layer都是倾斜的)
    CGContextConcatCTM(context, CGAffineTransformMakeTranslation(-viewWidth/2, -viewHeight/2));
    
    //计算需要绘制的列数和行数
    int horCount = sqrtLength / (strWidth + HORIZONTAL_SPACE) + 1;
    int verCount = sqrtLength / (strHeight + VERTICAL_SPACE) + 1;
    
    //此处计算出需要绘制水印文字的起始点，由于水印区域要大于图片区域所以起点在原有基础上移
    CGFloat orignX = -(sqrtLength-viewWidth)/2;
    CGFloat orignY = -(sqrtLength-viewHeight)/2;
    
    //在每列绘制时X坐标叠加
    CGFloat tempOrignX = orignX;
    //在每行绘制时Y坐标叠加
    CGFloat tempOrignY = orignY;
    for (int i = 0; i < horCount * verCount; i++) {
        [mark drawInRect:CGRectMake(tempOrignX, tempOrignY, strWidth, strHeight) withAttributes:attr];
        if (i % horCount == 0 && i != 0) {
            tempOrignX = orignX;
            tempOrignY += (strHeight + VERTICAL_SPACE);
        }else{
            tempOrignX += (strWidth + HORIZONTAL_SPACE);
        }
    }
    //根据上下文制作成图片
    UIImage *finalImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
//    CGContextRestoreGState(context);
    return finalImg;
}



#pragma mark ---
#pragma mark --- 颜色转化成图片(size)
+ (UIImage *)imageWithColor:(UIColor *)color height:(CGFloat)height {
  //创建1像素区域并开始图片绘图
  CGRect rect = CGRectMake(0, 0, 1, height);
  UIGraphicsBeginImageContext(rect.size);
  //创建画板并填充颜色和区域
  CGContextRef context = UIGraphicsGetCurrentContext();
  CGContextSetFillColorWithColor(context, [color CGColor]);
  CGContextFillRect(context, rect);
  //从画板上获取图片并关闭图片绘图
  UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  return image;
}


#pragma mark ---
#pragma mark --- 数字用","隔开
+ (NSString *)hanleNums:(NSString *)num {
    int count = 0;
    long long int a = num.longLongValue;
    while (a != 0)
    {
        count++;
        a /= 10;
    }
    NSMutableString *string = [NSMutableString stringWithString:num];
    NSMutableString *newstring = [NSMutableString string];
    while (count > 3) {
        count -= 3;
        NSRange rang = NSMakeRange(string.length - 3, 3);
        NSString *str = [string substringWithRange:rang];
        [newstring insertString:str atIndex:0];
        [newstring insertString:@"," atIndex:0];
        [string deleteCharactersInRange:rang];
    }
    [newstring insertString:string atIndex:0];
    return newstring;
}


#pragma mark ---
#pragma mark --- 判断麦克风权限
+ (NSInteger)checkAVMediaTypeAudio {
    // 判断麦克风权限
    NSInteger flag = 0;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    switch (authStatus) {
        case AVAuthorizationStatusNotDetermined:
            //没有询问是否开启麦克风
            flag = 1;
            break;
        case AVAuthorizationStatusRestricted:
            //未授权，家长限制
            flag = 0;
            break;
        case AVAuthorizationStatusDenied:
            //玩家未授权
            flag = 0;
            break;
        case AVAuthorizationStatusAuthorized:
            //玩家授权
            flag = 2;
            break;
        default:
            break;
    }
    return flag;
}

#pragma mark ---
#pragma mark --- 绘制三角形
+ (CAShapeLayer *)createIndicatorWithColor:(UIColor *)color andPosition:(CGPoint)point {
  CAShapeLayer *layer = [CAShapeLayer new];
  
  UIBezierPath *path = [UIBezierPath new];
  [path moveToPoint:CGPointMake(5, 0)];
  [path addLineToPoint:CGPointMake(5, 5)];
  [path addLineToPoint:CGPointMake(0, 5)];
  [path closePath];
  
  layer.path = path.CGPath;
  layer.lineWidth = 0.8;
  layer.fillColor = color.CGColor;
  
  CGPathRef bound = CGPathCreateCopyByStrokingPath(layer.path, nil, layer.lineWidth, kCGLineCapButt, kCGLineJoinMiter, layer.miterLimit);
  layer.bounds = CGPathGetBoundingBox(bound);
  CGPathRelease(bound);
  layer.position = point;
  
  return layer;
}

#pragma mark ---
#pragma mark --- 获取手机型号
+ (NSString *)getCurrentDeviceModel {
  //#import <sys/utsname.h>//要导入头文件
  struct utsname systemInfo;
  uname(&systemInfo);
  
  NSString *deviceModel = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
  
  if ([deviceModel isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
  if ([deviceModel isEqualToString:@"iPhone3,2"])    return @"iPhone 4";
  if ([deviceModel isEqualToString:@"iPhone3,3"])    return @"iPhone 4";
  if ([deviceModel isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
  if ([deviceModel isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
  if ([deviceModel isEqualToString:@"iPhone5,2"])    return @"iPhone 5 (GSM+CDMA)";
  if ([deviceModel isEqualToString:@"iPhone5,3"])    return @"iPhone 5c (GSM)";
  if ([deviceModel isEqualToString:@"iPhone5,4"])    return @"iPhone 5c (GSM+CDMA)";
  if ([deviceModel isEqualToString:@"iPhone6,1"])    return @"iPhone 5s (GSM)";
  if ([deviceModel isEqualToString:@"iPhone6,2"])    return @"iPhone 5s (GSM+CDMA)";
  if ([deviceModel isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
  if ([deviceModel isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
  if ([deviceModel isEqualToString:@"iPhone8,1"])    return @"iPhone 6s";
  if ([deviceModel isEqualToString:@"iPhone8,2"])    return @"iPhone 6s Plus";
  if ([deviceModel isEqualToString:@"iPhone8,4"])    return @"iPhone SE";
  // 日行两款手机型号均为日本独占，可能使用索尼FeliCa支付方案而不是苹果支付
  if ([deviceModel isEqualToString:@"iPhone9,1"])    return @"iPhone 7";
  if ([deviceModel isEqualToString:@"iPhone9,2"])    return @"iPhone 7 Plus";
  if ([deviceModel isEqualToString:@"iPhone9,3"])    return @"iPhone 7";
  if ([deviceModel isEqualToString:@"iPhone9,4"])    return @"iPhone 7 Plus";
  if ([deviceModel isEqualToString:@"iPhone10,1"])   return @"iPhone_8";
  if ([deviceModel isEqualToString:@"iPhone10,4"])   return @"iPhone_8";
  if ([deviceModel isEqualToString:@"iPhone10,2"])   return @"iPhone_8_Plus";
  if ([deviceModel isEqualToString:@"iPhone10,5"])   return @"iPhone_8_Plus";
  if ([deviceModel isEqualToString:@"iPhone10,3"])   return @"iPhone X";
  if ([deviceModel isEqualToString:@"iPhone10,6"])   return @"iPhone X";
  if ([deviceModel isEqualToString:@"iPhone11,8"])   return @"iPhone XR";
  if ([deviceModel isEqualToString:@"iPhone11,2"])   return @"iPhone XS";
  if ([deviceModel isEqualToString:@"iPhone11,6"])   return @"iPhone XS Max";
  if ([deviceModel isEqualToString:@"iPhone11,4"])   return @"iPhone XS Max";
  if ([deviceModel isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
  if ([deviceModel isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
  if ([deviceModel isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
  if ([deviceModel isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
  if ([deviceModel isEqualToString:@"iPod5,1"])      return @"iPod Touch (5 Gen)";
  if ([deviceModel isEqualToString:@"iPad1,1"])      return @"iPad";
  if ([deviceModel isEqualToString:@"iPad1,2"])      return @"iPad 3G";
  if ([deviceModel isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
  if ([deviceModel isEqualToString:@"iPad2,2"])      return @"iPad 2";
  if ([deviceModel isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
  if ([deviceModel isEqualToString:@"iPad2,4"])      return @"iPad 2";
  if ([deviceModel isEqualToString:@"iPad2,5"])      return @"iPad Mini (WiFi)";
  if ([deviceModel isEqualToString:@"iPad2,6"])      return @"iPad Mini";
  if ([deviceModel isEqualToString:@"iPad2,7"])      return @"iPad Mini (GSM+CDMA)";
  if ([deviceModel isEqualToString:@"iPad3,1"])      return @"iPad 3 (WiFi)";
  if ([deviceModel isEqualToString:@"iPad3,2"])      return @"iPad 3 (GSM+CDMA)";
  if ([deviceModel isEqualToString:@"iPad3,3"])      return @"iPad 3";
  if ([deviceModel isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";
  if ([deviceModel isEqualToString:@"iPad3,5"])      return @"iPad 4";
  if ([deviceModel isEqualToString:@"iPad3,6"])      return @"iPad 4 (GSM+CDMA)";
  if ([deviceModel isEqualToString:@"iPad4,1"])      return @"iPad Air (WiFi)";
  if ([deviceModel isEqualToString:@"iPad4,2"])      return @"iPad Air (Cellular)";
  if ([deviceModel isEqualToString:@"iPad4,4"])      return @"iPad Mini 2 (WiFi)";
  if ([deviceModel isEqualToString:@"iPad4,5"])      return @"iPad Mini 2 (Cellular)";
  if ([deviceModel isEqualToString:@"iPad4,6"])      return @"iPad Mini 2";
  if ([deviceModel isEqualToString:@"iPad4,7"])      return @"iPad Mini 3";
  if ([deviceModel isEqualToString:@"iPad4,8"])      return @"iPad Mini 3";
  if ([deviceModel isEqualToString:@"iPad4,9"])      return @"iPad Mini 3";
  if ([deviceModel isEqualToString:@"iPad5,1"])      return @"iPad Mini 4 (WiFi)";
  if ([deviceModel isEqualToString:@"iPad5,2"])      return @"iPad Mini 4 (LTE)";
  if ([deviceModel isEqualToString:@"iPad5,3"])      return @"iPad Air 2";
  if ([deviceModel isEqualToString:@"iPad5,4"])      return @"iPad Air 2";
  if ([deviceModel isEqualToString:@"iPad6,3"])      return @"iPad Pro 9.7";
  if ([deviceModel isEqualToString:@"iPad6,4"])      return @"iPad Pro 9.7";
  if ([deviceModel isEqualToString:@"iPad6,7"])      return @"iPad Pro 12.9";
  if ([deviceModel isEqualToString:@"iPad6,8"])      return @"iPad Pro 12.9";
  
  if ([deviceModel isEqualToString:@"AppleTV2,1"])      return @"Apple TV 2";
  if ([deviceModel isEqualToString:@"AppleTV3,1"])      return @"Apple TV 3";
  if ([deviceModel isEqualToString:@"AppleTV3,2"])      return @"Apple TV 3";
  if ([deviceModel isEqualToString:@"AppleTV5,3"])      return @"Apple TV 4";
  
  if ([deviceModel isEqualToString:@"i386"])         return @"Simulator";
  if ([deviceModel isEqualToString:@"x86_64"])       return @"Simulator";
  return deviceModel;
}

#pragma mark ---
#pragma mark --- 比较 应用的 App 版本号
+ (BOOL)compareCurrentVersion:(NSString *)currentVersion newVersion:(NSString *)newVersion {
  // 获取各个版本号对应版本信息
  NSMutableArray *versionStep1 = [NSMutableArray arrayWithArray:[currentVersion componentsSeparatedByString:@"."]];
  NSMutableArray *versionStep2 = [NSMutableArray arrayWithArray:[newVersion componentsSeparatedByString:@"."]];
  
  // 补全版本信息为相同位数
  while (versionStep1.count < versionStep2.count) {
    [versionStep1 addObject:@"0"];
  }
  while (versionStep2.count < versionStep1.count) {
    [versionStep2 addObject:@"0"];
  }
  
  // 遍历每一个版本信息中的位数
  // 记录比较结果值
  BOOL compareResutl = NO;
  for(NSUInteger i = 0; i < versionStep1.count; i++){
    NSInteger versionNumber1 = [versionStep1[i] integerValue];
    NSInteger versionNumber2 = [versionStep2[i] integerValue];
    if (versionNumber1 < versionNumber2) {
      compareResutl = YES;
      break;
    }
    else if (versionNumber2 < versionNumber1){
      compareResutl = NO;
      break;
    }
    else{
      compareResutl = NO;
    }
  }

  /*
   return compareResutl ? newVersion : currentVersion;
   YES : newVersion > currentVersion
   NO : newVersion <= currentVersion
   */
  return compareResutl;
}

@end
