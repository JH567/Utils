//
//  TagList.m
//  MocireDoctor
//
//  Created by LYJ on 2018/12/7.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import "TagList.h"

@interface TagList () {
  NSMutableArray *_tagArray;
  NSArray *_restTags;
}
@property (nonatomic, strong) NSMutableDictionary *tags;
@property (nonatomic, strong) NSMutableArray *tagButtons;
@property (nonatomic, strong) NSMutableArray * saveSelButValueArr;
@end

@implementation TagList

- (NSMutableArray *)saveSelButValueArr{
  if (!_saveSelButValueArr) {
    _saveSelButValueArr = [[NSMutableArray alloc] init];
  }
  return _saveSelButValueArr;
}

- (NSMutableArray *)tagArray {
  if (!_tagArray) {
    _tagArray = [[NSMutableArray alloc] init];
  }
  return _tagArray;
}
- (NSMutableDictionary *)tags {
  if (!_tags) {
    _tags = [NSMutableDictionary dictionary];
  }
  return _tags;
}
- (NSMutableArray *)tagButtons {
  if (!_tagButtons) {
    _tagButtons = [[NSMutableArray alloc] init];
  }
  return _tagButtons;
}

- (instancetype)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    [self setup];
  }
  return self;
}

#pragma mark - 初始化
- (void)setup {
  _tagMargin = 10.f;
  _tagCornerRadius = 5.f;
  _tagButtonMarginDx = 5.f;
  _tagButtonMarginDy = 5.f;
  _tagColor = [UIColor redColor];
  _tagSelectColor = [UIColor greenColor];
  _tagFont = [UIFont systemFontOfSize:13.];
  _borderWidth = 0.f;
  _borderColor = _tagColor;
  _tagListCols = 4;
  _isFitTagListH = YES;
  _isSingle = YES;
  self.clipsToBounds = YES;
}

- (CGFloat)tagListH {
  if (self.tagButtons.count <= 0) return 0;
  return CGRectGetMaxY([self.tagButtons.lastObject frame]) + _tagMargin;
}

#pragma mark - 操作标签方法
// 添加多个标签
- (void)addTags:(NSArray *)tagStrs {
  if (self.frame.size.width == 0) {
    @throw [NSException exceptionWithName:@"YZError" reason:@"先设置标签列表的frame" userInfo:nil];
  }
  
  for (NSString *tagStr in tagStrs) {
    [self addTag:tagStr];
  }
  _restTags = tagStrs;
}
// 添加标签
- (void)addTag:(NSString *)tagStr {
  Class tagClass = _tagClass ? _tagClass : [UIButton class];
  // 创建标签按钮
  UIButton *tagButton = [tagClass buttonWithType:UIButtonTypeCustom];
  tagButton.layer.cornerRadius = _tagCornerRadius;
  tagButton.layer.borderWidth = _borderWidth;
  tagButton.layer.borderColor = _borderColor.CGColor;
  tagButton.clipsToBounds = YES;
  tagButton.tag = self.tagButtons.count;
  [tagButton setTitle:tagStr forState:UIControlStateNormal];
  [tagButton setTitleColor:_tagColor forState:UIControlStateNormal];
  [tagButton setTitleColor:_tagSelectColor forState:UIControlStateSelected];
  tagButton.backgroundColor = _tagBackgroundColor;
  tagButton.titleLabel.font = _tagFont;
  [tagButton addTarget:self action:@selector(clickTag:) forControlEvents:UIControlEventTouchUpInside];
  
  [self addSubview:tagButton];
  // 保存到数组
  [self.tagButtons addObject:tagButton];
  
  // 保存到字典
  [self.tags setObject:tagButton forKey:tagStr];
  [self.tagArray addObject:tagStr];
  
  // 设置按钮的位置
  [self updateTagButtonFrame:tagButton.tag extreMargin:YES];
  
  // 更新自己的高度
  if (_isFitTagListH) {
    CGRect frame = self.frame;
    frame.size.height = self.tagListH;
    [UIView animateWithDuration:0.25 animations:^{
      self.frame = frame;
    }];
  }
  
}

// 删除标签
- (void)deleteTag:(NSString *)tagStr {
  // 获取对应的标题按钮
  UIButton *button = self.tags[tagStr];
  
  // 移除按钮
  [button removeFromSuperview];
  
  // 移除数组
  [self.tagButtons removeObject:button];
  
  // 移除字典
  [self.tags removeObjectForKey:tagStr];
  
  // 移除数组
  [self.tagArray removeObject:tagStr];
  
  // 更新tag
  [self updateTag];
  
  // 更新后面按钮的frame
  [UIView animateWithDuration:0.25 animations:^{
    [self updateLaterTagButtonFrame:button.tag];
  }];
  
  // 更新自己的frame
  if (_isFitTagListH) {
    CGRect frame = self.frame;
    frame.size.height = self.tagListH;
    [UIView animateWithDuration:0.25 animations:^{
      self.frame = frame;
    }];
  }
}

// 更新标签
- (void)updateTag {
  NSInteger count = self.tagButtons.count;
  for (int i = 0; i < count; i++) {
    UIButton *tagButton = self.tagButtons[i];
    tagButton.tag = i;
  }
}

// 更新以后按钮
- (void)updateLaterTagButtonFrame:(NSInteger)laterI {
  NSInteger count = self.tagButtons.count;
  
  for (NSInteger i = laterI; i < count; i++) {
    // 更新按钮
    [self updateTagButtonFrame:i extreMargin:NO];
  }
}

