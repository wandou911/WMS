//
//  FTYRegExpMatchTools.h
//  RedWine
//
//  Created by Liufangfang on 2017/1/4.
//  Copyright © 2017年 HuiBangKe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FTYRegExpMatchTools : NSObject

//正则匹配手机号
+ (BOOL)checkTelNumber:(NSString *) telNumber;
//正则匹配用户邮箱
+ (BOOL)isValidateEmail:(NSString *) email;
//正则匹配用户密码6-18位数字和字母组合
+ (BOOL)checkPassword:(NSString *) password;
//正则匹配用户姓名,20位的中文或英文
+ (BOOL)checkUserName:(NSString *) userName;
//正则匹配用户身份证号
+ (BOOL)checkUserIdCard:(NSString *)idCard;
//正则匹配URL
+ (BOOL)checkURL:(NSString *) url;

@end
