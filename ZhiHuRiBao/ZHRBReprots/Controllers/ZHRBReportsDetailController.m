//
//  ZHRBReportsDetailController.m
//  ZhiHuRiBao
//
//  Created by kehwa on 16/7/22.
//  Copyright © 2016年 kehwa. All rights reserved.
//

#import "ZHRBReportsDetailController.h"
#import "OMNetworkingConfiguration.h"

#import "ZHRBReportsExtraInfoManager.h"
#import "ZHRBReportDetailManager.h"

#import <SDWebImage/UIImageView+WebCache.h>
#import "UIView+HandleAddition.h"
#import <Masonry/Masonry.h>

#import "ZHRBReportsCommentController.h"

#import "ZHRBReportsShareView.h"

@interface ZHRBReportsDetailController ()<OMApiManagerParamsSourceDelegate , OMApiManagerCallBackDelegate , UIScrollViewDelegate , ZHRBReportsShareViewDelegate>

@property (nonatomic , strong)UIView *bottomView;
@property (nonatomic , strong)UIButton *backButton;         //返回按钮
@property (nonatomic , strong)UIButton *nextButton;         //写一个新闻按钮
@property (nonatomic , strong)UIButton *applaudButton;      //点赞按钮
@property (nonatomic , strong)UIButton *shareButton;        //分享按钮
@property (nonatomic , strong)UIButton *commentButton;      //查看评论按钮

@property (nonatomic , strong)ZHRBReportsShareView *shareView;

@property (nonatomic , strong)UILabel *applaudCountLabel;   //点赞人数
@property (nonatomic , strong)UILabel *commentCountLabel;   //评论人数

@property (nonatomic , strong)UIWebView *reportWebView;
@property (nonatomic , strong)UIImageView *reportsImageView;    //新闻图片
@property (nonatomic , strong)UILabel *reportsTitleLabel;       //新闻标题
@property (nonatomic , strong)UILabel *imageSourceLabel;        //图片来源

@property (nonatomic , strong)ZHRBReportDetailManager *reportDetailManager;
@property (nonatomic , strong)ZHRBReportsExtraInfoManager *extraInfoManager;

@end

@implementation ZHRBReportsDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.bottomView];
    [self.view addSubview:self.reportWebView];
    [self.view addSubview:self.reportsImageView];
    
    [self.view addSubview:self.shareView];
    
    [self.extraInfoManager loadData];
    [self.reportDetailManager loadData];
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    
   
    self.bottomView.frame = CGRectMake(0, kScreenHeight - 40 , kScreenWidth, 40);
    CGFloat buttonW = self.bottomView.bounds.size.width / 5;
    self.backButton.bounds = CGRectMake(0, 0, buttonW, self.bottomView.bounds.size.height);
    self.backButton.center = CGPointMake(buttonW * 0.5, self.bottomView.bounds.size.height * 0.5);
    
    self.nextButton.bounds = CGRectMake(0, 0, buttonW, self.bottomView.bounds.size.height);
    self.nextButton.center = CGPointMake(buttonW * 1.5, self.bottomView.bounds.size.height * 0.5);
    
    self.applaudButton.bounds = CGRectMake(0, 0, buttonW, self.bottomView.bounds.size.height);
    self.applaudButton.center = CGPointMake(buttonW * 2.5, self.bottomView.bounds.size.height * 0.5);
    
    self.shareButton.bounds = CGRectMake(0, 0, buttonW, self.bottomView.bounds.size.height);
    self.shareButton.center = CGPointMake(buttonW * 3.5, self.bottomView.bounds.size.height * 0.5);
    
    self.commentButton.bounds = CGRectMake(0, 0, buttonW, self.bottomView.bounds.size.height);
    self.commentButton.center = CGPointMake(buttonW * 4.5, self.bottomView.bounds.size.height * 0.5);
    
    self.reportWebView.frame = CGRectMake(0, 0, kScreenWidth, self.bottomView.frame.origin.y);
    
    [self.applaudCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(@(self.applaudButton.bounds.size.width * 0.5 + 10));
        make.top.equalTo(@10);
        
    }];
    
    [self.commentCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(@(self.commentButton.bounds.size.width * 0.5));
        make.top.equalTo(@7);
        make.right.equalTo(@(-13));
        make.bottom.equalTo(@(-self.commentButton.bounds.size.height * 0.5 - 3));
        
    }];
    
//    CGFloat shareViewH = 140 + kScreenWidth / 4 * 2;
//    self.shareView.frame = CGRectMake(0, 100, kScreenWidth, shareViewH);
    