#pragma mark--- 单选、多选
- (void)clickTag:(UIButton *)sender {
  
  sender.selected = !sender.selected;
  if (_isSingle) {
    // 单选
    [self.saveSelButValueArr removeAllObjects];
    if (sender.selected) {
      for (int i = 0; i < self.tagButtons.count; i ++) {
        @autoreleasepool {
          if (sender.tag == i) {
            sender.selected = YES;
            sender.backgroundColor = _tagSelectBackgroundColor;
            continue;
          }
          UIButton *but = (UIButton *)self.tagButtons[i];
          but.selected = NO;
          but.backgroundColor = _tagBackgroundColor;
        }
      }
      [self.saveSelButValueArr addObject:sender.currentTitle];
    } else {
      sender.backgroundColor = _tagBackgroundColor;
      [self.saveSelButValueArr removeObject:sender.currentTitle];
    }
    
  } else {
    // 多选
    if (sender.selected) {
      sender.backgroundColor = _tagSelectBackgroundColor;
      [self.saveSelButValueArr addObject:sender.currentTitle];
    } else {
      sender.backgroundColor = _tagBackgroundColor;
      [self.saveSelButValueArr removeObject:sender.currentTitle];
    }
  }
  
  if (_clickTagBlock) {
    _clickTagBlock(self.saveSelButValueArr);
  }
}

#pragma mark---重置
- (void)reset {
  //重置，回到初始默认状态
  for (UIButton *but in self.subviews) {
    //移除旧的视图，从sel的视图
    [but removeFromSuperview];
  }
  
  [self.saveSelButValueArr removeAllObjects];
  [self.tagButtons removeAllObjects];
  [self.tags removeAllObjects];
  [self.tagArray removeAllObjects];
  
  // 更新自己的高度
  if (_isFitTagListH) { 
    self.tagListH = 0;
    CGRect frame = self.frame;
    frame.size.height = self.tagListH;
    [UIView animateWithDuration:0.25 animations:^{
      self.frame = frame;
    }];
  }
  for (NSString *tagStr in _restTags) {
    [self addTag:tagStr];
  }
}

- (void)updateTagButtonFrame:(NSInteger)i extreMargin:(BOOL)extreMargin {
  // 获取上一个按钮
  NSInteger preI = i - 1;
  
  // 定义上一个按钮
  UIButton *preButton;
  
  // 过滤上一个角标
  if (preI >= 0) {
    preButton = self.tagButtons[preI];
  }
  
  // 获取当前按钮
  UIButton *tagButton = self.tagButtons[i];
  // 判断是否设置标签的尺寸
  if (_tagSize.width == 0) { // 没有设置标签尺寸
    // 自适应标签尺寸
    // 设置标签按钮frame（自适应）
    [self setupTagButtonCustomFrame:tagButton preButton:preButton extreMargin:extreMargin];
  } else { // 按规律排布
    // 计算标签按钮frame（regular）
    [self setupTagButtonRegularFrame:tagButton];
  }
}

// 计算标签按钮frame（按规律排布）
- (void)setupTagButtonRegularFrame:(UIButton *)tagButton {
  // 获取角标
  NSInteger i = tagButton.tag;
  NSInteger col = i % _tagListCols;
  NSInteger row = i / _tagListCols;
  CGFloat btnW = _tagSize.width;
  CGFloat btnH = _tagSize.height;
  NSInteger margin = (self.bounds.size.width - _tagListCols * btnW - 2 * _tagMargin) / (_tagListCols - 1);
  CGFloat btnX = _tagMargin + col * (btnW + margin);
  CGFloat btnY = _tagMargin + row * (btnH + margin);
  tagButton.frame = CGRectMake(btnX, btnY, btnW, btnH);
}

// 设置标签按钮frame（自适应）
- (void)setupTagButtonCustomFrame:(UIButton *)tagButton preButton:(UIButton *)preButton extreMargin:(BOOL)extreMargin {
  // 等于上一个按钮的最大X + 间距
  CGFloat btnX = CGRectGetMaxX(preButton.frame) + _tagMargin;
  
  // 等于上一个按钮的Y值,如果没有就是标签间距
  CGFloat btnY = preButton? preButton.frame.origin.y : _tagMargin;
  
  // 获取按钮宽度
  CGFloat titleW = [self sizeWidthWidth:tagButton.titleLabel.text font:_tagFont].width;
  CGFloat titleH = [self sizeWidthWidth:tagButton.titleLabel.text font:_tagFont].height;
  CGFloat btnW = 0;
  if (extreMargin) {
    if (_tagButtonWidth) {
      btnW = _tagButtonWidth;
    } else {
      btnW = titleW + 2 * _tagButtonMarginDx;
    }
  } else {
    btnW = tagButton.bounds.size.width;
  }
  
  // 获取按钮高度
  CGFloat btnH = 0;
  if (extreMargin) {
    if (_tagButtonHeight) {
      btnH = _tagButtonHeight;
    } else {
      btnH = titleH + 2 * _tagButtonMarginDy;
    }
  } else {
    btnH = tagButton.bounds.size.height;
  }
  
  // 判断当前按钮是否足够显示
  CGFloat rightWidth = self.bounds.size.width - btnX;
  
  if (rightWidth < btnW) {
    // 不够显示，显示到下一行
    btnX = _tagMargin;
    btnY = CGRectGetMaxY(preButton.frame) + _tagMargin;
  }
  tagButton.frame = CGRectMake(btnX, btnY, btnW, btnH);
}

#pragma mark---根据指定文本,字体和最大高度计算尺寸
- (CGSize)sizeWidthWidth:(NSString *)text font:(UIFont *)font {
  
  NSMutableDictionary *attrDict = [NSMutableDictionary dictionary];
  attrDict[NSFontAttributeName] = font;
  CGSize size = [text boundingRectWithSize:CGSizeMake(0, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:attrDict context:nil].size;
  return size;
}


@end
