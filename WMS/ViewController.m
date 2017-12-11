//
//  ViewController.m
//  WMS
//
//  Created by wandou on 2017/8/22.
//  Copyright © 2017年 wandou. All rights reserved.
//

#import "ViewController.h"
#import "LoginViewController.h"
#import "GPMainController.h"
#import "StorageViewController.h"
#import "TransferViewController.h"
#import "WMSUser.h"


@interface ViewController ()
{
    GPMainController *mainController;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //NSString *login = [[NSUserDefaults standardUserDefaults] objectForKey:@"login"];
    BOOL login = [[WMSUser sharedUser] isUserLogin];
    if (!login) {
        
        UIStoryboard *board = [UIStoryboard storyboardWithName: @"Main" bundle: nil];
        
        LoginViewController *loginController = [board instantiateViewControllerWithIdentifier: @"LoginViewController"];
        
        [self.navigationController presentViewController:loginController animated:YES completion:nil];
        
    }
}

- (IBAction)logout:(id)sender {
    
    [[WMSUser sharedUser] userLogOut];
    
    UIStoryboard *board = [UIStoryboard storyboardWithName: @"Main" bundle: nil];
    
    LoginViewController *loginController = [board instantiateViewControllerWithIdentifier: @"LoginViewController"];
    
    [self.navigationController presentViewController:loginController animated:YES completion:nil];
}

- (IBAction)pageControll:(UISwipeGestureRecognizer *)sender {
    
    UIStoryboard *board = [UIStoryboard storyboardWithName: @"Main" bundle: nil];
    
    if (!self.storageController) {
        self.storageController = (StorageViewController *)[board instantiateViewControllerWithIdentifier: @"StorageLocationViewController"];
        
        CGRect originFrame = self.storageController.view.frame;
        self.storageController.view.frame = CGRectMake(originFrame.origin.x, originFrame.origin.y, originFrame.size.width, originFrame.size.height-20);
        
        self.storageController.pageControllView = ViewTypeStorageView;
    }
   
    if (sender.direction == UISwipeGestureRecognizerDirectionRight) {
        
        [self.view addSubview:self.storageController.view];
        //self.storageController.view.backgroundColor = [UIColor redColor];
        self.pageControl.currentPage = 1;
        
    }else if (sender.direction == UISwipeGestureRecognizerDirectionLeft){
        [self.storageController.view removeFromSuperview];
        self.pageControl.currentPage = 0;
    }
    
    //self.view.backgroundColor = [UIColor greenColor];
}

- (IBAction)showDock:(UIBarButtonItem *)sender {
    
    
    mainController = [[GPMainController alloc] init];
    [mainController setModalPresentationStyle:UIModalPresentationPopover];
    mainController.delegate = self;
    [self.navigationController presentViewController:mainController animated:YES completion:nil];
    mainController.popoverPresentationController.barButtonItem = sender;
    mainController.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionUp;
    mainController.popoverPresentationController.delegate = self;
    mainController.popoverPresentationController.backgroundColor = [UIColor blackColor];
    mainController.preferredContentSize = CGSizeMake(GPDockItemWidth, self.view.frame.size.height);
    
}


- (void)switchMainByTab:(int)start destinationTab:(int)end{
    [mainController dismissViewControllerAnimated:YES completion:nil];
    
    switch (end) {
        case 0:
            //self.view.backgroundColor=[UIColor blackColor];
        {
            StorageViewController *detailControllrer =
            [[StorageViewController alloc] init];
            UIStoryboard *board = [UIStoryboard storyboardWithName: @"Main" bundle: nil];
            
            detailControllrer = [board instantiateViewControllerWithIdentifier: @"StorageViewController"];
            
            //[detailControllrer setModalPresentationStyle:UIModalPresentationPageSheet];
            //[self presentModalViewController:detailControllrer animated:YES];
            //self.view = detailControllrer.view;
            //[self.navigationController presentViewController:detailControllrer animated:YES completion:nil];
            [self.view addSubview:detailControllrer.view];
        }
            break;
        case 1:
            //self.view.backgroundColor=[UIColor blueColor];
        {
            TransferViewController *detailControllrer =
            [[TransferViewController alloc] init];
            UIStoryboard *board = [UIStoryboard storyboardWithName: @"Main" bundle: nil];
            
            detailControllrer = [board instantiateViewControllerWithIdentifier: @"NavTransferViewController"];
            
            //[detailControllrer setModalPresentationStyle:UIModalPresentationPageSheet];
            //[self presentModalViewController:detailControllrer animated:YES];
            //[self.navigationController presentViewController:detailControllrer animated:YES completion:nil];
            [self.view addSubview:detailControllrer.view];
        }
            break;
        case 2:
            //self.view.backgroundColor=[UIColor redColor];
        {
            
        }
            break;
        case 3:
            //self.view.backgroundColor=[UIColor purpleColor];
        {
            
        }
            break;
        default:
            break;
    }
}


//代理方法 ,点击即可dismiss掉每次init产生的PopViewController
-(UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller{
    return UIModalPresentationNone;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
