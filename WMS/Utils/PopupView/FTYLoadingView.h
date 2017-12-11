//
//  FTYLoadingView.h
//  RedWine
//
//  Created by Liufangfang on 2016/12/26.
//  Copyright © 2016年 HuiBangKe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FTYLoadingView : UIView{
    
    UIView *loadingView;
    UIActivityIndicatorView *indicatorView;
    UILabel *titleLabel;
    UIImageView *animationImageView;
}

+ (id)shareInstance;
- (void)addLoadingViewForView:(UIView *)view withTitle:(NSString *)title;
- (void)removeLoadingView;

@end
