//
//  NavigationViewController.m
//  YRJJApp
//
//  Created by luwelong on 14/12/2.
//  Copyright (c) 2014年 luwelong. All rights reserved.
//

#import "OMNavigationController.h"

@interface OMNavigationController ()

@end

@implementation OMNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //获得所有导航栏外观的设置权限
    UINavigationBar *bar = [UINavigationBar appearance];
    //设置属性
    NSDictionary *barAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont systemFontOfSize:20],NSFontAttributeName, nil];
    
    //设置所有导航栏文字
    [bar setTitleTextAttributes:barAttributes];
    [bar setBarTintColor:[UIColor colorWithRed:56/255.0 green:138/255.0 blue:211/255.0 alpha:1.0]];
    
    __weak typeof (self) weakSelf = self;
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.delegate = weakSelf;
    }
    
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    [super pushViewController:viewController animated:animated];
    
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.enabled = NO;
    }
    
    //重写返回按钮
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 30, 30);
    //背景图片
    [backBtn setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    //点击事件
    [backBtn addTarget:self action:@selector(backTo) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    if (viewController.navigationItem.leftBarButtonItem == nil&&self.viewControllers.count > 1) {
        viewController.navigationItem.leftBarButtonItem = backItem;
    }
}




- (void)backTo{
    [self popViewControllerAnimated:YES];
}

@end
