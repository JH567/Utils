//
//  LYJUMengHelper.m
//  MocireDoctor
//
//  Created by LYJ on 2019/5/7.
//  Copyright © 2019 Facebook. All rights reserved.
//

#import "LYJUMengHelper.h"
#import <UserNotifications/UserNotifications.h>
#import "TipsCheckViewController.h"

@interface LYJUMengHelper ()<UNUserNotificationCenterDelegate>
@property (nonatomic, strong) NSDictionary *userInfo;
@end

@implementation LYJUMengHelper

+ (instancetype)sharedManager {
  static LYJUMengHelper *_manager = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    if (!_manager) {
      _manager = [[[self class] alloc] init];
    }
  });
  return _manager;
}

+ (void)startWithLaunchOptions:(NSDictionary *)launchOptions delegate:(id)delegate {
  /*  初始化友盟所有组件产品 (需要集成测试，添加设备，否则造成数据污染)
   NSString *deviceID = [UMConfigure deviceIDForIntegration];
   NSLog(@"集成测试的deviceID:%@", deviceID);
   {"oid": "your_device_id"}
   */
  [UMConfigure initWithAppkey:kUMAppKey channel:@"App Store"];
  
  // 统计设置
#ifdef DEBUG
  [UMConfigure setLogEnabled:YES];
  [MobClick setCrashReportEnabled:NO];//开启CrashReport收集
#else
  [UMConfigure setLogEnabled:NO];
  [MobClick setScenarioType:E_UM_NORMAL];//设置统计场景类型
  [MobClick setCrashReportEnabled:YES];//开启CrashReport收集
#endif
  
  // 推送设置
  UMessageRegisterEntity *entity = [[UMessageRegisterEntity alloc] init];
  if (@available(iOS 10.0, *)) {
    [UNUserNotificationCenter currentNotificationCenter].delegate = delegate;
  } else {
    // Fallback on earlier versions
  }
  [UMessage registerForRemoteNotificationsWithLaunchOptions:launchOptions Entity:entity completionHandler:^(BOOL granted, NSError * _Nullable error) {
    if (granted) {
      
    } else {
      
    }
  }];

}

+ (void)registerDeviceToken:(NSData *)deviceToken {
  [UMessage registerDeviceToken:deviceToken];
}

+ (void)didReceiveRemoteNotification:(NSDictionary *)userInfo {
  [UMessage didReceiveRemoteNotification:userInfo];
}

+ (void)unregisterForRemoteNotifications {
  [UMessage unregisterForRemoteNotifications];
}

+ (void)setAutoAlert:(BOOL)isShow {
  [UMessage setAutoAlert:isShow];
}

+ (void)showCustomAlertViewWithUserInfo:(NSDictionary *)userInfo clickNotification:(BOOL)isClick {
  /** 应用在前台时,也会收到该通知,进行页面的跳转
   UIApplicationStateActive, 前台
   UIApplicationStateInactive, 进入前台
   UIApplicationStateBackground 在后台
   UIApplicationState applicationState = [UIApplication sharedApplication].applicationState
   */
  DLog(@"---- userInfo: %@", userInfo)
  if (isClick) {
    DLog(@"----点击通知栏操作")
    NSString *extra = [userInfo objectForKey:@"extra"];
    if ([Tools comperStingIsEmpty:extra]) {
      DLog(@"-------融云推送")
      [self handleRongCloudPush:userInfo];
    } else {
      DLog(@"-------友盟推送")
      [self handleUmengPush:userInfo];
    }
    
  } else {
    DLog(@"----未点击通知栏操作")
  }
}

+ (void)handleRongCloudPush:(NSDictionary *)userInfo {
  NSDictionary *rc = userInfo[@"rc"];
  NSString *cType = rc[@"cType"];
  if ([cType isEqualToString:@"PR"]) { // 单聊
    UIViewController *controller = [CurrentVCManager activityCurrentViewController];
    if (![controller isKindOfClass:[NSClassFromString(@"GCScheduledViewController") class]]) {
      // 处理 权限检测、满足条件并进入聊天聊天
      TipsCheckViewController *tipsCheckVC = [[TipsCheckViewController alloc] init];
      tipsCheckVC.callbackBlock = ^(NSInteger code, NSString *msg) {
        if (code == 3) {
          [LYJAlert showAlertControllerTitle:@"请重新绑定HIS账号" message:nil cancelTitle:@"稍候" defaultTitle:@"重新绑定" cancelBlock:nil defaultBlock:^(UIAlertAction *action) {
            [LYJLoadModules loadModule:@"BindHis" ermPatientModel:nil hisPatientModel:nil hisGroupModel:nil bindFlag:@"2" tabBarHide:NO];
          }];
        } else if (code == 4) {
          [LYJAlert showAlertControllerTitle:@"请绑定HIS账号" message:nil cancelTitle:@"稍候" defaultTitle:@"绑定" cancelBlock:nil defaultBlock:^(UIAlertAction *action) {
            [LYJLoadModules loadModule:@"BindHis" ermPatientModel:nil hisPatientModel:nil hisGroupModel:nil bindFlag:@"1" tabBarHide:NO];
          }];
        } else {
          [LYJAlert showAlertControllerTitle:msg message:nil defaultTitle:@"确定" defaultBlock:nil];
        }
      };
      
      dispatch_async(dispatch_get_main_queue(), ^{
        [controller.navigationController pushViewController:tipsCheckVC animated:YES];
      });
    }

  } else if ([cType isEqualToString:@"GRP"]) { // 群组
    
  } else {
    DLog(@"会话类型 %@ 未定义", cType)
  }
}

+ (void)handleUmengPush:(NSDictionary *)userInfo {
  
}

@end
