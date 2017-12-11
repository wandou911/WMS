//
//  FTYToastView.h
//  RedWine
//
//  Created by Liufangfang on 2016/12/26.
//  Copyright © 2016年 HuiBangKe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface FTYToastView : NSObject{
    
    UILabel *titleLabel;
}

+(id)shareInstance;
//释放当前的对象
+(void)releaseSingle;
-(void)addTitle:(NSString *)title addView:(UIView *)view;
-(void)addKeyboardTitle:(NSString *)title addView:(UIView *)view;

@end
