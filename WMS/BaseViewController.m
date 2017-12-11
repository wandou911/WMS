//
//  BaseViewController.m
//  WMS
//
//  Created by wandou on 2017/8/30.
//  Copyright © 2017年 wandou. All rights reserved.
//

#import "BaseViewController.h"
#import "FTYColor.h"
#import "AppDelegate.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)viewWillAppear:(BOOL)animated {
    AppDelegate *delegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    delegate.presentingController = self;
}


- (void)clickButton:(id)sender {
    
    AppDelegate *delegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    if (delegate.presentingController)
    {
        UIViewController *vc =self.presentingViewController;
        
        if ( !vc.presentingViewController )   return;
        
        //循环获取present出来本视图控制器的视图控制器(简单一点理解就是上级视图控制器)，一直到最底层，然后在dismiss，那么就ok了！
        while (vc.presentingViewController)
        {
            vc = vc.presentingViewController;
        }
        
        [vc dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
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
