//
//  JSTextField.m
//  WMS
//
//  Created by wandou on 2017/8/24.
//  Copyright © 2017年 wandou. All rights reserved.
//

#import "JSTextField.h"

@implementation JSTextField

-(id)initWithFrame:(CGRect)frame drawingLeft:(UIImageView *)icon{
    self = [super initWithFrame:frame];
    if (self) {
        self.leftView = icon;
        self.leftViewMode = UITextFieldViewModeAlways;
    }
    return self;
}

-(CGRect)leftViewRectForBounds:(CGRect)bounds{
    CGRect iconRect = [super leftViewRectForBounds:bounds];
    iconRect.origin.x += 10;// 右偏10
    return iconRect;
}

@end
