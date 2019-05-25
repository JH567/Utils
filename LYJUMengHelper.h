//
//  LYJUMengHelper.h
//  MocireDoctor
//
//  Created by LYJ on 2019/5/7.
//  Copyright © 2019 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>

// 友盟推送相关
@interface LYJUMengHelper : NSObject

+ (instancetype)sharedManager;

/** 初始化友盟所有组件产品 */
+ (void)startWithLaunchOptions:(NSDictionary *)launchOptions delegate:(id)delegate;
/** 注册deviceToken */
+ (void)registerDeviceToken:(NSData *)deviceToken;
/** 应用处于运行时（前台、后台）的消息处理 */
+ (void)didReceiveRemoteNotification:(NSDictionary *)userInfo;
/** 关闭消息推送(会移除当前的deviceToken，来关闭消息推送)*/
+ (void)unregisterForRemoteNotifications;
/** 使用友盟Alert */
+ (void)setAutoAlert:(BOOL)isShow;
/** 统一处理推送接收消息（前后台）- 是否点击通知栏 YES:点击 NO:未点击*/
+ (void)showCustomAlertViewWithUserInfo:(NSDictionary *)userInfo clickNotification:(BOOL)isClick;

@end
