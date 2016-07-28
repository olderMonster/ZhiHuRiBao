//
//  ZHRBThemeController.m
//  ZhiHuRiBao
//
//  Created by kehwa on 16/7/28.
//  Copyright © 2016年 kehwa. All rights reserved.
//

#import "ZHRBThemeController.h"
#import <Masonry/Masonry.h>

#import "ZHRBThemeManager.h"


@interface ZHRBThemeController ()<OMApiManagerParamsSourceDelegate , OMApiManagerCallBackDelegate , UITableViewDataSource , UITableViewDelegate>

@property (nonatomic , strong)UIImageView *avatarImageView;     //头像
@property (nonatomic , strong)UILabel *nickNameLabel;           //昵称
@property (nonatomic , strong)UIButton *collectButton;          //收藏
@property (nonatomic , strong)UIButton *messageButton;          //消息
@property (nonatomic , strong)UIButton *settingButton;          //设置

@property (nonatomic , strong)UIButton *downButton;             //缓存
@property (nonatomic , strong)UIButton *modeButton;             //模式（白天、夜间）


@property (nonatomic , strong)UITableView *themeTableView;
@property (nonatomic , strong)ZHRBThemeManager *themeManager;
@property (nonatomic , strong)NSMutableArray *themeTable;

@end

@implementation ZHRBThemeController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = RGB(23, 24, 26);
    
    
    [self.view addSubview:self.avatarImageView];
    [self.view addSubview:self.nickNameLabel];
    [self.view addSubview:self.collectButton];
    [self.view addSubview:self.messageButton];
    [self.view addSubview:self.settingButton];
    
    [self.view addSubview:self.themeTableView];
    
    [self.view addSubview:self.downButton];
    [self.view addSubview:self.modeButton];
    
    //网络请求
    [self.themeManager loadData];
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    
    WS(weakSelf);
    
    
    
    [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@15);
        make.top.equalTo(@35);
        make.width.equalTo(@30);
        make.height.equalTo(weakSelf.avatarImageView.mas_width);
    }];
    self.avatarImageView.layer.cornerRadius = self.avatarImageView.bounds.size.width * 0.5;
    
    [self.nickNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.avatarImageView.mas_right).with.offset(10);
        make.top.equalTo(weakSelf.avatarImageView);
        make.height.equalTo(weakSelf.avatarImageView);
    }];
    
    
    CGFloat buttonW = self.view.frame.size.width / 3;
    [self.collectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.top.equalTo(weakSelf.avatarImageView.mas_bottom).with.offset(15);
        make.height.equalTo(@40);
        make.width.equalTo(@(buttonW));
    }];
    
    [self.messageButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.collectButton.mas_right);
        make.top.equalTo(weakSelf.collectButton);
        make.height.equalTo(weakSelf.collectButton);
        make.width.equalTo(@(buttonW));
    }];
    
    [self.settingButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.messageButton.mas_right);
        make.top.equalTo(weakSelf.collectButton);
        make.height.equalTo(weakSelf.collectButton);
        make.width.equalTo(@(buttonW));
    }];
    
    
    CGFloat bottonBtnW = self.view.frame.size.width / 2;
    [self.downButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.bottom.equalTo(@0);
        make.width.equalTo(@(bottonBtnW));
        make.height.equalTo(@40);
    }];
    
    [self.modeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.downButton.mas_right);
        make.bottom.equalTo(weakSelf.downButton);
        make.width.equalTo(weakSelf.downButton.mas_width);
        make.height.equalTo(weakSelf.downButton);
    }];
    
    
    [self.themeTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.top.equalTo(weakSelf.collectButton.mas_bottom);
        make.bottom.equalTo(weakSelf.downButton.mas_top);
        make.width.equalTo(@(weakSelf.view.bounds.size.width));
    }];
    
    
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.themeTable.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.textLabel.textColor = RGB(219, 219, 221);
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.backgroundColor = RGB(23, 24, 26);
    }
    cell.textLabel.text = self.themeTable[indexPath.row][@"name"];
    return cell;
}


#pragma mark - OMApiManagerParamsSourceDelegate
- (NSDictionary *)paramsForApi:(OMBaseApiManager *)manager{
    return nil;
}

