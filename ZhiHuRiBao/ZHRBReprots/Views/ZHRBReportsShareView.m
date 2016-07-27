//
//  ZHRBReportsShareView.m
//  ZhiHuRiBao
//
//  Created by kehwa on 16/7/22.
//  Copyright © 2016年 kehwa. All rights reserved.
//

#import "ZHRBReportsShareView.h"

#import "ZHRBReportsShareCell.h"

static NSString *kShareCell = @"shareCell";

@interface ZHRBReportsShareView()<UICollectionViewDataSource , UICollectionViewDelegateFlowLayout , UIScrollViewDelegate>

@property (nonatomic , strong)UILabel *shareViewTitleLabel;                 //title
@property (nonatomic , strong)UICollectionView *shareTargetCollectionView;  //分享平台显示
@property (nonatomic , strong)UIPageControl *sharePageControl;              //pageControl
@property (nonatomic , strong)UIButton *collectButton;                      //收藏按钮
@property (nonatomic , strong)UIButton *cancelButton;                       //取消按钮
@property (nonatomic , strong)UIView *maskView;                             //遮罩视图

@property (nonatomic , strong)NSArray *shareItemsTable;

@end

@implementation ZHRBReportsShareView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        _shareViewTitleLabel = [[UILabel alloc]init];
        _shareViewTitleLabel.font = [UIFont systemFontOfSize:14];
        _shareViewTitleLabel.text = @"分享这篇内容";
        _shareViewTitleLabel.textAlignment = NSTextAlignmentCenter;
//        _shareViewTitleLabel.backgroundColor = [UIColor whiteColor];
        _shareViewTitleLabel.textColor = [UIColor grayColor];
        [self addSubview:_shareViewTitleLabel];
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _shareTargetCollectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _shareTargetCollectionView.showsHorizontalScrollIndicator = NO;
        _shareTargetCollectionView.pagingEnabled = YES;
        _shareTargetCollectionView.backgroundColor = [UIColor clearColor];
        _shareTargetCollectionView.dataSource = self;
        _shareTargetCollectionView.delegate = self;
        [_shareTargetCollectionView registerClass:[ZHRBReportsShareCell class] forCellWithReuseIdentifier:kShareCell];
        [self addSubview:_shareTargetCollectionView];
        
        
        _sharePageControl = [[UIPageControl alloc]init];
        _sharePageControl.numberOfPages = 2;
        _sharePageControl.pageIndicatorTintColor = [UIColor grayColor];
        [self addSubview:_sharePageControl];
        
        _collectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _collectButton.backgroundColor = [UIColor whiteColor];
        [_collectButton setTitle:@"收藏" forState:UIControlStateNormal];
        [_collectButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_collectButton addTarget:self action:@selector(collectButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_collectButton];
        
        
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelButton.backgroundColor = [UIColor whiteColor];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(cancelButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_cancelButton];
        
//        _maskView = [[UIView alloc]init];
//        _maskView.backgroundColor = [UIColor colorWithRed:115/255.0 green:115/255.0 blue:115/255.0 alpha:0.5];
//        [[UIApplication sharedApplication].keyWindow.rootViewController.view insertSubview:_maskView belowSubview:self];
        
    }
    return self;
}

- (void)setFrame:(CGRect)frame{
    CGRect newframe = frame;
    newframe.size.height = 30 + [UIScreen mainScreen].bounds.size.width / 4 * 2 + 20 + 30 + 20 + 30 + 10;
    [super setFrame:newframe];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.shareViewTitleLabel.frame = CGRectMake(0, 10, self.frame.size.width, 20);
    self.shareTargetCollectionView.frame = CGRectMake(0, CGRectGetMaxY(self.shareViewTitleLabel.frame), self.frame.size.width, self.frame.size.width / 4 * 2);
    self.sharePageControl.frame = CGRectMake(0, CGRectGetMaxY(self.shareTargetCollectionView.frame), self.frame.size.width, 20);
    self.collectButton.frame = CGRectMake(10, CGRectGetMaxY(self.sharePageControl.frame), self.frame.size.width - 20, 30);
    self.cancelButton.frame = CGRectMake(10, CGRectGetMaxY(self.collectButton.frame) + 20, self.frame.size.width - 20, 30);
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGFloat setOffX = scrollView.contentOffset.x;
    NSInteger page = setOffX/scrollView.bounds.size.width;
    self.sharePageControl.currentPage = page;
}


#pragma mark -- public method
- (void)hiddenShareViewWithAnimation:(BOOL)animation direction:(ZHRBReportsShareViewAnimation)direction{
    if (animation) {
        
        if (direction == ZHRBReportsShareViewAnimationBottom) {
            
            
            
        }
        
    }
}


#pragma mark - event response
- (void)cancelButtonAction{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didCancelAction)]) {
        [self.delegate didCancelAction];
    }
    
}

- (void)collectButtonAction{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didCollectionAction)]) {
        [self.delegate didCollectionAction];
    }
}


#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.shareItemsTable.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ZHRBReportsShareCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kShareCell forIndexPath:indexPath];
    cell.shareItems = self.shareItemsTable[indexPath.row];
    return cell;
}


#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(collectionView.frame.size.width / 4, collectionView.frame.size.width / 4);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}


#pragma mark - getters and setters
- (NSArray *)shareItemsTable{
    if (_shareItemsTable == nil) {
        _shareItemsTable = @[@{@"title":@"微信好友",@"image":@"weixin"},@{@"title":@"微信朋友圈",@"image":@"weixin"},
                            @{@"title":@"QQ",@"image":@"qq"}, @{@"title":@"新浪微博",@"image":@"weibo"},
                            @{@"title":@"复制链接",@"image":@"qq"},@{@"title":@"电子邮件",@"image":@"weibo"},
                            @{@"title":@"有道云笔记",@"image":@"weixin"},@{@"title":@"印象笔记",@"image":@"qq"},
                            @{@"title":@"腾讯微博",@"image":@"weibo"},@{@"title":@"信息",@"image":@"weixin"},
                            @{@"title":@"Instapaper",@"image":@"qq"},@{@"title":@"Facebook",@"image":@"weibo"},
                            @{@"title":@"1",@"image":@"weixin"},@{@"title":@"2",@"image":@"qq"},
                            @{@"title":@"3",@"image":@"weibo"}, @{@"title":@"4",@"image":@"weixin"}];
    }
    return _shareItemsTable;
}

@end
