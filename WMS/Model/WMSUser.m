//
//  WMSUser.m
//  WMS
//
//  Created by wandou on 2017/11/7.
//  Copyright © 2017年 wandou. All rights reserved.
//

#import "WMSUser.h"

@implementation WMSUser

#pragma mark - User Manager

static WMSUser * manager = nil;

+ (instancetype)sharedUser{
    
    //3.创建当前类的对象
    if (manager == nil) {
        manager = [[WMSUser alloc]init];
    }
    return manager;
}

- (NSUserDefaults *)defaults{
    
    return [NSUserDefaults standardUserDefaults];
}

#pragma mark - UserInfo Write

/**
 当前用户是否登录状态
 */
- (void)writeUserIsLogin:(BOOL)isLogin {
    
    [[self defaults] setBool:isLogin forKey:USERSUCCESSFUL];
    [[self defaults] synchronize];
}

/**
 当前登录的用户编码
 */
- (void)writeUserCode:(NSString *)userCode {
    
    [[self defaults] setObject:userCode forKey:USERCODE];
    [self synchronize];
}

/**
 当前登录用户物流中心代码
 */
- (void)writeUserLcCode:(NSString *)lcCode{
    
    [[self defaults] setObject:lcCode forKey:USERLCCODE];
    [self synchronize];
}



- (void)writeUserName:(NSString *)userName{
    
    [[self defaults] setObject:userName forKey:USERNAME];
    [self synchronize];
}



- (void)synchronize{
    [[self defaults] synchronize];
}




#pragma mark - UserInfo Read

/**
 当前用户是否登录状态
 */
- (BOOL)isUserLogin {
    
    return [[self defaults] boolForKey:USERSUCCESSFUL];
}


/**
 当前登录的用户身份Id(后台id)
 */
- (NSString *)userCode {
    NSString * userId = [[self defaults] objectForKey:USERCODE];
    if (userId == nil) {
        return @"";
    }
    return userId;
}

-(NSString *)userLcCode {
    return [[self defaults] objectForKey:USERLCCODE];
}


- (NSString *)userName{
    return [[self defaults] objectForKey:USERNAME];
}


#pragma mark - User LoginOut

/**
 退出登录
 */
- (void)userLogOut {
    
    [[self defaults] setBool:NO forKey:USERSUCCESSFUL];
    [[self defaults] setObject:@"" forKey:USERCODE];
    [[self defaults] setObject:@"" forKey:USERLCCODE];
    [[self defaults] setObject:@"" forKey:USERNAME];
    
    [[self defaults] synchronize];
}

@end
