//
//  UIButton+TimerCategory.m
//  MocireDoctor
//
//  Created by LYJ on 2018/11/25.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import "UIButton+TimerCategory.h"

@implementation UIButton (TimerCategory)

- (void)startCountDownTime:(int)time block:(void (^)(void))block {
  [self startTime:time];
  block();
}

- (void)startTime:(int)time {
  __block int timeout = time; //倒计时时间
  dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
  dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
  dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
  dispatch_source_set_event_handler(_timer, ^{
    if(timeout <= 0){ //倒计时结束，关闭
      dispatch_source_cancel(_timer);
      dispatch_async(dispatch_get_main_queue(), ^{
        //设置界面的按钮显示 根据自己需求设置
        [self setTitle:@"获取验证码" forState:UIControlStateNormal];
        self.userInteractionEnabled = YES;
      });
    }else{
//      int seconds = timeout % 60;
      int seconds = timeout;
      NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
      dispatch_async(dispatch_get_main_queue(), ^{
        //设置界面的按钮显示 根据自己需求设置 —— @"重新发送(%@s)"
        [self setTitle:[NSString stringWithFormat:@"%@s",strTime] forState:UIControlStateNormal];
        self.userInteractionEnabled = NO;
      });
      timeout --;
    }
  });
  dispatch_resume(_timer);
  
}

- (void)layoutWithStatus:(MCLayoutStatus)status andMargin:(CGFloat)margin {
  CGFloat imgWidth = self.imageView.bounds.size.width;
  CGFloat imgHeight = self.imageView.bounds.size.height;
  CGFloat labWidth = self.titleLabel.bounds.size.width;
  CGFloat labHeight = self.titleLabel.bounds.size.height;
  CGSize textSize = [self.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:self.titleLabel.font}];
  CGSize frameSize = CGSizeMake(ceilf(textSize.width), ceilf(textSize.height));
  if (labWidth < frameSize.width) {
    labWidth = frameSize.width;
  }
  CGFloat kMargin = margin/2.0;
  switch (status) {
    case MCLayoutStatusNormal://图左字右
      [self setImageEdgeInsets:UIEdgeInsetsMake(0, -kMargin, 0, kMargin)];
      [self setTitleEdgeInsets:UIEdgeInsetsMake(0, kMargin, 0, -kMargin)];
      break;
    case MCLayoutStatusImageRight://图右字左
      [self setImageEdgeInsets:UIEdgeInsetsMake(0, labWidth + kMargin, 0, -labWidth - kMargin)];
      [self setTitleEdgeInsets:UIEdgeInsetsMake(0, -imgWidth - kMargin, 0, imgWidth + kMargin)];
      break;
    case MCLayoutStatusImageTop://图上字下
      [self setImageEdgeInsets:UIEdgeInsetsMake(0,0, labHeight + margin, -labWidth)];
      
      [self setTitleEdgeInsets:UIEdgeInsetsMake(imgHeight + margin, -imgWidth, 0, 0)];
      break;
    case MCLayoutStatusImageBottom://图下字上
      [self setImageEdgeInsets:UIEdgeInsetsMake(labHeight + margin,0, 0, -labWidth)];
      
      [self setTitleEdgeInsets:UIEdgeInsetsMake(0, -imgWidth, imgHeight + margin, 0)];
      
      break;
    default:
      break;
  }
}

@end
