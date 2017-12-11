//
//  GPDock.m
//  WMS
//
//  Created by wandou on 2017/8/25.
//  Copyright © 2017年 wandou. All rights reserved.
//

#import "GPDock.h"

@implementation GPDock

-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        //自动伸缩高度可伸缩，右边距可以伸缩
        self.autoresizingMask=UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleRightMargin;
        //设置背景图片
        self.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"Toolbar_bg_tabbar.png"]];
        [self addTabItems];
    }
    return self;
}

//添加Tab选项卡
- (void)addTabItems
{
    //首页
    [self addSingleTab:@"Toolbar_home.png" selectedImage:@"Toolbar_home_selected.png" weight:1 title:@"首页"];
    
    //团购
    [self addSingleTab:@"Toolbar_transfer.png" selectedImage:@"Toolbar_transfer_selected.png" weight:2 title:@"转储"];
    
    //排行榜
    [self addSingleTab:@"Toolbar_pan.png" selectedImage:@"Toolbar_pan_selected.png" weight:3 title:@"盘点"];
    
    // 个人中心
    [self addSingleTab:@"Toolbar_exit.png" selectedImage:@"Toolbar_exit_selected.png" weight:4 title:@"退出"];
    
}
/*
- (void)addSingleTab:(NSString *)backgroundImage selectedImage:(NSString *)selectedImage weight:(int)weight
{
    GPTabItem *tabItem=[[GPTabItem alloc]init];
    [tabItem setBackgroundImage:backgroundImage];
    [tabItem setSelectedImage:selectedImage];
    //设置位置
    tabItem.frame = CGRectMake(0, GPDockItemHeight * (weight+1), 0, 0);
    //设置选中触摸选中事件
    [tabItem addTarget:self action:@selector(tabItemTouchEvent:) forControlEvents:UIControlEventTouchDown];
    tabItem.tag = weight - 1;
    [self addSubview:tabItem];
    
}*/



- (void)addSingleTab:(NSString *)backgroundImage selectedImage:(NSString *)selectedImage weight:(int)weight title:(NSString *)title
{
    GPTabItem *tabItem=[[GPTabItem alloc]init];
    [tabItem setBackgroundImage:backgroundImage];
    [tabItem setSelectedImage:selectedImage];
    [tabItem setTitle:title];
    //设置位置
    tabItem.frame = CGRectMake(0, GPDockItemHeight * (weight+1), 0, 0);
    //设置选中触摸选中事件
    [tabItem addTarget:self action:@selector(tabItemTouchEvent:) forControlEvents:UIControlEventTouchDown];
    tabItem.tag = weight - 1;
    [self addSubview:tabItem];
    
}
//设置触摸事件
- (void)tabItemTouchEvent:(GPTabItem *)tabItem
{
    
    if ([self.dockDelegate respondsToSelector:@selector(switchMainByTabItem:originalTab:destinationTab:)]) {
        [self.dockDelegate switchMainByTabItem:self originalTab:selectedTabItem.tag destinationTab:tabItem.tag];
    }
    selectedTabItem.enabled=YES;
    tabItem.enabled = NO;
    //将当前选中的赋值
    selectedTabItem =tabItem;
}



@end
