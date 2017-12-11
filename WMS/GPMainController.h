//
//  GPMainController.h
//  WMS
//
//  Created by wandou on 2017/8/25.
//  Copyright © 2017年 wandou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GPDock.h"

@class GPMainController;
@protocol GPMainControllerDelegate <NSObject>

-(void)switchMainByTab:(int)start destinationTab:(int)end;

@end

@interface GPMainController : UIViewController<GPDockItemDelegate>

@property (nonatomic,weak) id<GPMainControllerDelegate> delegate;

@end
