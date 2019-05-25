//
//  LinerTextField.m
//  YRProject
//
//  Created by GoodWill on 2018/6/6.
//  Copyright © 2018年 GoodWill. All rights reserved.
//

#import "LinerTextField.h"

static NSString * const LYJPlaceholderColorKeyPath = @"_placeholderLabel.textColor";

@interface LinerTextField ()
@property (nonatomic, strong) CALayer *lineLayer;
@end

@implementation LinerTextField

- (void)awakeFromNib {
  [super awakeFromNib];
  // 设置光标和文字颜色一致
  self.tintColor = self.textColor;
  
  // 不成为第一响应者
  [self resignFirstResponder];
}


/**
 当前文本聚焦时就会调用
 
 @return BOOL
 */
- (BOOL)becomeFirstResponder {
  [self setValue:self.textColor forKeyPath:LYJPlaceholderColorKeyPath];
  _lineLayer.backgroundColor = self.textColor.CGColor;
  return [super becomeFirstResponder];
}


/**
 当前文本失去焦点时就会调用
 
 @return BOOL
 */
- (BOOL)resignFirstResponder {
  [self setValue:_placeholderColor forKeyPath:LYJPlaceholderColorKeyPath];
  if (self.text.length > 0) {
    _lineLayer.backgroundColor = self.textColor.CGColor;
  } else {
    _lineLayer.backgroundColor = _placeholderColor.CGColor;
  }
  return [super resignFirstResponder];
}


/**
 重写set方法
 
 @param placeholderColor UIColor
 */
- (void)setPlaceholderColor:(UIColor *)placeholderColor {
  _placeholderColor = placeholderColor;
  // 占位文字颜色
  [self setValue:placeholderColor forKeyPath:LYJPlaceholderColorKeyPath];
}



/**
 绘制底部的线
 
 @param rect CGRect
 */
- (void)drawRect:(CGRect)rect {
  // Drawing code
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSetFillColorWithColor(context, _underLinerColor.CGColor);
//    CGContextFillRect(context, CGRectMake(0, CGRectGetHeight(self.frame) - 1, CGRectGetWidth(self.frame), 1));
 
  
    CALayer *lineLayer = [CALayer layer];
    lineLayer.frame = CGRectMake(0, CGRectGetHeight(self.frame) - 0.5, CGRectGetWidth(self.frame), 0.5);
    [self.layer addSublayer:lineLayer];
    _lineLayer = lineLayer;
  
    if (self.text.length > 0) {
      _lineLayer.backgroundColor = self.textColor.CGColor;
    } else {
      _lineLayer.backgroundColor = _placeholderColor.CGColor;
    }
}


//未编辑状态下的起始位置
- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, 12, 0);
}
// 编辑状态下的起始位置
- (CGRect)editingRectForBounds:(CGRect)bounds {
    return CGRectMake(12, 0, bounds.size.width - self.rightView.bounds.size.width, bounds.size.height);
//    return CGRectInset(bounds, 12, 0);
}
//placeholder起始位置
- (CGRect)placeholderRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, 12, 0);
}

@end

