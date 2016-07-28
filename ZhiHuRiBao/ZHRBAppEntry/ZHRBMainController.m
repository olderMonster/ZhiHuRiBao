//
//  ZHRBMainController.m
//  ZhiHuRiBao
//
//  Created by kehwa on 16/7/28.
//  Copyright © 2016年 kehwa. All rights reserved.
//

#import "ZHRBMainController.h"

#import "OMNavigationController.h"
#import "ZHRBReportsController.h"
#import "ZHRBThemeController.h"

@interface ZHRBMainController ()

@property (nonatomic , strong)OMNavigationController *reportsVC;
@property (nonatomic , strong)ZHRBThemeController *themeVC;

@end

@implementation ZHRBMainController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.reportsVC.view];
    [self.view addSubview:self.themeVC.view];
    
    
}


- (OMNavigationController *)reportsVC{
    if (_reportsVC == nil) {
        ZHRBReportsController *vc = [[ZHRBReportsController alloc]init];
        _reportsVC = [[OMNavigationController alloc]initWithRootViewController:vc];
    }
    return _reportsVC;
}

- (ZHRBThemeController *)themeVC{
    if (_themeVC == nil) {
        _themeVC = [[ZHRBThemeController alloc]init];
    }
    return _themeVC;
}


@end
