//
//  Tools.h
//  YRProject
//
//  Created by GoodWill on 2017/1/6.
//  Copyright © 2017年 GoodWill. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tools : NSObject
//CGSizeMake(self.bounds.size.width - 111 - 10, CGFLOAT_MAX)

/**
 获取 UILabel 的宽高
 @param textLabel       UILabel控件
 @param fontSize        字体大小
 @param lineSpacing     行间距
 @param maxSize         CGSizeMake(self.bounds.size.width - 111 - 10, CGFLOAT_MAX) MAXFLOAT
 @return                CGSize
 */
+ (CGSize)boundingRectWithLabel:(UILabel *)textLabel FontSize:(CGFloat)fontSize LineSpacing:(CGFloat)lineSpacing MaxSize:(CGSize)maxSize;



/**
 获取计算文字高度 可以处理计算带行间距的
 @param text            文本
 @param size            范围 CGSizeMake(xxx, MAXFLOAT)
 @param font            字体大小
 @param lineSpacing     行间距
 @return                CGSize
 */
+ (CGSize)boundingRectWithText:(NSString *)text size:(CGSize)size font:(UIFont*)font lineSpacing:(CGFloat)lineSpacing;



/**
 判断字符串是否为空
 @param str     字符串
 @return        BOOL
 */
+ (BOOL)comperStingIsEmpty:(NSString *)str;



/**
 判断数组是否为空
 @param array 数组
 @return      BooL
 */
+ (BOOL)comperArrayIsEmpty:(NSArray *)array;


/**
 判断对象是否为空
 @param object 对象
 @return BOOL
 */
+ (BOOL)isNullOrNilWithObject:(id)object;


/**
 数组转json字符串
 @param mutableArray   数组
 @return               NSSting
 */
+ (NSString *)arrayToJson:(NSMutableArray *)mutableArray;


/**
 字典转json字符串
 @param dic          字典
 @return             NSSting
 */
+ (NSString *)dictionaryToJson:(NSDictionary *)dic;
+ (NSString *)toJSONData:(id)theData;
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;


/**
 切圆角
 @param originView      view
 @param topLeft         topLeft
 @param topRight        topRight
 @param bottomLeft      bottomLeft
 @param bottomRight     bottomRight
 @return return         view
 */
+ (UIView *)clipCornerWithView:(UIView *)originView
                    andTopLeft:(BOOL)topLeft
                   andTopRight:(BOOL)topRight
                 andBottomLeft:(BOOL)bottomLeft
                andBottomRight:(BOOL)bottomRight
                   cornerRadii:(CGSize)cornerSize;


/**
 判断是否开启系统通知
 @return YES/NO
 */
+ (BOOL)isMessageNotificationServiceOpen;

/**
 水印
 @param frame       frame
 @param superView   父视图
 @param cols        列数
 @param title       水印文字
 */
+ (CALayer *)AddWaterMarkWithFrame:(CGRect)frame
                    superView:(UIView *)superView
                         cols:(NSInteger)cols
                        title:(NSString *)title;

/**
 水印文字
 @param logoText    文字
 @param rect        imageFrame
 @param angle       角度
 @return            UIImage
 */
+ (UIImage *)imageAddText:(NSString *)logoText imageRect:(CGRect)rect withAngle:(CGFloat)angle;


/**
 根据目标图片制作一个盖水印的图片
  @param originalImage 源图片
 @param title 水印文字
 @param markFont 水印文字font(如果不传默认为23)
 @param markColor 水印文字颜色(如果不传递默认为源图片的对比色)
 @return 返回盖水印的图片
 */
+ (UIImage *)getWaterMarkImage:(UIImage *)originalImage andTitle:(NSString *)title andMarkFont:(UIFont *)markFont andMarkColor:(UIColor *)markColor;


/**
 颜色转化成图片
 @param color 颜色
 @param height 图片高度
 @return UIImage
 */
+ (UIImage *)imageWithColor:(UIColor *)color height:(CGFloat)height;


/**
 数字用","隔开
 @param num     数值
 @return        NSString
 */
+ (NSString *)hanleNums:(NSString *)num;


/**
 判断麦克风权限
 @param NSInteger   返回 0、1、2 权限
 @return            NSInteger
 */
+ (NSInteger)checkAVMediaTypeAudio;



/**
 绘制三角形
 @param color 填充色
 @param point 位置
 @return CAShapeLayer
 */
+ (CAShapeLayer *)createIndicatorWithColor:(UIColor *)color andPosition:(CGPoint)point;


/**
 获取手机型号

 @return NSString
 */
+ (NSString *)getCurrentDeviceModel;



/**
 比较 应用的 App 版本号

 @param currentVersion 当前的版本号
 @param newVersion 新版本号
 @return
 */
+ (BOOL)compareCurrentVersion:(NSString *)currentVersion newVersion:(NSString *)newVersion;
@end