//    [self.shareView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(@0);
//        make.top.equalTo(@(kScreenHeight));
//        make.width.equalTo(@(kScreenWidth));
//        make.height.equalTo(@(shareViewH));
//    }];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = YES;
    
}

#pragma mark - event response
- (void)backButtonAction{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)commentButtonAction{
    
    ZHRBReportsCommentController *commentVC = [[ZHRBReportsCommentController alloc]init];
    commentVC.reportsId = self.reportsId;
    [self.navigationController pushViewController:commentVC animated:YES];
    
}

- (void)shareButtonAction:(UIButton *)button{
    
    [UIView animateWithDuration:0.5 animations:^{
//        CGFloat shareViewH = 30 + kScreenWidth / 4 * 2 + 20 + 30 + 20 + 30 + 10;
        self.shareView.frame = CGRectMake(0, kScreenHeight - self.shareView.bounds.size.height, self.shareView.bounds.size.width, self.shareView.bounds.size.height);
        
    }];

    
}

#pragma mark - ZHRBReportsShareViewDelegate
- (void)didCancelAction{
    
    [UIView animateWithDuration:0.5 animations:^{
        self.shareView.frame = CGRectMake(0, kScreenHeight, self.shareView.bounds.size.width, self.shareView.bounds.size.height);
        
    }];
    
    

}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{

    CGFloat offSetY = scrollView.contentOffset.y;
    if (offSetY <= -40) {
        offSetY = -40;
        self.reportWebView.scrollView.contentOffset = CGPointMake(kScreenWidth, offSetY);
       
    }
     self.reportsImageView.frame = CGRectMake(0, -40 - offSetY, self.reportsImageView.bounds.size.width, self.reportsImageView.bounds.size.height);
    
}

#pragma mark - OMApiManagerParamsSourceDelegate
- (NSDictionary *)paramsForApi:(OMBaseApiManager *)manager{
    return nil;
}


#pragma mark - OMApiManagerCallBackDelegate
- (void)managerCallApiDidSuccess:(OMBaseApiManager *)manager{
    NSDictionary *dict = [manager fetchDataWithReformer:nil];
    if ([manager isEqual:self.extraInfoManager]) {
        
        self.commentCountLabel.text = [NSString stringWithFormat:@"%d",[dict[@"comments"] intValue]];
    
        int popularity = [dict[@"popularity"] intValue];
        self.applaudCountLabel.text = popularity == 0?nil:[NSString stringWithFormat:@"%d",popularity];
    }
    
    if ([manager isEqual:self.reportDetailManager]) {
        NSString *body = dict[@"body"];
        NSArray *css = dict[@"css"];
        NSString *html = [NSString stringWithFormat:@"<html><head><link rel=\"stylesheet\" href=%@></head><body>%@</body></html>",css[0],body];
        [self.reportWebView loadHTMLString:html baseURL:nil];
        [self.reportsImageView sd_setImageWithURL:[NSURL URLWithString:dict[@"image"]]];
        self.reportsTitleLabel.text = dict[@"title"];
        self.imageSourceLabel.text = [NSString stringWithFormat:@"图片：%@",dict[@"image_source"]];
        
    }
    
}
- (void)managerCallApiDidFailure:(OMBaseApiManager *)manager{
    
}

#pragma mark - getters and setters
- (UIView *)bottomView{
    if (_bottomView == nil) {
        _bottomView = [[UIView alloc]init];
        _bottomView.backgroundColor = RGB(235, 235, 243);
        
        [_bottomView addSubview:self.backButton];
        [_bottomView addSubview:self.nextButton];
        [_bottomView addSubview:self.applaudButton];
        [_bottomView addSubview:self.shareButton];
        [_bottomView addSubview:self.commentButton];
        
    }
    return _bottomView;
}

- (UIButton *)backButton{
    if (_backButton == nil) {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backButton setBackgroundImage:[UIImage imageNamed:@"News_Navigation_Arrow"] forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(backButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}
- (UIButton *)nextButton{
    if (_nextButton == nil) {
        _nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_nextButton setBackgroundImage:[UIImage imageNamed:@"News_Navigation_Next"] forState:UIControlStateNormal];
    }
    return _nextButton;
}

- (UIButton *)applaudButton{
    if (_applaudButton == nil) {
        _applaudButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_applaudButton setBackgroundImage:[UIImage imageNamed:@"News_Navigation_Voted"] forState:UIControlStateNormal];
        
        [_applaudButton addSubview:self.applaudCountLabel];
    }
    return _applaudButton;
}

