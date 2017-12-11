//
//  ViewController.h
//  WMS
//
//  Created by wandou on 2017/8/22.
//  Copyright © 2017年 wandou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GPMainController.h"
#import "StorageViewController.h"

@interface ViewController : UIViewController<UIPopoverPresentationControllerDelegate,GPMainControllerDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *leftItem;
@property (strong, nonatomic) StorageViewController *storageController;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@end

