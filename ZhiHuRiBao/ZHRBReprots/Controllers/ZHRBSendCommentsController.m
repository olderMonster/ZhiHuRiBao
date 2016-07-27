//
//  ZHRBSendCommentsController.m
//  ZhiHuRiBao
//
//  Created by kehwa on 16/7/26.
//  Copyright © 2016年 kehwa. All rights reserved.
//

#import "ZHRBSendCommentsController.h"

@interface ZHRBSendCommentsController ()<UITextViewDelegate>

@property (nonatomic , strong)UITextView *commentsTextView;

@end

@implementation ZHRBSendCommentsController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"写点评";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.commentsTextView];
    
    [self addItems];
}


- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    
    self.commentsTextView.frame = CGRectMake(5, 10, self.view.bounds.size.width - 10, self.view.frame.size.height - 64 - 20);
}

#pragma mark -- private method
- (void)addItems{
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"News_Arrow@2x"] forState:UIControlStateNormal];
    leftButton.frame = CGRectMake(0, 0, 20, 20);
    [leftButton addTarget:self action:@selector(backButtonAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setTitle:@"发布" forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:15];
    rightButton.frame = CGRectMake(0, 0, 40, 20);
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightItem;
}


- (void)backButtonAction{
    [self.commentsTextView resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}


#pragma mark - getters and setters
- (UITextView *)commentsTextView{
    if (_commentsTextView == nil) {
        _commentsTextView = [[UITextView alloc]init];
        _commentsTextView.delegate = self;
        [_commentsTextView becomeFirstResponder];
    }
    return _commentsTextView;
}


@end