#pragma mark -- OMApiManagerCallBackDelegate
- (void)managerCallApiDidSuccess:(OMBaseApiManager *)manager{
    NSDictionary *dict = [manager fetchDataWithReformer:nil];
    self.themeTable = [NSMutableArray arrayWithArray:dict[@"others"]];
    [self.themeTableView reloadData];
}
- (void)managerCallApiDidFailure:(OMBaseApiManager *)manager{
    
}


#pragma mark - getters and setters
- (UIImageView *)avatarImageView{
    if (_avatarImageView == nil) {
        _avatarImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Menu_Avatar"]];
        _avatarImageView.layer.masksToBounds = YES;
    }
    return _avatarImageView;
}
- (UILabel *)nickNameLabel{
    if (_nickNameLabel == nil) {
        _nickNameLabel = [[UILabel alloc]init];
        _nickNameLabel.font = [UIFont systemFontOfSize:12];
        _nickNameLabel.textColor = RGB(219, 219, 221);
        _nickNameLabel.text = @"monster";
    }
    return _nickNameLabel;
}
- (UIButton *)collectButton{
    if (_collectButton == nil) {
        _collectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_collectButton setImage:[UIImage imageNamed:@"Menu_Icon_Collect"] forState:UIControlStateNormal];
        [_collectButton setTitle:@"收藏" forState:UIControlStateNormal];
        [_collectButton setTitleColor:RGB(219, 219, 221) forState:UIControlStateNormal];
        _collectButton.titleLabel.font = [UIFont systemFontOfSize:11];
    }
    return _collectButton;
}
- (UIButton *)messageButton{
    if (_messageButton == nil) {
        _messageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_messageButton setImage:[UIImage imageNamed:@"Menu_Icon_Message"] forState:UIControlStateNormal];
        [_messageButton setTitle:@"消息" forState:UIControlStateNormal];
        [_messageButton setTitleColor:RGB(219, 219, 221) forState:UIControlStateNormal];
        _messageButton.titleLabel.font = [UIFont systemFontOfSize:11];
    }
    return _messageButton;
}
- (UIButton *)settingButton{
    if (_settingButton == nil) {
        _settingButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_settingButton setImage:[UIImage imageNamed:@"Menu_Icon_Setting"] forState:UIControlStateNormal];
        [_settingButton setTitle:@"设置" forState:UIControlStateNormal];
        [_settingButton setTitleColor:RGB(219, 219, 221) forState:UIControlStateNormal];
        _settingButton.titleLabel.font = [UIFont systemFontOfSize:11];
    }
    return _settingButton;
}


- (UITableView *)themeTableView{
    if (_themeTableView == nil) {
        _themeTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _themeTableView.backgroundColor = RGB(23, 24, 26);
        _themeTableView.dataSource = self;
        _themeTableView.delegate = self;
        _themeTableView.tableFooterView = [[UIView alloc]init];
        _themeTableView.rowHeight = 40;
        _themeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _themeTableView;
}



- (UIButton *)downButton{
    if (_downButton == nil) {
        _downButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_downButton setImage:[UIImage imageNamed:@"Menu_Download"] forState:UIControlStateNormal];
        [_downButton setTitle:@"完成" forState:UIControlStateNormal];
        [_downButton setTitleColor:RGB(219, 219, 221) forState:UIControlStateNormal];
        _downButton.titleLabel.font = [UIFont systemFontOfSize:12];
    }
    return _downButton;
}

- (UIButton *)modeButton{
    if (_modeButton == nil) {
        _modeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_modeButton setImage:[UIImage imageNamed:@"Menu_Dark"] forState:UIControlStateNormal];
        [_modeButton setTitle:@"夜间" forState:UIControlStateNormal];
        [_modeButton setTitleColor:RGB(219, 219, 221) forState:UIControlStateNormal];
        _modeButton.titleLabel.font = [UIFont systemFontOfSize:12];
    }
    return _modeButton;
}



- (ZHRBThemeManager *)themeManager{
    if (_themeManager == nil) {
        _themeManager = [[ZHRBThemeManager alloc]init];
        _themeManager.sourceDelegate = self;
        _themeManager.callBackDelegate = self;
    }
    return _themeManager;
}
- (NSMutableArray *)themeTable{
    if (_themeTable == nil) {
        _themeTable = [NSMutableArray array];
    }
    return _themeTable;
}
@end
