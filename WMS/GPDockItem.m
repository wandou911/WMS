//
//  GPDockItem.m
//  WMS
//
//  Created by wandou on 2017/8/25.
//  Copyright © 2017年 wandou. All rights reserved.
//

#import "GPDockItem.h"

@implementation GPDockItem

-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
//    if (self) {
//        // Item分割线
//        UIImageView *splitLine = [[UIImageView  alloc] init];
//        splitLine.frame = CGRectMake(0, 0, GPDockItemWidth, 2);
//        splitLine.image = [UIImage imageNamed:@"separator_tabbar_item.png"];
//        [self addSubview:splitLine];
//    }
    return self;
    
}
//设置背景图片
-(void)setBackgroundImage:(NSString *)backgroundImage{
    
    _backgroundImage=backgroundImage;
    [self setImage:[UIImage imageNamed:backgroundImage] forState:UIControlStateNormal];
    
}
//设置选中图片
-(void)setSelectedImage:(NSString *)selectedImage{
    _selectedImage=selectedImage;
    [self setImage:[UIImage imageNamed:selectedImage] forState:UIControlStateDisabled];
    
}

-(void)setFrame:(CGRect)frame{
    //固定Item宽高
    frame.size=CGSizeMake(GPDockItemWidth, GPDockItemHeight);
    [super setFrame:frame];
}

//设置图片区域
-(CGRect)imageRectForContentRect:(CGRect)contentRect{
    CGFloat  width=contentRect.size.width;
    CGFloat  height= contentRect.size.height * 0.7;
    return CGRectMake(0, 10, width, height);
}
//设置文字区域
-(CGRect)titleRectForContentRect:(CGRect)contentRect{
    CGFloat  width=contentRect.size.width;
    CGFloat  height= contentRect.size.height * 0.3;
    CGFloat  position=contentRect.size.height*0.7;
    return CGRectMake(0, position, width, height);
}
//设置背景图片和选中图片
-(void)imageSetting:(NSString *)backgroundImage selectedImage:(NSString *)selectedImage{
    self.backgroundImage=backgroundImage;
    
    self.selectedImage=selectedImage;
}
//设置显示文字和图片在区域内的位置:
-(void)setTitle:(NSString *)title{
    [self setTitle:title forState:UIControlStateNormal];
    self.titleLabel.textAlignment=NSTextAlignmentCenter;
    self.titleLabel.font = [UIFont systemFontOfSize:15];
    //正常状态下是灰色
    [self setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    //不可点击的时候切换文字颜色
    [self setTitleColor:[UIColor orangeColor] forState:UIControlStateDisabled];
    //设置图片属性
    self.imageView.contentMode = UIViewContentModeCenter;
}

@end
