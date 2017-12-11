//
//  AppDelegate.m
//  WMS
//
//  Created by wandou on 2017/8/22.
//  Copyright © 2017年 wandou. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self doLogin30min];
    DLog(@"ip:%@",WMS_BASE_URL);
    return YES;
}




- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)doLogin30min
{
    
    [NSTimer scheduledTimerWithTimeInterval:20*60*1.0 target:self selector:@selector(login:) userInfo:nil repeats:YES];
}

- (void)timerFireMethod:(NSTimer*)theTimer
{
    NSCalendar *cal = [NSCalendar currentCalendar];//定义一个NSCalendar对象
    NSDateComponents *endTime = [[NSDateComponents alloc] init];    //初始化目标时间...奥运时间好了
    [endTime setYear:2008];
    [endTime setMonth:8];
    [endTime setDay:8];
    [endTime setHour:8];
    [endTime setMinute:8];
    [endTime setSecond:8];
    
    NSDate *todate = [cal dateFromComponents:endTime]; //把目标时间装载入date
    
    
    NSDate *today = [NSDate date];    //得到当前时间
    
    //用来得到具体的时差
    unsigned int unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *d = [cal components:unitFlags fromDate:today toDate:todate options:0];
    
    NSLog(@"%d年%d月%d日%d时%d分%d秒",[d year],[d month], [d day], [d hour], [d minute], [d second]);
}

- (IBAction)login:(UIButton *)sender {
    //[[NSUserDefaults standardUserDefaults] setObject:@"login" forKey:@"login"];
    
        
        NSString *username = @"admin";
        NSString *passwd = @"123456";
        //passwd = [SLUtil md5:passwd];
        NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:username,@"account",passwd,@"password",@"",@"isScanned",nil];
        [HttpTask login:param sucessBlock:^(NSString *responseStr) {
            
            //DLog(@"返回数据:%@",responseStr);
            
            NSError *error;
            NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[responseStr dataUsingEncoding: NSUTF8StringEncoding] options:kNilOptions error:&error];
            NSNumber *statusNum = [dictionary objectForKey:@"success"];
            
            NSInteger status = [statusNum integerValue];
            NSString *msg = [dictionary objectForKey:@"msg"];
            NSDictionary *userInfo = [dictionary objectForKey:@"data"];
            
            
            if (status == 1) {
                DLog(@"登录成功");
                //[self loginSuccess:userInfo];
                
            }else{
                DLog(@"登录失败：%@",msg);
                if ([FTYInfoVertifyTools isnilVertify:msg]) {
                    msg = @"服务器异常，请重试！";
                }
                //[[FTYToastView alloc] addTitle:msg addView:self.view];
            }
        } failBlock:^(NSDictionary *errDict) {
            
        }];
        
    
    //[self dismissViewControllerAnimated:YES completion:nil];
    
}


@end
