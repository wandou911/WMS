//
//  FTYInfoVertifyTools.m
//  RedWine
//
//  Created by Liufangfang on 2017/1/5.
//  Copyright © 2017年 HuiBangKe. All rights reserved.
//

#import "FTYInfoVertifyTools.h"

@implementation FTYInfoVertifyTools

+ (BOOL)isnilVertify:(NSString *)string{

    if ([@"" isEqualToString:string] || nil == string || 0 == string.length) {
        return YES;
    } else {
        return NO;
    }
}

+ (void)phoneNumberVertify:(NSString *)phoneNumber showAtView:(UIView *)view{

    if ([[self class] isnilVertify:phoneNumber]) {
        [[FTYToastView alloc] addTitle:@"请输入手机号～" addView:view];
    } else if (![FTYRegExpMatchTools checkTelNumber:phoneNumber]){
        [[FTYToastView alloc] addTitle:@"手机号码为11位～" addView:view];
    }
}


#pragma mark - Private Invoke Methods

@end
