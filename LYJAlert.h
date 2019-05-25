//
//  LYJAlert.h
//  MocireDoctor
//
//  Created by LYJ on 2018/12/14.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LYJAlert : NSObject

/**
 只有 取消
 */
+ (void)showAlertControllerTitle:(NSString *)title
                         message:(NSString *)message
                     cancelTitle:(NSString *)cancelTitle
                     cancelBlock:(void(^)(UIAlertAction *action))cancelBlock;
/**
 只有 取消 messageL
 */
+ (void)showAlertControllerTitle:(NSString *)title
                         messageL:(NSString *)messageL
                     cancelTitle:(NSString *)cancelTitle
                     cancelBlock:(void(^)(UIAlertAction *action))cancelBlock;

/**
 只有 确认
 */
+ (void)showAlertControllerTitle:(NSString *)title
                         message:(NSString *)message
                    defaultTitle:(NSString *)defaultTitle
                    defaultBlock:(void(^)(UIAlertAction *action))defaultBlock;

/**
 只有 确认 messageL
 */
+ (void)showAlertControllerTitle:(NSString *)title
                         messageL:(NSString *)messageL
                    defaultTitle:(NSString *)defaultTitle
                    defaultBlock:(void(^)(UIAlertAction *action))defaultBlock;

/**
 取消 确认
 */
+ (void)showAlertControllerTitle:(NSString *)title
                         message:(NSString *)message
                     cancelTitle:(NSString *)cancelTitle
                    defaultTitle:(NSString *)defaultTitle
                     cancelBlock:(void(^)(UIAlertAction *action))cancelBlock
                    defaultBlock:(void(^)(UIAlertAction *action))defaultBlock;

/**
 取消 确认 messageL
 */
+ (void)showAlertControllerTitle:(NSString *)title
                         messageL:(NSString *)messageL
                     cancelTitle:(NSString *)cancelTitle
                    defaultTitle:(NSString *)defaultTitle
                     cancelBlock:(void(^)(UIAlertAction *action))cancelBlock
                    defaultBlock:(void(^)(UIAlertAction *action))defaultBlock;

@end
