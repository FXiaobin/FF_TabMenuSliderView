//
//  ViewController.m
//  TabMenuView
//
//  Created by mac on 2018/8/14.
//  Copyright © 2018年 healifeGroup. All rights reserved.
//

#import "ViewController.h"
#import "TabMenuView.h"
#import "TabMenuSliderView.h"
#import "TestViewController.h"

@interface ViewController ()


@property (nonatomic,strong) TabMenuView *me;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSArray *titles = @[@"发送",@"的",@"订单",@"放松放松",@"滚动",@"发过的",@"规划法规",@"供电公司地方",@"发过的",@"规划法规",@"供电公司地方"];
    
    NSMutableArray *vcs = [NSMutableArray array];
    for (int i = 0; i < titles.count; i++) {
        TestViewController *vc = [TestViewController new];
        [vcs addObject:vc];
    }
    
    TabMenuSliderView *tab = [[TabMenuSliderView alloc] initWithFrame:CGRectMake(0, 66, self.view.bounds.size.width, 44) titles:titles controllers:vcs];
    tab.lazyLoad = YES;
    tab.lineStyle = IndicatoerLineStyleFixedWidth;
    tab.fixedIndicatorWidth = 30;
    tab.currentIndex = 3;
    
    tab.selectedColor = [UIColor redColor];
    tab.unselectedColor = [UIColor darkGrayColor];
    
    tab.itemSpace = 15;
    tab.bodyFrame = CGRectMake(0, 110, self.view.bounds.size.width, self.view.bounds.size.height - 65);
    
    tab.didSelectedAtIndexBlock = ^(NSInteger index) {
        NSLog(@"------ scrol index = %ld",index);
    };
    
    [self.view addSubview:tab];
    
    [tab scrollToIndex:4];
    
    
    
    TabMenuView *tab1 = [[TabMenuView alloc] initWithFrame:CGRectMake(0, 20, self.view.bounds.size.width, 40)];
    self.me = tab1;
    
    tab1.selectedColor = [UIColor purpleColor];
    tab1.unselectedColor = [UIColor blackColor];
    
    tab1.titlesArr = titles;
    
    [tab1 scrollToIndex:4];
    
    //tab.isAverage = YES;
    //tab.isHiddenIndicatorLine = YES;
    
    //tab.isFixed = YES;
    //tab.fixedWidth = 80;
    
    //[tab scrollToIndex:4];
    
    [self.view addSubview:tab1];
   
    tab1.didClickedAtIndexBlock = ^(NSInteger index) {
        NSLog(@"------ scrol index = %ld",index);
    };
    


}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
