//
//  UIView+CurrentController.h
//  CDRTranslucentSideBar
//
//  Created by GoodWill on 16/5/16.
//  Copyright © 2016年 nscallop. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (CurrentController)

/** 获取当前View的控制器对象 */
- (UIViewController *)getCurrentViewController;

- (UIView *)findFirstResponder;

@end
