//
//  GPBottomItem.m
//  WMS
//
//  Created by wandou on 2017/8/28.
//  Copyright © 2017年 wandou. All rights reserved.
//

#import "GPBottomItem.h"

@implementation GPBottomItem

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        // 自动伸缩
        self.autoresizingMask=UIViewAutoresizingFlexibleTopMargin;
    }
    return self;
}


@end
