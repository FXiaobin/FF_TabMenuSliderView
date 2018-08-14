//
//  TabMenuSliderView.h
//  TabMenuView
//
//  Created by mac on 2018/8/14.
//  Copyright © 2018年 healifeGroup. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,TabIndicatoerLineStyle) {
    TabIndicatoerLineStyleAutoTitleWidth = 0,  ///自适应文本宽度
    TabIndicatoerLineStyleFixedWidth           ///自定义固定宽度
};

/*
 *  选择菜单和控制器都有 多标签选择控制器
 */

@interface TabMenuSliderView : UIView

///是否平分屏幕宽度
@property (nonatomic,assign) BOOL isAverage;
///是否固定宽度
@property (nonatomic,assign) BOOL isFixed;
///按钮固定宽度
@property (nonatomic,assign) CGFloat fixedWidth;
///当前选中的索引
@property (nonatomic,assign) NSInteger currentIndex;
///按钮之间的间距的一半
@property (nonatomic,assign) CGFloat itemSpace;
///指示线的高度
@property (nonatomic,assign) CGFloat indicatorLineHeight;
///指示线的显示风格
@property (nonatomic,assign) TabIndicatoerLineStyle lineStyle;
///指示线固定宽度（指示线的显示风格为TabIndicatoerLineStyleFixedWidth起作用）
@property (nonatomic,assign) CGFloat fixedIndicatorWidth;
///按钮选中颜色 指示器颜色
@property (nonatomic,strong) UIColor *selectedColor;
///按钮未选中颜色
@property (nonatomic,strong) UIColor *unselectedColor;
///按钮字体大小
@property (nonatomic,strong) UIFont *font;
///控制push
@property (nonatomic,weak) UIViewController *targetVC;
///懒加载控制器
@property (nonatomic,assign) BOOL lazyLoad;
///承载子控制器的滚动视图的大小
@property (nonatomic,assign) CGRect bodyFrame;
///承载子控制器的滚动视图的父视图 默认为菜单按钮的父视图
@property (nonatomic,strong) UIView *bodySuperView;
///是否显示指示器
@property (nonatomic,assign) BOOL isHiddenIndicatorLine;
///是否显示底部分割线
@property (nonatomic,assign) BOOL isHiddenSeperatorLine;

@property (nonatomic,copy) void (^didSelectedAtIndexBlock) (NSInteger index);

-(instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles controllers:(NSArray *)controllers;

///滚动到某一个索引 (需要在初始化之后调用)
- (void)scrollToIndex:(NSInteger)index;

@end
