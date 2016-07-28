//
//  ZHRBLaunchController.m
//  ZhiHuRiBao
//
//  Created by kehwa on 16/7/27.
//  Copyright © 2016年 kehwa. All rights reserved.
//

#import "ZHRBLaunchController.h"
#import "ZHRBLaunchManager.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <Masonry/Masonry.h>

#import "ZHRBReportsController.h"
#import "OMNavigationController.h"

@interface ZHRBLaunchController ()<OMApiManagerParamsSourceDelegate , OMApiManagerCallBackDelegate>

@property (nonatomic , strong)UIImageView *launchImageView;
@property (nonatomic , strong)UILabel *sourceLabel;

@property (nonatomic , strong)UIView *appInfoView;
@property (nonatomic , strong)UIView *logoView;
@property (nonatomic , strong)CAShapeLayer *logoLayer;
@property (nonatomic , strong)UILabel *appNameLabel;
@property (nonatomic , strong)UILabel *appTagLabel;

@property (nonatomic , strong)ZHRBLaunchManager *launchManager;

@property (nonatomic , strong)NSTimer *timer;

@end

@implementation ZHRBLaunchController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.launchImageView];
    [self.view addSubview:self.sourceLabel];
    
    [self.view addSubview:self.appInfoView];
    
    [self.launchManager loadData];
    
    
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8/*延迟执行时间*/ * NSEC_PER_SEC));
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.5 animations:^{
            self.appInfoView.center = CGPointMake(self.view.center.x, kScreenHeight - 40);
            [self performSelector:@selector(logoAnimation) withObject:nil afterDelay:0.5];
        }];
    });
    
    
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    
    
    WS(weakSelf);
    [self.launchImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.left.equalTo(@0);
        make.bottom.equalTo(@0);
        make.right.equalTo(@0);
    }];

    
    [self.appInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.height.equalTo(@80);
        make.right.equalTo(@0);
        make.bottom.equalTo(@(kScreenHeight + 80));
    }];
    
    [self.sourceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.right.equalTo(@0);
        make.bottom.equalTo(weakSelf.appInfoView.mas_top).with.offset(-10);
    }];
    

    [self.logoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@20);
        make.top.equalTo(@20);
        make.bottom.equalTo(@(-20));
        make.width.equalTo(weakSelf.logoView.mas_height);
    }];
    
    [self.appNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.logoView.mas_right).with.offset(15);
        make.top.equalTo(weakSelf.logoView);
    }];
    
    [self.appTagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.appNameLabel);
        make.bottom.equalTo(weakSelf.logoView);
    }];

    
    
    //创建出圆形贝塞尔曲线
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.logoView.bounds.size.width * 0.5, self.logoView.bounds.size.height *0.5) radius:self.logoView.bounds.size.width / 4 startAngle:M_PI_2 endAngle:2 * M_PI+M_PI_2 clockwise:YES];
    //让贝塞尔曲线与CAShapeLayer产生联系
    self.logoLayer.path = circlePath.CGPath;
}


- (void)logoAnimation{

    self.logoLayer.strokeEnd = 1.0;
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(animationAction) userInfo:nil repeats:NO];
    
}


- (void)animationAction{

    ZHRBReportsController *reprotsVC = [[ZHRBReportsController alloc]init];
    OMNavigationController *nav = [[OMNavigationController alloc]initWithRootViewController:reprotsVC];
    [UIApplication sharedApplication].keyWindow.rootViewController = nav;
}


#pragma mark - OMApiManagerParamsSourceDelegate
- (NSDictionary *)paramsForApi:(OMBaseApiManager *)manager{
    return nil;
}

#pragma mark - OMApiManagerCallBackDelegate
- (void)managerCallApiDidSuccess:(OMBaseApiManager *)manager{
    NSDictionary *dict = [manager fetchDataWithReformer:nil];
   
    [self.launchImageView sd_setImageWithURL:[NSURL URLWithString:dict[@"img"]]];
    self.sourceLabel.text = dict[@"text"];
    
}

- (void)managerCallApiDidFailure:(OMBaseApiManager *)manager{
    
}


#pragma mark - getters and setters

- (UIImageView *)launchImageView{
    if (_launchImageView == nil) {
        _launchImageView = [[UIImageView alloc]init];
    }
    return _launchImageView;
}


- (UILabel *)sourceLabel{
    if (_sourceLabel == nil) {
        _sourceLabel = [[UILabel alloc]init];
        _sourceLabel.backgroundColor = [UIColor clearColor];
        _sourceLabel.font = [UIFont systemFontOfSize:12];
        _sourceLabel.textColor = RGB(170, 170, 170);
        _sourceLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _sourceLabel;
}

- (UIView *)appInfoView{
    if (_appInfoView == nil) {
        _appInfoView = [[UIView alloc]init];
        _appInfoView.backgroundColor = RGB(23, 24, 26);
        
        [_appInfoView addSubview:self.logoView];
        [_appInfoView addSubview:self.appNameLabel];
        [_appInfoView addSubview:self.appTagLabel];
    }
    return _appInfoView;
}

- (UIView *)logoView{
    if (_logoView == nil) {
        _logoView = [[UIView alloc]init];
        _logoView.backgroundColor = RGB(23, 24, 26);
        _logoView.layer.masksToBounds = YES;
        _logoView.layer.cornerRadius = 10;
        _logoView.layer.borderColor = [UIColor whiteColor].CGColor;
        _logoView.layer.borderWidth = 1.0f;
        
        [_logoView.layer addSublayer:self.logoLayer];
        
    }
    return _logoView;
}

- (CAShapeLayer *)logoLayer{
    if (_logoLayer == nil) {
        _logoLayer = [CAShapeLayer layer];
        _logoLayer.fillColor = [UIColor clearColor].CGColor;//填充颜色为ClearColor
        //设置线条的宽度和颜色
        _logoLayer.lineWidth = 5.0f;
        _logoLayer.strokeColor = RGB(194, 197, 204).CGColor;
        
        _logoLayer.strokeStart = 0.0;
        _logoLayer.strokeEnd = 0.0;
    }
    return _logoLayer;
}


- (UILabel *)appNameLabel{
    if (_appNameLabel == nil) {
        _appNameLabel = [[UILabel alloc]init];
        _appNameLabel.backgroundColor = [UIColor clearColor];
        _appNameLabel.font = [UIFont systemFontOfSize:17];
        _appNameLabel.textColor = [UIColor whiteColor];
        _appNameLabel.text = @"知乎日报";
    }
    return _appNameLabel;
}

- (UILabel *)appTagLabel{
    if (_appTagLabel == nil) {
        _appTagLabel = [[UILabel alloc]init];
        _appTagLabel.backgroundColor = [UIColor clearColor];
        _appTagLabel.font = [UIFont systemFontOfSize:14];
        _appTagLabel.textColor = [UIColor grayColor];
        _appTagLabel.text = @"每天三次,每次七分钟";
    }
    return _appTagLabel;
}


- (ZHRBLaunchManager *)launchManager{
    if (_launchManager == nil) {
        _launchManager = [[ZHRBLaunchManager alloc]init];
        _launchManager.sourceDelegate = self;
        _launchManager.callBackDelegate = self;
    }
    return _launchManager;
}

@end
