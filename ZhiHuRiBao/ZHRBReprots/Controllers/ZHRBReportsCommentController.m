//
//  ZHRBReportsCommentController.m
//  ZhiHuRiBao
//
//  Created by kehwa on 16/7/22.
//  Copyright © 2016年 kehwa. All rights reserved.
//

#import "ZHRBReportsCommentController.h"
#import "OMNetworkingConfiguration.h"
#import <Masonry/Masonry.h>
#import <UITableView+FDTemplateLayoutCell/UITableView+FDTemplateLayoutCell.h>

#import "ZHRBReportsCommentsCell.h"
#import "ZHRBSendCommentsController.h"
#import "OMNavigationController.h"

#import "ZHRBReportsLongCommentsManager.h"
#import "ZHRBReportsShortCommentsManager.h"
#import "ZHRBReportsCommentsReformer.h"

static NSString *cellIdentifier = @"cell";

@interface ZHRBReportsCommentController ()<OMApiManagerParamsSourceDelegate , OMApiManagerCallBackDelegate , UITableViewDataSource , UITableViewDelegate>

@property (nonatomic , strong)UIView *bottomView;
@property (nonatomic , strong)UIButton *backButton;   //返回按钮
@property (nonatomic , strong)UIButton *commentButton;  //评论按钮

@property (nonatomic , strong)UITableView *commentTableView;
@property (nonatomic , strong)UIButton *longheaderButton;
@property (nonatomic , strong)UIButton *shortheaderButton;

@property (nonatomic , strong)ZHRBReportsLongCommentsManager *longCommentsManager;
@property (nonatomic , strong)ZHRBReportsShortCommentsManager *shortCommentsManager;
@property (nonatomic , strong)ZHRBReportsCommentsReformer *commentsReformer;

@property (nonatomic , strong)NSArray *commentsTmpTable;
@property (nonatomic , strong)NSMutableArray *commentsTable;

@end

@implementation ZHRBReportsCommentController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"19条点评";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.bottomView];
    [self.view addSubview:self.commentTableView];
    
    [self.longCommentsManager loadData];
    [self.shortCommentsManager loadData];
    
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    
    self.bottomView.frame = CGRectMake(0, kScreenHeight - 30, kScreenWidth, 30);
    self.backButton.frame = CGRectMake(0, 0, 40, self.bottomView.bounds.size.height);
    self.commentButton.frame = CGRectMake(CGRectGetMaxX(self.backButton.frame), 0, self.bottomView.bounds.size.width - CGRectGetMaxX(self.backButton.frame), self.bottomView.bounds.size.height);
    
    self.commentTableView.frame = CGRectMake(0, 64, kScreenWidth, kScreenHeight - self.bottomView.bounds.size.height - 64);
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
    
}


#pragma mark - event response
- (void)backButtonAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)commentButtonAction{
    ZHRBSendCommentsController *sendCommentsVC = [[ZHRBSendCommentsController alloc]init];
    OMNavigationController *navigationVC = [[OMNavigationController alloc]initWithRootViewController:sendCommentsVC];
    [self presentViewController:navigationVC animated:YES completion:nil];
}


- (void)longheaderButtonAction:(UIButton *)button{
    
}


- (void)shortheaderButtonAction:(UIButton *)button{
    
    _shortheaderButton.selected = ! _shortheaderButton.selected;
    
    if (![self.commentsTable[1] isEqual:@""]) {
        
        if (_shortheaderButton.selected) {
            
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:self.commentsTmpTable[1]];
            dict[@"show"] = @"1";
            [self.commentsTable replaceObjectAtIndex:1 withObject:dict];
            [self.commentTableView reloadData];
            
            [self.commentTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1] atScrollPosition:UITableViewScrollPositionNone animated:YES];
        }else{
            
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            dict[@"show"] = @"0";
            [self.commentsTable replaceObjectAtIndex:1 withObject:dict];
            [self.commentTableView reloadData];
            
//            if (![self.commentsTable[0] isEqual:@""]) {
//                [self.commentTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:YES];
//            }
            
        }

    }
    
}


