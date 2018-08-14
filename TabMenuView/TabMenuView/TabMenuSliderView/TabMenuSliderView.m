//
//  TabMenuSliderView.m
//  TabMenuView
//
//  Created by mac on 2018/8/14.
//  Copyright © 2018年 healifeGroup. All rights reserved.
//

#import "TabMenuSliderView.h"

#import <Masonry.h>


@interface TabMenuSliderView ()<UIScrollViewDelegate>

@property (nonatomic,strong) UIScrollView *tabScrollView;

@property (nonatomic,strong) UIScrollView *bodyScrollView;

@property (nonatomic,strong) UIImageView *indicatorLine;

@property (nonatomic,strong) UIImageView *seperatorLine;

@property (nonatomic,strong) NSArray *titlesArr;

@property (nonatomic,strong) NSArray *controllers;

@property (nonatomic,strong) NSMutableArray *itemArr;




@end

@implementation TabMenuSliderView


-(instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles controllers:(NSArray *)controllers{
    if (self = [super initWithFrame:frame]) {
        
        _titlesArr = titles;
        _controllers = controllers;
        
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self addSubview:self.tabScrollView];
    [self.tabScrollView addSubview:self.indicatorLine];
    [self addSubview:self.seperatorLine];
    
    self.indicatorLine.hidden = self.isHiddenIndicatorLine;
    self.seperatorLine.hidden = self.isHiddenSeperatorLine;
    
    [self.tabScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).insets(UIEdgeInsetsZero);
    }];
    
    [self setupButtonItems];
    
    [self setupBodyScrollView];
    [self loadBodyContentAtIndex:_currentIndex];
    
    _bodyScrollView.contentSize = CGSizeMake(_bodyScrollView.frame.size.width*_controllers.count, _bodyScrollView.frame.size.height);
    [_bodyScrollView setContentOffset:CGPointMake(_bodyScrollView.frame.size.width*_currentIndex, 0) animated:NO];
    
    
    [self updateCellSelectedStateWithIndex:self.currentIndex];
    
}

- (void)setupButtonItems{
    
    for (UIButton *item in self.itemArr) {
        [item removeFromSuperview];
    }
    [self.itemArr removeAllObjects];
    
    
    CGFloat originX = 0;
    
    for (int i = 0; i < self.titlesArr.count; i++) {
        UIButton *item = [UIButton new];
        UIColor *selectedColor = _selectedColor ? _selectedColor : [UIColor orangeColor];
        UIColor *unselectedColor = _unselectedColor ? _unselectedColor : [UIColor blackColor];
        [item setTitleColor:selectedColor forState:UIControlStateSelected];
        [item setTitleColor:unselectedColor forState:UIControlStateNormal];
        item.titleLabel.textColor = unselectedColor;
        self.indicatorLine.backgroundColor = selectedColor;
        
        item.reversesTitleShadowWhenHighlighted = YES;
        UIFont *font = _font ? _font : [UIFont systemFontOfSize:14.0];
        item.titleLabel.font = font;
        [item setTitle:_titlesArr[i] forState:UIControlStateNormal];
        [item addTarget:self action:@selector(itemClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        CGFloat itemSpace = _itemSpace > 0.0 ? _itemSpace : 15.0;
        
        if (self.isAverage) {
            ///平分
            CGFloat w = self.tabScrollView.bounds.size.width / self.titlesArr.count;
            item.frame = CGRectMake(originX, 0, w, self.frame.size.height);
            
        }else if (self.isFixed){
            ///固定宽度
            CGFloat w = _fixedWidth > 0.0 ? _fixedWidth : 50.0;
            item.frame = CGRectMake(originX, 0, w + itemSpace * 2, self.frame.size.height);
            
        }else {
            ///自适应宽度
            CGSize size = [_titlesArr[i] sizeWithAttributes:@{NSFontAttributeName:font}];
            item.frame = CGRectMake(originX, 0, size.width + itemSpace * 2, self.frame.size.height);
        }
        
        
        originX = CGRectGetMaxX(item.frame);
        [self.itemArr addObject:item];
        [self.tabScrollView addSubview:item];
        item.selected = i == _currentIndex;
        
    }
    
    _tabScrollView.contentSize = CGSizeMake(originX, self.frame.size.height);
    
}

- (void)itemClicked:(UIButton *)sender{
    
    NSInteger index = [self.itemArr indexOfObject:sender];
    
    [self updateCellSelectedStateWithIndex:index];
    
    if (self.lazyLoad) {
        [self loadBodyContentAtIndex:index];
    }
}

-(void)updateCellSelectedStateWithIndex:(NSInteger)index{
    if (self.itemArr.count == 0) {
        return;
    }
    
    ///之前选择的
    UIButton *lastBtn = [self.itemArr objectAtIndex:_currentIndex];
    lastBtn.selected = NO;
    
    ///当前选择的
    UIButton *sender = self.itemArr[index];
    sender.selected = YES;
    [self updateIndicatorLineWithIndex:index];
    
    
    _currentIndex = index;
    
    [_bodyScrollView setContentOffset:CGPointMake(_bodyScrollView.frame.size.width*_currentIndex, 0) animated:YES];
    
    [self resetTabScrollViewFrameWithSender:sender];
    
    if (self.didSelectedAtIndexBlock) {
        self.didSelectedAtIndexBlock(index);
    }
}

/**
 * 修正tabScrollView的位置 - 居中
 */
- (void)resetTabScrollViewFrameWithSender:(UIButton *)sender
{
    if (self.isAverage) {
        return;
    }
    
    CGFloat tab_width = self.tabScrollView.frame.size.width;
    
    CGFloat offest = sender.center.x - tab_width / 2.0;
    if (offest < 0) {
        offest = 0;
    }
    
    CGFloat maxOffset = self.tabScrollView.contentSize.width - tab_width;
    if (maxOffset < 0) {
        maxOffset = 0;
    }
    
    if (offest > maxOffset) {
        offest = maxOffset;
    }
    [self.tabScrollView setContentOffset:CGPointMake(offest, 0) animated:YES];
}

-(void)updateIndicatorLineWithIndex:(NSInteger)index{
    
    CGFloat indicatorLineHeight = self.indicatorLineHeight > 0.0 ? self.indicatorLineHeight : 2.0;
    
    UIButton *sender = self.itemArr[index];
    if (self.lineStyle == TabIndicatoerLineStyleAutoTitleWidth) {
        NSString *title = self.titlesArr[index];
        CGFloat width = [title sizeWithAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15.0]}].width;
        
        [UIView animateWithDuration:0.2 animations:^{
            self.indicatorLine.frame = CGRectMake(CGRectGetMidX(sender.frame)-width/2.0, CGRectGetHeight(self.frame)-indicatorLineHeight, width, indicatorLineHeight);
        }];
        
    }else if (self.lineStyle == TabIndicatoerLineStyleFixedWidth){
        CGFloat fixedIndicatorWidth = self.fixedIndicatorWidth > 0.0 ? self.fixedIndicatorWidth : 20.0;
        [UIView animateWithDuration:0.2 animations:^{
            self.indicatorLine.frame = CGRectMake(CGRectGetMidX(sender.frame) - fixedIndicatorWidth/2.0, CGRectGetHeight(self.frame)-indicatorLineHeight, fixedIndicatorWidth, indicatorLineHeight);
        }];
    }
    
}