- (UIButton *)shareButton{
    if (_shareButton == nil) {
        _shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_shareButton setBackgroundImage:[UIImage imageNamed:@"News_Navigation_Share"] forState:UIControlStateNormal];
        [_shareButton addTarget:self action:@selector(shareButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _shareButton;
}

- (UIButton *)commentButton{
    if (_commentButton == nil) {
        _commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_commentButton setBackgroundImage:[UIImage imageNamed:@"News_Navigation_Comment"] forState:UIControlStateNormal];
        [_commentButton addTarget:self action:@selector(commentButtonAction) forControlEvents:UIControlEventTouchUpInside];
        
        [_commentButton addSubview:self.commentCountLabel];
    }
    return _commentButton;
}



- (UIWebView *)reportWebView{
    if (_reportWebView == nil) {
        _reportWebView = [[UIWebView alloc]init];
        _reportWebView.scrollView.delegate = self;
    }
    return _reportWebView;
}

- (UIImageView *)reportsImageView{
    if (_reportsImageView == nil) {
        _reportsImageView = [[UIImageView alloc]init];
        _reportsImageView.frame = CGRectMake(0, -40, kScreenWidth, 240);
        
        [_reportsImageView addSubview:self.reportsTitleLabel];
        [_reportsImageView addSubview:self.imageSourceLabel];
        
        [self.reportsTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(@20);
            make.right.equalTo(@(-20));
            make.bottom.equalTo(@(-30));
            
        }];
        
        [self.imageSourceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(@(-15));
            make.bottom.equalTo(@(-10));
            
        }];
        
    }
    return _reportsImageView;
}

- (UILabel *)reportsTitleLabel{
    if (_reportsTitleLabel == nil) {
        _reportsTitleLabel = [[UILabel alloc]init];
        _reportsTitleLabel.backgroundColor = [UIColor clearColor];
        _reportsTitleLabel.numberOfLines = 0;
        [_reportsTitleLabel sizeToFit];
        _reportsTitleLabel.font = [UIFont systemFontOfSize:17];
        _reportsTitleLabel.textColor = [UIColor whiteColor];
    }
    return _reportsTitleLabel;
}
- (UILabel *)imageSourceLabel{
    if (_imageSourceLabel == nil) {
        _imageSourceLabel = [[UILabel alloc]init];
        _imageSourceLabel.backgroundColor = [UIColor clearColor];
        _imageSourceLabel.numberOfLines = 0;
        [_imageSourceLabel sizeToFit];
        _imageSourceLabel.font = [UIFont systemFontOfSize:8];
        _imageSourceLabel.textColor = [UIColor whiteColor];
    }
    return _imageSourceLabel;
}

- (UILabel *)applaudCountLabel{
    if (_applaudCountLabel == nil) {
        _applaudCountLabel = [[UILabel alloc]init];
        _applaudCountLabel.backgroundColor = [UIColor clearColor];
        _applaudCountLabel.font = [UIFont systemFontOfSize:8];
        _applaudCountLabel.textColor = [UIColor grayColor];
    }
    return _applaudCountLabel;
}

- (UILabel *)commentCountLabel{
    if (_commentCountLabel == nil) {
        _commentCountLabel = [[UILabel alloc]init];
        _commentCountLabel.backgroundColor = [UIColor clearColor];
        _commentCountLabel.font = [UIFont systemFontOfSize:8];
        _commentCountLabel.textColor = [UIColor whiteColor];
        _commentCountLabel.textAlignment = NSTextAlignmentCenter;

    }
    return _commentCountLabel;
}


- (ZHRBReportsShareView *)shareView{
    if (_shareView == nil) {
        //因为在ZHRBReportsShareView的内部已经给他定死了高度,所以这里的高度随意
        _shareView = [[ZHRBReportsShareView alloc]initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 0)];
        _shareView.backgroundColor = RGB(235, 235, 241);
        _shareView.delegate = self;
    }
    return _shareView;
}


- (ZHRBReportsExtraInfoManager *)extraInfoManager{
    if (_extraInfoManager == nil) {
        _extraInfoManager = [[ZHRBReportsExtraInfoManager alloc]init];
        _extraInfoManager.sourceDelegate = self;
        _extraInfoManager.callBackDelegate = self;
        _extraInfoManager.reportsId = self.reportsId;
    }
    return _extraInfoManager;
}

- (ZHRBReportDetailManager *)reportDetailManager{
    if (_reportDetailManager == nil) {
        _reportDetailManager = [[ZHRBReportDetailManager alloc]init];
        _reportDetailManager.sourceDelegate = self;
        _reportDetailManager.callBackDelegate = self;
        _reportDetailManager.reportsId = self.reportsId;
    }
    return _reportDetailManager;
}

@end
