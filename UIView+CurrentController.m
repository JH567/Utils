//
//  UIView+CurrentController.m
//  CDRTranslucentSideBar
//
//  Created by GoodWill on 16/5/16.
//  Copyright © 2016年 nscallop. All rights reserved.
//

#import "UIView+CurrentController.h"

@implementation UIView (CurrentController)

/** 获取当前View的控制器对象 */
-(UIViewController *)getCurrentViewController {
    UIResponder *next = [self nextResponder];
    do {
        if ([next isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)next;
        }
        next = [next nextResponder];
    } while (next != nil);
    return nil;
}

- (UIView *)findFirstResponder {
  if (self.isFirstResponder) {
    return self;
  }
  for (UIView *subView in self.subviews) {
    UIView *responder = [subView findFirstResponder];
    if (responder) return responder;
  }
  return nil;
}

@end