-(void)scrollToIndex:(NSInteger)index{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self loadBodyContentAtIndex:index];
        [self updateCellSelectedStateWithIndex:index];
    });
}

/**
 添加bodyScorllView视图
 */
- (void)setupBodyScrollView{
    if (self.bodySuperView == nil) {
        [self.superview addSubview:self.bodyScrollView];
    }
    else{
        [self.bodySuperView addSubview:self.bodyScrollView];
    }
}

//加载子控制器
- (void)loadBodyContentAtIndex:(NSInteger)index{
    if (_lazyLoad) {
        UIViewController *vc = _controllers[index];
        if (!vc.viewLoaded) {
            vc.view.frame = _bodyScrollView.bounds;
            [self.targetVC addChildViewController:vc];
            vc.view.center = CGPointMake(CGRectGetWidth(_bodyScrollView.frame)*(index+0.5), _bodyScrollView.frame.size.height/2);
            [_bodyScrollView addSubview:vc.view];
        }
        
    }else{
        for (int i = 0; i < _controllers.count; i++) {
            UIViewController *vc = _controllers[i];
            [self.targetVC addChildViewController:vc];
            vc.view.frame = _bodyScrollView.bounds;
            vc.view.center = CGPointMake(CGRectGetWidth(_bodyScrollView.frame)*(i+0.5), _bodyScrollView.frame.size.height/2);
            [_bodyScrollView addSubview:vc.view];
        }
    }
}

#pragma mark setter
- (void)setBodyFrame:(CGRect)bodyFrame{
    self.bodyScrollView.frame = bodyFrame;
    self.bodyScrollView.contentSize = CGSizeMake(bodyFrame.size.width*self.controllers.count, bodyFrame.size.height);
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView == self.bodyScrollView) {
        NSInteger index = scrollView.contentOffset.x / scrollView.bounds.size.width;
        
        [self updateCellSelectedStateWithIndex:index];
        
        if (self.lazyLoad) {
            [self loadBodyContentAtIndex:index];
        }
    }
}

-(UIImageView *)indicatorLine{
    if (_indicatorLine == nil) {
        _indicatorLine = [UIImageView new];
        _indicatorLine.backgroundColor = [UIColor orangeColor];
        
        CGFloat indicatorLineHeight = self.indicatorLineHeight > 0.0 ? self.indicatorLineHeight : 2.0;
        _indicatorLine.frame = CGRectMake(0, CGRectGetHeight(self.frame) - indicatorLineHeight, 0.0, indicatorLineHeight);
    }
    return _indicatorLine;
}

-(UIImageView *)seperatorLine{
    if (_seperatorLine == nil) {
        _seperatorLine = [UIImageView new];
        _seperatorLine.backgroundColor = [UIColor lightGrayColor];
        _seperatorLine.frame = CGRectMake(0, CGRectGetHeight(self.tabScrollView.frame) - 0.5, CGRectGetWidth(self.tabScrollView.frame), 0.5);
    }
    return _seperatorLine;
}

- (UIScrollView *)tabScrollView{
    if (!_tabScrollView) {
        _tabScrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
        _tabScrollView.showsVerticalScrollIndicator = NO;
        _tabScrollView.showsHorizontalScrollIndicator = NO;
        _tabScrollView.backgroundColor = [UIColor clearColor];
    }
    return _tabScrollView;
}

- (UIScrollView *)bodyScrollView{
    if (_bodyScrollView == nil) {
        _bodyScrollView = [[UIScrollView alloc]initWithFrame:CGRectZero];
        _bodyScrollView.showsVerticalScrollIndicator = NO;
        _bodyScrollView.showsHorizontalScrollIndicator = NO;
        _bodyScrollView.bounces = NO;
        _bodyScrollView.delegate = self;
        _bodyScrollView.pagingEnabled = YES;
    }
    return _bodyScrollView;
}

-(NSMutableArray *)itemArr{
    if (_itemArr == nil) {
        _itemArr = [NSMutableArray array];
    }
    return _itemArr;
}



@end
