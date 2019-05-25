//
//  CurrentVCManager.m
//  YRProject
//
//  Created by GoodWill on 2018/5/9.
//  Copyright © 2018年 GoodWill. All rights reserved.
//

#import "CurrentVCManager.h"

@implementation CurrentVCManager
#pragma mark -
#pragma mark 获取当前活跃控制器
+ (UIViewController *)activityCurrentViewController {
  
  UIWindow *window = [[UIApplication sharedApplication] keyWindow];
  if(window.windowLevel != UIWindowLevelNormal) {
    NSArray *windows = [[UIApplication sharedApplication] windows];
    for(UIWindow *tmpWin in windows) {
      if(tmpWin.windowLevel == UIWindowLevelNormal) {
        window = tmpWin;
        break;
      }
    }
  }
  NSAssert(window, @"The window is empty");
  
  UIViewController* currentViewController = window.rootViewController;
  BOOL runLoopFind = YES;
  while (runLoopFind) {
    if (currentViewController.presentedViewController) {
      
      currentViewController = currentViewController.presentedViewController;
    } else if ([currentViewController isKindOfClass:[UINavigationController class]]) {
      
      UINavigationController* navigationController = (UINavigationController* )currentViewController;
      currentViewController = navigationController.visibleViewController;
      
    } else if ([currentViewController isKindOfClass:[UITabBarController class]]) {
      
      UITabBarController* tabBarController = (UITabBarController* )currentViewController;
      currentViewController = tabBarController.selectedViewController;
    } else {
      
      NSUInteger childViewControllerCount = currentViewController.childViewControllers.count;
      if (childViewControllerCount > 0) {
        
        currentViewController = currentViewController.childViewControllers.lastObject;
        
        return currentViewController;
      } else {
        
        return currentViewController;
      }
    }
    
  }
  return currentViewController;
}

@end
