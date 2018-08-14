//
//  TabMenuView.h
//  TabMenuView
//
//  Created by mac on 2018/8/14.
//  Copyright © 2018年 healifeGroup. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,IndicatoerLineStyle) {
    IndicatoerLineStyleAutoTitleWidth = 0,  ///自适应文本宽度
    IndicatoerLineStyleFixedWidth           ///自定义固定宽度
};


/*
 *  只是选择菜单 多标签选择 没有控制器 
 */
@interface TabMenuView : UIView

///这个属性要放大其他属性设置后再赋值
@property (nonatomic,strong) NSArray *titlesArr;


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
@property (nonatomic,assign) IndicatoerLineStyle lineStyle;
///指示线固定宽度（指示线的显示风格为IndicatoerLineStyleFixedWidth起作用）
@property (nonatomic,assign) CGFloat fixedIndicatorWidth;
///按钮选中颜色 指示器颜色
@property (nonatomic,strong) UIColor *selectedColor;
///按钮未选中颜色
@property (nonatomic,strong) UIColor *unselectedColor;
///按钮字体大小
@property (nonatomic,strong) UIFont *font;
///是否显示指示器
@property (nonatomic,assign) BOOL isHiddenIndicatorLine;
///是否显示底部分割线
@property (nonatomic,assign) BOOL isHiddenSeperatorLine;

@property (nonatomic,copy) void (^didClickedAtIndexBlock) (NSInteger index);

///方法调用需要在titlesArr赋值以后再调用
///滚动到某一个索引
- (void)scrollToIndex:(NSInteger)index;

@end
