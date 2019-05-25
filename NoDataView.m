//
//  NoDataView.m
//  MocireDoctor
//
//  Created by LYJ on 2019/1/2.
//  Copyright © 2019 Facebook. All rights reserved.
//

#import "NoDataView.h"

@interface NoDataView ()
@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *titleLB;
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, assign) NoDataType type;
@end

@implementation NoDataView
- (UIImageView *)imgView {
  if (!_imgView) {
    _imgView = [UIImageView new];
  }
  return _imgView;
}
- (UILabel *)titleLB {
  if (!_titleLB) {
    _titleLB = [UILabel new];
    _titleLB.font = [UIFont systemFontOfSize:12.];
    _titleLB.textColor = [UIColor colorWithHexString:@"#999999"];
    _titleLB.textAlignment = NSTextAlignmentCenter;
  }
  return _titleLB;
}
- (UIButton *)button {
  if (!_button) {
    _button = [UIButton buttonWithType:UIButtonTypeCustom];
    _button.backgroundColor = kNavBarColor;
    _button.titleLabel.font = [UIFont systemFontOfSize:16.];
    [_button setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [_button addTarget:self action:@selector(clickButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    _button.layer.cornerRadius = 22.;
    _button.layer.masksToBounds = YES;
  }
  return _button;
}

- (instancetype)initWithFrame:(CGRect)frame type:(NoDataType)type {
  if (self = [super initWithFrame:frame]) {
    self.backgroundColor = UIColor.whiteColor;
    _type = type;
    [self addSubview:self.imgView];
    if (_type != NoDataTypeRegist) {
      [self addSubview:self.titleLB];
    }
    [self setupUI];
    [self setNoDataType];
  }
  return self;
}

- (void)setupUI {
  [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerX.mas_equalTo(self);
    make.centerY.mas_equalTo(self.mas_centerY).offset(-50);
  }];
  
  if (_type == NoDataTypePatient || _type == NoDataTypeData) {
    [self.titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
      make.centerX.mas_equalTo(self.imgView);
      make.top.mas_equalTo(self.imgView.mas_bottom);
    }];
  } else {
    if (_type != NoDataTypeRegist) {
      [self.titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.imgView);
        if (self.type == NoDataTypeEMR || self.type == NoDataTypeHIS || self.type == NoDataTypeReEMR || self.type == NoDataTypeReHIS) {
          make.top.mas_equalTo(self.imgView.mas_bottom).offset(10);
        } else {
          make.top.mas_equalTo(self.imgView.mas_bottom);
        }
      }];
    }
    
    [self addSubview:self.button];
    [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
      if (self.type == NoDataTypeRegist) {
        make.top.mas_equalTo(self.imgView.mas_bottom).offset(30);
      } else {
        make.top.mas_equalTo(self.titleLB.mas_bottom).offset(30);
      }
      make.left.right.mas_equalTo(self.button.superview).inset(40);
      make.height.mas_equalTo(44);
    }];
  }
}

- (void)setNoDataType {
  switch (_type) {
    case NoDataTypePatient:
      //暂无患者
      self.imgView.image = [UIImage imageNamed:@"g_dataisnull"];
      self.titleLB.text = @"暂无患者";
      break;
    case NoDataTypeData:
      // 暂无数据
      self.imgView.image = [UIImage imageNamed:@"g_dataisnull"];
      self.titleLB.text = @"暂无数据";
      break;
    case NoDataTypeFail:
      // 加载失败
      self.imgView.image = [UIImage imageNamed:@"g_reload"];
      self.titleLB.text = @"加载失败";
      [self.button setTitle:@"重新加载" forState:UIControlStateNormal];
      break;
    case NoDataTypeNetwork:
      // 网络连接失败
      self.imgView.image = [UIImage imageNamed:@"g_networkfailure"];
      self.titleLB.text = @"网络连接失败";
      [self.button setTitle:@"重新加载" forState:UIControlStateNormal];
      break;
    case NoDataTypeEMR:
      // 需要绑定EMR
      self.imgView.image = [UIImage imageNamed:@"g_binding"];
      self.titleLB.text = @"需要绑定EMR帐号才能使用该功能";
      [self.button setTitle:@"马上绑定" forState:UIControlStateNormal];
      break;
    case NoDataTypeHIS:
      // 需要绑定HIS
      self.imgView.image = [UIImage imageNamed:@"g_binding"];
      self.titleLB.text = @"需要绑定HIS帐号才能使用该功能";
      [self.button setTitle:@"马上绑定" forState:UIControlStateNormal];
      break;
    case NoDataTypeRegist:
      // 需要注册
      self.imgView.image = [UIImage imageNamed:@"g_clickregistration"];
      [self.button setTitle:@"点击注册" forState:UIControlStateNormal];
      break;
    case NoDataTypeReEMR:
      // 需要重绑定EMR
      self.imgView.image = [UIImage imageNamed:@"g_binding"];
      self.titleLB.text = @"您绑定的医院EMR帐号已失效";
      [self.button setTitle:@"重新绑定" forState:UIControlStateNormal];
      break;
    case NoDataTypeReHIS:
      // 需要重绑定HIS
      self.imgView.image = [UIImage imageNamed:@"g_binding"];
      self.titleLB.text = @"您绑定的医院HIS帐号已失效";
      [self.button setTitle:@"重新绑定" forState:UIControlStateNormal];
      break;
      
    default:
      break;
  }
}

- (void)clickButtonAction:(UIButton *)sender {
  NSString *msg = @"";
  if (_type == NoDataTypeEMR || _type == NoDataTypeHIS) {
    // 进行绑定EMR / HIS
    msg = @"绑定";
  } else if (_type == NoDataTypeReEMR || _type == NoDataTypeReHIS) {
    // 重新绑定EMR / HIS
    msg = @"重绑";
  } else if (_type == NoDataTypeRegist) {
    // 注册
    msg = @"注册";
  } else {
    // 重新加载
    msg = @"加载";
  }
  if (self.buttonActionBlock) {
    self.buttonActionBlock(msg);
  }
}

@end
