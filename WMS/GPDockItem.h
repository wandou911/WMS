//
//  GPDockItem.h
//  WMS
//
//  Created by wandou on 2017/8/25.
//  Copyright © 2017年 wandou. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface GPDockItem : UIButton

-(void)imageSetting:(NSString *)backgroundImage selectedImage:(NSString *)selectedImage;

@property (nonatomic,strong) NSString *title;
//背景图片
@property (nonatomic,strong)  NSString  *backgroundImage;
//选中图片
@property (nonatomic,strong)  NSString  *selectedImage;



@end
