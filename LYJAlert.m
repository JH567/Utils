//
//  LYJAlert.m
//  MocireDoctor
//
//  Created by LYJ on 2018/12/14.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import "LYJAlert.h"

@implementation LYJAlert

+ (void)showAlertControllerTitle:(NSString *)title
                         message:(NSString *)message
                     cancelTitle:(NSString *)cancelTitle
                     cancelBlock:(void(^)(UIAlertAction *action))cancelBlock {
  LYJAlert *alert = [[LYJAlert alloc] init];
  [alert showAlertControllerTitle:title
                          message:message
                      cancelTitle:cancelTitle
                     defaultTitle:nil
                         isCancel:YES
                        isDefault:NO
                      cancelBlock:cancelBlock
                     defaultBlock:nil];
}

+ (void)showAlertControllerTitle:(NSString *)title
                         messageL:(NSString *)messageL
                     cancelTitle:(NSString *)cancelTitle
                     cancelBlock:(void(^)(UIAlertAction *action))cancelBlock {
  LYJAlert *alert = [[LYJAlert alloc] init];
  [alert showAlertControllerTitle:title
                          messageL:messageL
                      cancelTitle:cancelTitle
                     defaultTitle:nil
                         isCancel:YES
                        isDefault:NO
                      cancelBlock:cancelBlock
                     defaultBlock:nil];
}

+ (void)showAlertControllerTitle:(NSString *)title
                         message:(NSString *)message
                    defaultTitle:(NSString *)defaultTitle
                    defaultBlock:(void(^)(UIAlertAction *action))defaultBlock {
  LYJAlert *alert = [[LYJAlert alloc] init];
  [alert showAlertControllerTitle:title
                          message:message
                      cancelTitle:nil
                     defaultTitle:defaultTitle
                         isCancel:NO
                        isDefault:YES
                      cancelBlock:nil
                     defaultBlock:defaultBlock];
}

+ (void)showAlertControllerTitle:(NSString *)title
                         messageL:(NSString *)messageL
                    defaultTitle:(NSString *)defaultTitle
                    defaultBlock:(void(^)(UIAlertAction *action))defaultBlock {
  LYJAlert *alert = [[LYJAlert alloc] init];
  [alert showAlertControllerTitle:title
                          messageL:messageL
                      cancelTitle:nil
                     defaultTitle:defaultTitle
                         isCancel:NO
                        isDefault:YES
                      cancelBlock:nil
                     defaultBlock:defaultBlock];
}

+ (void)showAlertControllerTitle:(NSString *)title
                         message:(NSString *)message
                     cancelTitle:(NSString *)cancelTitle
                    defaultTitle:(NSString *)defaultTitle
                     cancelBlock:(void(^)(UIAlertAction *action))cancelBlock
                    defaultBlock:(void(^)(UIAlertAction *action))defaultBlock {
  LYJAlert *alert = [[LYJAlert alloc] init];
  [alert showAlertControllerTitle:title
                          message:message
                      cancelTitle:cancelTitle
                     defaultTitle:defaultTitle
                         isCancel:YES
                        isDefault:YES
                      cancelBlock:cancelBlock
                     defaultBlock:defaultBlock];
}

+ (void)showAlertControllerTitle:(NSString *)title
                         messageL:(NSString *)messageL
                     cancelTitle:(NSString *)cancelTitle
                    defaultTitle:(NSString *)defaultTitle
                     cancelBlock:(void(^)(UIAlertAction *action))cancelBlock
                    defaultBlock:(void(^)(UIAlertAction *action))defaultBlock {
  LYJAlert *alert = [[LYJAlert alloc] init];
  [alert showAlertControllerTitle:title
                          messageL:messageL
                      cancelTitle:cancelTitle
                     defaultTitle:defaultTitle
                         isCancel:YES
                        isDefault:YES
                      cancelBlock:cancelBlock
                     defaultBlock:defaultBlock];
}

- (void)showAlertControllerTitle:(NSString *)title
                         message:(NSString *)message
                     cancelTitle:(NSString *)cancelTitle
                    defaultTitle:(NSString *)defaultTitle
                        isCancel:(BOOL)isCancel
                       isDefault:(BOOL)isDefault
                     cancelBlock:(void(^)(UIAlertAction *action))cancelBlock
                    defaultBlock:(void(^)(UIAlertAction *action))defaultBlock {
  
  UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
  
  if (isCancel) {
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
      if (cancelBlock) {
        cancelBlock(action);
      }
    }];
    [alertController addAction:cancelAction];
  }
  
  if (isDefault) {
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:defaultTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
      if (defaultBlock) {
        defaultBlock(action);
      }
    }];
    [alertController addAction:okAction];
  }
  
  UIViewController *activeVC = [CurrentVCManager activityCurrentViewController];
  dispatch_async(dispatch_get_main_queue(), ^{
    [activeVC presentViewController:alertController animated:YES completion:nil];
  });
}

- (void)showAlertControllerTitle:(NSString *)title
                         messageL:(NSString *)messageL
                     cancelTitle:(NSString *)cancelTitle
                    defaultTitle:(NSString *)defaultTitle
                        isCancel:(BOOL)isCancel
                       isDefault:(BOOL)isDefault
                     cancelBlock:(void(^)(UIAlertAction *action))cancelBlock
                    defaultBlock:(void(^)(UIAlertAction *action))defaultBlock {
  
  UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:messageL preferredStyle:UIAlertControllerStyleAlert];
  
  [[self class] enumrateSubviewsInView:alertController.view message:messageL msgAlignment:NSTextAlignmentLeft];
  
  if (isCancel) {
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
      if (cancelBlock) {
        cancelBlock(action);
      }
    }];
    [alertController addAction:cancelAction];
  }
  
  if (isDefault) {
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:defaultTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
      if (defaultBlock) {
        defaultBlock(action);
      }
    }];
    [alertController addAction:okAction];
  }
  
  UIViewController *activeVC = [CurrentVCManager activityCurrentViewController];
  dispatch_async(dispatch_get_main_queue(), ^{
    [activeVC presentViewController:alertController animated:YES completion:nil];
  });
}

/**
 UIAlertController message 居左对齐

 @param view  UIAlertController的视图
 @param message 文本内容
 @param msgAlignment 文本对齐方式
 */
+ (void)enumrateSubviewsInView:(UIView *)view message:(NSString*)message msgAlignment:(NSTextAlignment)msgAlignment {
  NSArray *subViews = view.subviews;
  if (subViews.count == 0) {
    return;
  }
  for (NSInteger i = 0; i < subViews.count; i++) {
    UIView *subView = subViews[i];
    [self enumrateSubviewsInView:subView message:message msgAlignment:msgAlignment];
    
    if ([subView isKindOfClass:[UILabel class]]) {
      UILabel *label = (UILabel *)subView;
      if ([label.text isEqualToString:message]) {
        label.textAlignment = msgAlignment;
      }
    }
  }
}


@end
