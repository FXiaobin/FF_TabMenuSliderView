//
//  TabMenuView.m
//  TabMenuView
//
//  Created by mac on 2018/8/14.
//  Copyright © 2018年 healifeGroup. All rights reserved.
//

#import "TabMenuView.h"
#import <Masonry.h>


@interface TabMenuView ()<UIScrollViewDelegate>

@property (nonatomic,strong) UIScrollView *tabScrollView;

@property (nonatomic,strong) UIImageView *indicatorLine;

@property (nonatomic,strong) UIImageView *seperatorLine;

@property (nonatomic,strong) NSMutableArray *itemArr;

@end

@implementation TabMenuView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        [self addSubview:self.tabScrollView];
        [self.tabScrollView addSubview:self.indicatorLine];
        [self addSubview:self.seperatorLine];
        
        self.indicatorLine.hidden = self.isHiddenIndicatorLine;
        self.seperatorLine.hidden = self.isHiddenSeperatorLine;
        
        [self.tabScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self).insets(UIEdgeInsetsZero);
        }];
    
    }
    return self;
}

-(void)setTitlesArr:(NSArray *)titlesArr{
    _titlesArr = titlesArr;
    
    [self setupButtonItems];
    
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
  
    [self resetTabScrollViewFrameWithSender:sender];
    
    if (self.didClickedAtIndexBlock) {
        self.didClickedAtIndexBlock(index);
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
    if (self.lineStyle == IndicatoerLineStyleAutoTitleWidth) {
        NSString *title = self.titlesArr[index];
        CGFloat width = [title sizeWithAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15.0]}].width;
        
        [UIView animateWithDuration:0.2 animations:^{
            self.indicatorLine.frame = CGRectMake(CGRectGetMidX(sender.frame)-width/2.0, CGRectGetHeight(self.frame)-indicatorLineHeight, width, indicatorLineHeight);
        }];
        
    }else if (self.lineStyle == IndicatoerLineStyleFixedWidth){
        CGFloat fixedIndicatorWidth = self.fixedIndicatorWidth > 0.0 ? self.fixedIndicatorWidth : 20.0;
        [UIView animateWithDuration:0.2 animations:^{
            self.indicatorLine.frame = CGRectMake(CGRectGetMidX(sender.frame) - fixedIndicatorWidth/2.0, CGRectGetHeight(self.frame)-indicatorLineHeight, fixedIndicatorWidth, indicatorLineHeight);
        }];
    }
    
}

-(void)scrollToIndex:(NSInteger)index{
    [self updateCellSelectedStateWithIndex:index];
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

-(NSMutableArray *)itemArr{
    if (_itemArr == nil) {
        _itemArr = [NSMutableArray array];
    }
    return _itemArr;
}


@end
