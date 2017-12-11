//
//  WMSettingViewController.m
//  WMS
//
//  Created by wandou on 08/12/2017.
//  Copyright © 2017 wandou. All rights reserved.
//

#import "WMSettingViewController.h"

@interface WMSettingViewController ()

@end

@implementation WMSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSString *ipStr = [[NSUserDefaults standardUserDefaults] objectForKey:WMS_IP];
    NSString *portStr = [[NSUserDefaults standardUserDefaults] objectForKey:WMMS_PORT];
    if(ipStr){
        self.ipAddresField.text = ipStr;
    }else{
        self.ipAddresField.text = @"10.229.255.31";
    }
    if (portStr) {
        self.portField.text = portStr;
    }else{
        self.portField.text = @"8250";
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ================= 自定义方法 =================
-(IBAction)saveBtn:(id)sender
{
    NSString *ip = self.ipAddresField.text;
    NSString *port = self.portField.text;
    
    if ([FTYInfoVertifyTools isnilVertify:ip]) {
        [[FTYToastView alloc] addTitle:@"ip地址不能为空" addView:self.view];
    }else if ([FTYInfoVertifyTools isnilVertify:port]){
        [[FTYToastView alloc] addTitle:@"端口号不能为空" addView:self.view];
    }else{
        NSString *ipAddress = [NSString stringWithFormat:@"http://%@:%@/twms-hand/api",ip,port];
        [[NSUserDefaults standardUserDefaults] setObject:ipAddress forKey:WMS_IP_ADDRESS];
        [[FTYToastView alloc] addTitle:@"保存成功" addView:self.view];
        DLog(@"ipAddress:%@",ipAddress);
    }
}

-(IBAction)goBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
