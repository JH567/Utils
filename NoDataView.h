//
//  NoDataView.h
//  MocireDoctor
//
//  Created by LYJ on 2019/1/2.
//  Copyright © 2019 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
  NoDataTypePatient   = 0, // 暂无患者
  NoDataTypeData      = 1, // 暂无数据
  NoDataTypeFail      = 2, // 加载失败
  NoDataTypeNetwork   = 3, // 网络连接失败
  NoDataTypeEMR       = 4, // 需要绑定EMR
  NoDataTypeHIS       = 5, // 需要绑定HIS
  NoDataTypeRegist    = 6, // 需要注册
  NoDataTypeReEMR     = 7, // 需要重绑定EMR
  NoDataTypeReHIS     = 8, // 需要重绑定HIS
} NoDataType;

/**
 无数据提示
 */
@interface NoDataView : UIView

@property (nonatomic, copy) void(^buttonActionBlock)(NSString *msg);

- (instancetype)initWithFrame:(CGRect)frame type:(NoDataType)type;

@end

NS_ASSUME_NONNULL_END