#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.commentsTable.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.commentsTable[section][@"comments"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ZHRBReportsCommentsCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
//    if (!cell) {
//        cell = [[ZHRBReportsCommentsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
//    }
//    [self configureCell:cell atIndexPath:indexPath];
    cell.comment = self.commentsTable[indexPath.section][@"comments"][indexPath.row];
    return cell;
}


//- (void)configureCell:(ZHRBReportsCommentsCell *)cell atIndexPath:(NSIndexPath *)indexPath {
//    //次啊用 计算frame模式还是自动布局模式，默认为NO，自动布局模式
////    cell.fd_enforceFrameLayout = YES; // Enable to use "-sizeThatFits:"
//    cell.comment = self.commentsTable[indexPath.section][@"comments"][indexPath.row];
//}

#pragma mark -- UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    return [tableView fd_heightForCellWithIdentifier:cellIdentifier cacheByIndexPath:indexPath configuration:^(id cell) {
//        [self configureCell:cell atIndexPath:indexPath];
//        
//    }];
//    
//    return [self.commentTableView fd_heightForCellWithIdentifier:cellIdentifier configuration:^(ZHRBReportsCommentsCell *cell) {
////        [self configureCell:cell atIndexPath:indexPath];
//        
//        cell.comment = self.commentsTable[indexPath.section][@"comments"][indexPath.row];
//        
//    }];
//
    
    CGFloat nickNameH = 14;
    CGFloat contentsW = kScreenWidth - 60;
    NSString *contents = self.commentsTable[indexPath.section][@"comments"][indexPath.row][@"content"];
    CGRect contentRect = [contents boundingRectWithSize:CGSizeMake(contentsW, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil];
    CGFloat contentH = contentRect.size.height;
    
    CGFloat cellH = 10 + nickNameH + 10 + contentH + 10 + 15 + 10;
    return cellH;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        
        self.longheaderButton.frame = CGRectMake(0, 0, kScreenWidth, 40);
        return self.longheaderButton;
        
    }else{
        
        self.shortheaderButton.frame = CGRectMake(0, 0, kScreenWidth, 40);
        return self.shortheaderButton;
        
    }
    
}

#pragma mark - OMApiManagerParamsSourceDelegate
- (NSDictionary *)paramsForApi:(OMBaseApiManager *)manager{
    return nil;
}


#pragma mark - OMApiManagerCallBackDelegate
- (void)managerCallApiDidSuccess:(OMBaseApiManager *)manager{

    NSArray *array = [manager fetchDataWithReformer:self.commentsReformer];
    
    if (![array[0]  isEqual: @""] && ![array[1]  isEqual: @""]) { //长评与短评全部都已请求完成
        self.commentsTmpTable = array;
        
        //短评始终不显示，只有点击了头部才显示
        for (NSInteger index = 0 ; index < array.count; index++) {
            NSMutableDictionary *mdict = [NSMutableDictionary dictionaryWithDictionary:array[index]];
            
//            if (index == 0) {
//                
//                //没有长评
//                if ([mdict[@"comments"] count] == 0) {
//                    mdict[@"comments"] = @[@"1"];
//                }
//                
//            }
            
           if (index == 1){
                mdict[@"comments"] = @[];
            }
            [self.commentsTable addObject:mdict];
        }
        
        
        [self.commentTableView reloadData];
        
        [self.longheaderButton setTitle:[NSString stringWithFormat:@"%lu 条长评",[array[0][@"comments"] count]] forState:UIControlStateNormal];
        [self.shortheaderButton setTitle:[NSString stringWithFormat:@"%lu 条短评",[array[1][@"comments"] count]] forState:UIControlStateNormal];
        
    }
}
- (void)managerCallApiDidFailure:(OMBaseApiManager *)manager{
    
}


