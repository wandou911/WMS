//
//  FTYInfoVertifyTools.h
//  RedWine
//
//  Created by Liufangfang on 2017/1/5.
//  Copyright © 2017年 HuiBangKe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FTYInfoVertifyTools : NSObject

/**
 验证OC对象是否为空

 @param string OC对象
 @return 是否为空指针
 */
+ (BOOL)isnilVertify:(NSString *)string;

+ (void)phoneNumberVertify:(NSString *)phoneNumber showAtView:(UIView *)view;

@end
