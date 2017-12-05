//
//  BaseNavigationController.m
//  横竖屏切换
//
//  Created by Harvey on 16/5/19.
//  Copyright © 2016年 Halley. All rights reserved.
//

#import "BaseNavigationController.h"

@implementation BaseNavigationController

#pragma mark - override method
- (void)viewDidLoad{
    [super viewDidLoad];
  
}

#pragma mark --- 这两个都需要写
- (BOOL)shouldAutorotate{
    return [self.topViewController shouldAutorotate];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return [self.topViewController supportedInterfaceOrientations];
}


@end
