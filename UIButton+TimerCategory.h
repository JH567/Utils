//
//  UIButton+TimerCategory.h
//  MocireDoctor
//
//  Created by LYJ on 2018/11/25.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
  /** 正常位置，图左字右 */
  MCLayoutStatusNormal,
  /** 图右字左 */
  MCLayoutStatusImageRight,
  /** 图上字下 */
  MCLayoutStatusImageTop,
  /** 图下字上 */
  MCLayoutStatusImageBottom
} MCLayoutStatus;

@interface UIButton (TimerCategory)

- (void)startCountDownTime:(int)time block:(void(^)(void))block;

- (void)layoutWithStatus:(MCLayoutStatus)status andMargin:(CGFloat)margin;

@end

NS_ASSUME_NONNULL_END
