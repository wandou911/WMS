//
//  LoginViewController.m
//  WMS
//
//  Created by wandou on 2017/8/22.
//  Copyright © 2017年 wandou. All rights reserved.
//

#import "LoginViewController.h"
#import "WMSUser.h"
#import "FTYToastView.h"
#import "FTYInfoVertifyTools.h"


@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIImageView *imageViewName=[[UIImageView alloc]initWithFrame:CGRectMake(100, 0, 14, 14)];
    imageViewName.image=[UIImage imageNamed:@"login_user"];
    _nameField.leftView=imageViewName;
    _nameField.leftViewMode=UITextFieldViewModeAlways; //此处用来设置leftview现实时机
    _nameField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    
    UIImageView *imageViewPwd=[[UIImageView alloc]initWithFrame:CGRectMake(20, 0, 14, 14)];
    imageViewPwd.image=[UIImage imageNamed:@"login_pwd"];
    _passwdField.leftView=imageViewPwd;
    _passwdField.leftViewMode=UITextFieldViewModeAlways; //此处用来设置leftview现实时机
    _passwdField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    
}
- (IBAction)login:(UIButton *)sender {
    //[[NSUserDefaults standardUserDefaults] setObject:@"login" forKey:@"login"];
    
    if (self.nameField.text.length > 0 && self.passwdField.text.length > 0) {
        
        NSString *username = self.nameField.text;
        NSString *passwd = self.passwdField.text;
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
                [self loginSuccess:userInfo];
            
            }else{
                DLog(@"登录失败：%@",msg);
                if ([FTYInfoVertifyTools isnilVertify:msg]) {
                    msg = @"服务器异常，请重试！";
                }
                [[FTYToastView alloc] addTitle:msg addView:self.view];
            }
        } failBlock:^(NSDictionary *errDict) {
            
        }];
        
    }
    //[self dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark - Private Invoke Methods

- (void)loginSuccess:(NSDictionary *)userInfo{
    
    WMSUser *user = [WMSUser sharedUser];
    NSString *lcCode = [userInfo objectForKey:@"lcCode"];
    DLog(@"lcCode:%@",lcCode);
    [user writeUserIsLogin:YES];
    [user writeUserCode:[userInfo objectForKey:@"code"]];
    [user writeUserLcCode:[userInfo objectForKey:@"lcCode"]];
    [user writeUserName:[userInfo objectForKey:@"name"]];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