#pragma mark - getters and setters
- (UIView *)bottomView{
    if (_bottomView == nil) {
        _bottomView = [[UIView alloc]init];
        _bottomView.backgroundColor = RGB(235, 235, 241);
        
        [_bottomView addSubview:self.backButton];
        [_bottomView addSubview:self.commentButton];
    }
    return _bottomView;
}

- (UIButton *)backButton{
    if (_backButton == nil) {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        _backButton.backgroundColor = [UIColor redColor];
//        [_backButton setTitle:@"<" forState:UIControlStateNormal];
//        [_backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(backButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [_backButton setBackgroundImage:[UIImage imageNamed:@"News_Navigation_Arrow"] forState:UIControlStateNormal];
    }
    return _backButton;
}

- (UIButton *)commentButton{
    if (_commentButton == nil) {
        _commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _commentButton.backgroundColor = RGB(215, 215, 215);
        [_commentButton setTitle:@"写点评" forState:UIControlStateNormal];
        [_commentButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _commentButton.titleLabel.font = [UIFont systemFontOfSize:10];
        [_commentButton addTarget:self action:@selector(commentButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _commentButton;
}

- (UITableView *)commentTableView{
    if (_commentTableView == nil) {
        _commentTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _commentTableView.backgroundColor = [UIColor whiteColor];
        _commentTableView.delegate = self;
        _commentTableView.dataSource = self;
        _commentTableView.tableFooterView = [[UIView alloc]init];
        [_commentTableView registerClass:[ZHRBReportsCommentsCell class] forCellReuseIdentifier:cellIdentifier];
//        _commentTableView.fd_debugLogEnabled = YES;
    }
    return _commentTableView;
}

- (UIButton *)longheaderButton{
    if (_longheaderButton == nil) {
        _longheaderButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_longheaderButton setTitle:@"长评" forState:UIControlStateNormal];
        [_longheaderButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_longheaderButton setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        [_longheaderButton addTarget:self action:@selector(longheaderButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _longheaderButton;
}

- (UIButton *)shortheaderButton{
    if (_shortheaderButton == nil) {
        _shortheaderButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_shortheaderButton setTitle:@"短评" forState:UIControlStateNormal];
        [_shortheaderButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_shortheaderButton setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        [_shortheaderButton addTarget:self action:@selector(shortheaderButtonAction:) forControlEvents:UIControlEventTouchUpInside];

    }
    return _shortheaderButton;
}

- (ZHRBReportsLongCommentsManager *)longCommentsManager{
    if (_longCommentsManager == nil) {
        _longCommentsManager = [[ZHRBReportsLongCommentsManager alloc]init];
        _longCommentsManager.sourceDelegate = self;
        _longCommentsManager.callBackDelegate = self;
        _longCommentsManager.reportsId = self.reportsId;
    }
    return _longCommentsManager;
}

- (ZHRBReportsShortCommentsManager *)shortCommentsManager{
    if (_shortCommentsManager == nil) {
        _shortCommentsManager = [[ZHRBReportsShortCommentsManager alloc]init];
        _shortCommentsManager.sourceDelegate = self;
        _shortCommentsManager.callBackDelegate = self;
        _shortCommentsManager.reportsId = self.reportsId;
    }
    return _shortCommentsManager;
}


- (ZHRBReportsCommentsReformer *)commentsReformer{
    if (_commentsReformer == nil) {
        _commentsReformer = [[ZHRBReportsCommentsReformer alloc]init];
    }
    return _commentsReformer;
}

- (NSMutableArray *)commentsTable{
    if (_commentsTable == nil) {
        _commentsTable = [[NSMutableArray alloc]init];
    }
    return _commentsTable;
}

- (NSArray *)commentsTmpTable{
    if (_commentsTmpTable == nil) {
        _commentsTmpTable = [[NSArray alloc]init];
    }
    return _commentsTmpTable;
}

@end
