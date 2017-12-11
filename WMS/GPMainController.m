//
//  GPMainController.m
//  WMS
//
//  Created by wandou on 2017/8/25.
//  Copyright © 2017年 wandou. All rights reserved.
//

#import "GPMainController.h"



@interface GPMainController ()

@end

@implementation GPMainController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor blackColor];
    
    //加入侧边栏Dock
    GPDock *dock=[[GPDock alloc]initWithFrame:CGRectMake(0, 0,GPDockItemWidth, self.view.frame.size.height)];
    dock.dockDelegate=self;
    [self.view addSubview:dock];
    
}

-(void)switchMainByTabItem:(GPDock *)gpdock originalTab:(int)start destinationTab:(int)end{
    
    if ([self.delegate respondsToSelector:@selector(switchMainByTab:destinationTab:)]) {
        [self.delegate switchMainByTab:start destinationTab:end];
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
