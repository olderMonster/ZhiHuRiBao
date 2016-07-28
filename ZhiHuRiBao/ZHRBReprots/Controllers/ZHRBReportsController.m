//
//  ZHRBReportsController.m
//  ZhiHuRiBao
//
//  Created by kehwa on 16/7/21.
//  Copyright © 2016年 kehwa. All rights reserved.
//

#import "ZHRBReportsController.h"

#import <SDCycleScrollView/SDCycleScrollView.h>

#import "NSString+PDNetworkingMethods.h"
#import "UIView+HandleAddition.h"

#import "ZHRBReportsManager.h"
#import "ZHRBReportsReformer.h"
#import "ZHRBBeforeReportsManager.h"

#import "ZHRBReportsCell.h"
#import "ZHRBReportsHeaderView.h"

//#import "ZHRBLoadingView.h"

#import "ZHRBReportsDetailController.h"
#import "ZHRBThemeController.h"

@interface ZHRBReportsController ()<UITableViewDataSource , UITableViewDelegate , OMApiManagerParamsSourceDelegate , OMApiManagerCallBackDelegate , UIScrollViewDelegate>

/**
 *  自己定义一个navigationbar
 */

@property (nonatomic , strong)UIView *navigationBarView;
@property (nonatomic , strong)UILabel *navagationBarLabel;
@property (nonatomic , strong)UIButton *leftItemButton;


@property (nonatomic , strong)UITableView *reportTableView;
@property (nonatomic , strong)UIView *reportHeadeView;

@property (nonatomic , strong)SDCycleScrollView *adScrollView;

@property (nonatomic , strong)ZHRBReportsManager *reportsManager;
@property (nonatomic , strong)ZHRBReportsReformer *reportsReformer;

@property (nonatomic , strong)ZHRBBeforeReportsManager *beforeReportsManager;

@property (nonatomic , strong)NSMutableArray *reportTable;
@property (nonatomic , strong)NSMutableArray *adTable;

//@property (nonatomic , strong)ZHRBLoadingView *loadingView;

@end

@implementation ZHRBReportsController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"今日热闻";
    self.view.backgroundColor = [UIColor whiteColor];

    [self.view addSubview:self.reportTableView];
    [self.view addSubview:self.adScrollView];
    [self.view addSubview:self.navigationBarView];
    [self.view addSubview:self.navagationBarLabel];
//    [self.view addSubview:self.loadingView];
    [self.view addSubview:self.leftItemButton];
    
    [self addHeaderView];
    
    [self.reportsManager loadData];
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    
    //20 + 40 (状态栏的高度+导航栏的高度)
//    self.navigationBarView.frame = CGRectMake(0, 0, kScreenWidth, 60);
    CGSize titleSize = [self.navagationBarLabel.text sizeWithAttributes:@{NSFontAttributeName:self.navagationBarLabel.font}];
    self.navagationBarLabel.bounds = CGRectMake(0, 0, titleSize.width, 40);
    self.navagationBarLabel.center = CGPointMake(self.navigationBarView.center.x, 20 + self.navagationBarLabel.bounds.size.height * 0.5);
//    self.loadingView.bounds = CGRectMake(0, 0, 30, 30);
//    self.loadingView.center = CGPointMake(self.navagationBarLabel.frame.origin.x - 20, self.navagationBarLabel.center.y);
    
    self.reportTableView.frame = self.view.bounds;
    
    
    self.leftItemButton.bounds = CGRectMake(0, 0, 20, 20);
    self.leftItemButton.center = CGPointMake(20, self.navagationBarLabel.center.y);
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = YES;

}

#pragma mark - event response
- (void)leftItemButtonAction{
    ZHRBThemeController *themeVC = [[ZHRBThemeController alloc]init];
    [self.navigationController pushViewController:themeVC animated:YES];
}

#pragma mark - private method
- (void)addHeaderView{
    
    self.reportHeadeView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 150)];
    self.reportHeadeView.backgroundColor = [UIColor whiteColor];
    
    
