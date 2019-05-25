//
//  TagList.h
//  MocireDoctor
//
//  Created by LYJ on 2018/12/7.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 *  TagList高度会自动跟随标题计算，默认标签会自动计算宽度
 */
@interface TagList : UIView

/**
 *  标签间距,和距离左，上间距,默认10
 */
@property (nonatomic, assign) CGFloat tagMargin;

/**
 *  标签字体，默认13
 */
@property (nonatomic, strong) UIFont *tagFont;

/**
 *  标签圆角半径,默认为5
 */
@property (nonatomic, assign) CGFloat tagCornerRadius;

/**
 *  边框宽度
 */
@property (nonatomic, assign) CGFloat borderWidth;

/**
 *  边框颜色
 */
@property (nonatomic, strong) UIColor *borderColor;

/**
 *  标签文字颜色，默认红色
 */
@property (nonatomic, strong) UIColor *tagColor;

/**
 *  标签文字选中颜色，默认绿色
 */
@property (nonatomic, strong) UIColor *tagSelectColor;

/**
 *  标签背景颜色
 */
@property (nonatomic, strong) UIColor *tagBackgroundColor;

/**
 *  标签选中背景颜色
 */
@property (nonatomic, strong) UIColor *tagSelectBackgroundColor;

/**
 *  标签按钮内容间距，标签内容距离 左右 间距，默认5
 */
@property (nonatomic, assign) CGFloat tagButtonMarginDx;

/**
 *  标签按钮内容间距，标签内容距离 上下 间距，默认5
 */
@property (nonatomic, assign) CGFloat tagButtonMarginDy;

/**
 *  标签按钮 高度 (不是必须)
 */
@property (nonatomic, assign) CGFloat tagButtonHeight;

/**
 *  标签按钮 宽度 (不是必须)
 */
@property (nonatomic, assign) CGFloat tagButtonWidth;

/**
 *  标签列表的高度
 */
@property (nonatomic, assign) CGFloat tagListH;

/**
 *  获取所有标签
 */
@property (nonatomic, strong, readonly) NSMutableArray *tagArray;

/**
 *  是否需要自定义tagList高度，默认为Yes
 */
@property (nonatomic, assign) BOOL isFitTagListH;

/**
 是否单选 YES 为单选，默认为YES
 */
@property (assign, nonatomic) BOOL isSingle;

/*************  自定义标签按钮  *************/
/**
 *  必须是按钮类
 */
@property (nonatomic, assign) Class tagClass;

/******自定义标签尺寸******/
@property (nonatomic, assign) CGSize tagSize;

/******标签列表总列数 默认4列******/
/**
 *  标签间距会自动计算
 */
@property (nonatomic, assign) NSInteger tagListCols;

/**
 *  添加标签
 *
 *  @param tagStr 标签文字
 */
- (void)addTag:(NSString *)tagStr;

/**
 *  添加多个标签
 *
 *  @param tagStrs 标签数组，数组存放（NSString *）
 */
- (void)addTags:(NSArray *)tagStrs;

/**
 *  删除标签
 *
 *  @param tagStr 标签文字
 */
- (void)deleteTag:(NSString *)tagStr;

/**
 *  点击标签，执行Block
 */
@property (nonatomic, strong) void(^clickTagBlock)(NSArray *valueArr);

/**
 重置
 */
- (void)reset;

@end

NS_ASSUME_NONNULL_END
