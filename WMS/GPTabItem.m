//
//  GPTabItem.m
//  WMS
//
//  Created by wandou on 2017/8/25.
//  Copyright © 2017年 wandou. All rights reserved.
//

#import "GPTabItem.h"

@implementation GPTabItem

-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        // 设置选中时背景图片
        [self setBackgroundImage:[UIImage imageNamed:@"bg_tabbar_item.png"] forState:UIControlStateDisabled];
    }
    return self;
}

@end