//    self.adScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, self.reportHeadeView.bounds.size.width, self.reportHeadeView.bounds.size.height + 20) delegate:nil placeholderImage:nil];
//    [self.view addSubview:self.adScrollView];
    
    self.reportTableView.tableHeaderView = self.reportHeadeView;
 
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if ([scrollView isEqual:self.reportTableView]) {
        
        CGFloat offSetY = scrollView.contentOffset.y;
        
        //修改导航栏的背景颜色
        CGFloat navigationBarAlpha = (offSetY / 100) > 1.0?1.0:(offSetY / 100);
        self.navigationBarView.alpha = navigationBarAlpha;
        

        self.adScrollView.frame = CGRectMake(0, -(offSetY + 20) + (-80), kScreenWidth, 170 + 80);
        if (offSetY < -70) {
            self.reportTableView.contentOffset = CGPointMake(0, - 70);
        }
        

        
        //tableView的headerView放大
        //    if (y > -60) {
        //        CGFloat r = - (y / 60  - 1); //求绝对值
        //        self.adScrollView.center = self.reportHeadeView.center;
        //        self.adScrollView.bounds = CGRectMake(0, 0, self.reportHeadeView.bounds.size.width *r , self.reportHeadeView.bounds.size.height * r);
        //    }
        
        //上滑过程中，当tableView的sectionHeader到最顶部的时候该百年navigationBar上的文本
//        UITableView *scrollViewTableView = (UITableView *)scrollView;
//        NSArray *cellsArray = [scrollViewTableView visibleCells];
//        ZHRBReportsCell *reportCell  = cellsArray[0];
//        NSIndexPath *indexParh = [self.reportTableView indexPathForCell:reportCell];
//        if (indexParh.section == 0) {
//            
//            CGRect rectInTableView = [self.reportTableView rectForRowAtIndexPath:indexParh];
//            
//            CGRect rect = [self.reportTableView convertRect:rectInTableView toView:self.view];
//            
//            if (rect.origin.y <= 20) {
//                
//                self.navagationBarLabel.text = @"111";
//                
//            }else{
//                
//                self.navigationBarView.hidden = NO;
//                
//            }
//            
//            
//        }else{
//            self.navigationBarView.hidden = YES;
//        }
        
        
        //上拉刷新
//        if (offSetY + 70 > scrollView.contentSize.height - kScreenHeight) {
//            [self.beforeReportsManager loadData];
//        }
//        
    }
    


}


#pragma mark -- UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.reportTable.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.reportTable[section][@"stories"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *cellIdentifier = @"cell";
    ZHRBReportsCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[ZHRBReportsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.reports = self.reportTable[indexPath.section][@"stories"][indexPath.row];
    
    if (indexPath.row == [self.reportTable[indexPath.section][@"stories"] count] - 1) {
        [self.beforeReportsManager loadData];
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0.01;
    }
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}


- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        return nil;
    }
    
    ZHRBReportsHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"headerView"];
    headerView.contentView.backgroundColor = RGB(56, 138, 211);
    headerView.textLabel.attributedText = [[NSAttributedString alloc]initWithString:self.reportTable[section][@"date"] attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont boldSystemFontOfSize:16]}];
    return headerView;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section{
    if (section == 0) {
        self.navagationBarLabel.alpha = 1;
        self.navigationBarView.height = 60;
    }
}

