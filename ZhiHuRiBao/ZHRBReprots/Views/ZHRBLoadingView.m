//
//  ZHRBLoadingView.m
//  ZhiHuRiBao
//
//  Created by kehwa on 16/7/27.
//  Copyright © 2016年 kehwa. All rights reserved.
//

#import "ZHRBLoadingView.h"

@interface ZHRBLoadingView()<UIScrollViewDelegate>

@property (nonatomic , strong)CAShapeLayer *loadingLayer;
@property (nonatomic , strong)UIScrollView *targetScrollView;

@end

@implementation ZHRBLoadingView


- (instancetype)initWithTarget:(UIScrollView *)scrollView{
    self = [super init];
    if (self) {
        
        _targetScrollView = scrollView;
        _targetScrollView.delegate = self;
        
        _loadingLayer = [CAShapeLayer layer];
        _loadingLayer.fillColor = [UIColor clearColor].CGColor;
        
        _loadingLayer.strokeColor = [UIColor grayColor].CGColor;
        _loadingLayer.lineWidth = 2.0f;
        
        _loadingLayer.strokeStart = 0.0;
        _loadingLayer.strokeEnd = 0.0;
        

        
        [self.layer addSublayer:_loadingLayer];
        
    }
    return self;
}


- (void)layoutSubviews{
    [super layoutSubviews];

    self.loadingLayer.bounds = self.bounds;
    self.loadingLayer.position = CGPointMake(0, 0);
    
    
    CGPoint center = CGPointMake(0, 0);
    UIBezierPath *loadingPath = [UIBezierPath bezierPathWithArcCenter:center radius:self.bounds.size.width * 0.5 startAngle:0 endAngle:2 * M_PI clockwise:YES];
    self.loadingLayer.path = loadingPath.CGPath;
    
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat offSetY = scrollView.contentOffset.y;
    if (offSetY<-80) {
        self.loadingLayer.strokeEnd = fabs(offSetY) / 40;
    }
}



@end
