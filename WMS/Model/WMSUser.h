//
//  WMSUser.h
//  WMS
//
//  Created by wandou on 2017/11/7.
//  Copyright © 2017年 wandou. All rights reserved.
//

#import <Foundation/Foundation.h>

#define USERSUCCESSFUL @"UserSuccessful"
#define USERCODE @"code"
#define USERLCCODE @"lcCode"
#define USERNAME @"name"

@interface WMSUser : NSObject

@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *isScanned;//1或为空需要密码 0为不需要


@property (nonatomic, strong) NSString *lcCode;//物流中心
@property (nonatomic, strong) NSString *code;//用户编码
@property (nonatomic, copy) NSMutableArray *warehourseList;//封装仓库信息list

+ (instancetype)sharedUser;

- (void)writeUserIsLogin:(BOOL)isLogin;
- (void)writeUserCode:(NSString *)userCode;
- (void)writeUserLcCode:(NSString *)lcCode;
- (void)writeUserName:(NSString *)userName;

- (BOOL)isUserLogin;
- (NSString *)userCode;
- (NSString *)userLcCode;
- (NSString *)userName;

- (void)userLogOut;

@end