- (void)tableView:(UITableView *)tableView didEndDisplayingFooterView:(UIView *)view forSection:(NSInteger)section{
    if (section == 0) {
        self.navagationBarLabel.alpha = 0;
        self.navigationBarView.height = 20;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    NSDictionary *reports = self.reportTable[indexPath.section][@"stories"][indexPath.row];
    ZHRBReportsDetailController *detailVC = [[ZHRBReportsDetailController alloc]init];
    detailVC.reportsId = reports[@"id"];
    [self.navigationController pushViewController:detailVC animated:YES];
    
}


#pragma mark -- OMApiManagerParamsSourceDelegate
- (NSDictionary *)paramsForApi:(OMBaseApiManager *)manager{
    return nil;
}


#pragma mark - OMApiManagerCallBackDelegate
- (void)managerCallApiDidSuccess:(OMBaseApiManager *)manager{
    
    NSDictionary *dict = [manager fetchDataWithReformer:self.reportsReformer];
    
    if (manager == self.reportsManager) {
        
        //消息
        self.reportTable = [NSMutableArray array];

        
        //轮播图
        NSArray *adArray = dict[@"top_stories"];
        for (NSDictionary *dict in adArray) {
            [self.adTable addObject:dict[@"image"]];
        }
        self.adScrollView.imageURLStringsGroup = self.adTable;
    }
    
    if (manager == self.beforeReportsManager) {
        
//        NSString *date = dict[@"date"];
        
    }
    
    [self.reportTable addObject:dict];
    [self.reportTableView reloadData];


}
- (void)managerCallApiDidFailure:(OMBaseApiManager *)manager{
    NSLog(@"errorType ===>> %lu",(unsigned long)manager.errorType);
}


#pragma mark - getters and setters
- (UIView *)navigationBarView{
    if (_navigationBarView == nil) {
        _navigationBarView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 60)];
//        _navigationBarView.backgroundColor = [UIColor redColor];
        _navigationBarView.backgroundColor = RGB(56, 138, 211);
        _navigationBarView.alpha = 0;
    }
    return _navigationBarView;
}

- (UILabel *)navagationBarLabel{
    if (_navagationBarLabel == nil) {
        _navagationBarLabel = [[UILabel alloc]init];
        _navagationBarLabel.font = [UIFont systemFontOfSize:16];
        _navagationBarLabel.textColor = [UIColor whiteColor];
        _navagationBarLabel.textAlignment = NSTextAlignmentCenter;
        _navagationBarLabel.text = @"今日热闻";
    }
    return _navagationBarLabel;
}

- (UIButton *)leftItemButton{
    if (_leftItemButton == nil) {
        _leftItemButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_leftItemButton setBackgroundImage:[UIImage imageNamed:@"Home_Icon@2x"] forState:UIControlStateNormal];
        [_leftItemButton addTarget:self action:@selector(leftItemButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftItemButton;
}


- (UITableView *)reportTableView{
    if (_reportTableView == nil) {
        _reportTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _reportTableView.backgroundColor = [UIColor whiteColor];
        _reportTableView.dataSource = self;
        _reportTableView.delegate = self;
        _reportTableView.tableFooterView = [[UIView alloc]init];
        _reportTableView.rowHeight = 70;
        [_reportTableView registerClass:[ZHRBReportsHeaderView class] forHeaderFooterViewReuseIdentifier:@"headerView"];
    }
    return _reportTableView;
}


- (SDCycleScrollView *)adScrollView{
    if (_adScrollView == nil) {
        _adScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, -80, kScreenWidth,150 + 20 + 80) delegate:nil placeholderImage:nil];
    }
    return _adScrollView;
}


//- (ZHRBLoadingView *)loadingView{
//    if (_loadingView == nil) {
//        _loadingView = [[ZHRBLoadingView alloc]initWithTarget:self.reportTableView];
//        _loadingView.backgroundColor = [UIColor redColor];
//    }
//    return _loadingView;
//}


- (ZHRBReportsManager *)reportsManager{
    if (_reportsManager == nil) {
        _reportsManager = [[ZHRBReportsManager alloc]init];
        _reportsManager.sourceDelegate = self;
        _reportsManager.callBackDelegate = self;
    }
    return _reportsManager;
}

- (ZHRBReportsReformer *)reportsReformer{
    if (_reportsReformer == nil) {
        _reportsReformer = [[ZHRBReportsReformer alloc]init];
    }
    return _reportsReformer;
}



- (ZHRBBeforeReportsManager *)beforeReportsManager{
    if (_beforeReportsManager == nil) {
        _beforeReportsManager = [[ZHRBBeforeReportsManager alloc]init];
        _beforeReportsManager.sourceDelegate = self;
        _beforeReportsManager.callBackDelegate = self;
    }
    return _beforeReportsManager;
}




- (NSMutableArray *)reportTable{
    if (_reportTable == nil) {
        _reportTable = [NSMutableArray array];
    }
    return _reportTable;
}

- (NSMutableArray *)adTable{
    if (_adTable == nil) {
        _adTable = [[NSMutableArray alloc]init];
    }
    return _adTable;
}


@end
