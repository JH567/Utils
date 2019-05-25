//
//  CurrentVCManager.h
//  YRProject
//
//  Created by GoodWill on 2018/5/9.
//  Copyright © 2018年 GoodWill. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CurrentVCManager : NSObject

/**
 获取当前活跃控制器

 @return VC
 */
+ (UIViewController *)activityCurrentViewController;
@end
