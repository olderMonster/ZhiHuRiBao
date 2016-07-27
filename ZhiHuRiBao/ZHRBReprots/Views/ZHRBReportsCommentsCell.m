//
//  ZHRBReportsCommentsCell.m
//  ZhiHuRiBao
//
//  Created by kehwa on 16/7/25.
//  Copyright © 2016年 kehwa. All rights reserved.
//

#import "ZHRBReportsCommentsCell.h"
#import "OMNetworkingConfiguration.h"
#import <Masonry/Masonry.h>
#import <SDWebImage/UIImageView+WebCache.h>
@interface ZHRBReportsCommentsCell()

@property (nonatomic , strong)UIImageView *avatarImageView;
@property (nonatomic , strong)UILabel *nickNameLabel;
@property (nonatomic , strong)UIImageView *applaudImageView;
@property (nonatomic , strong)UILabel *applaudCountLabel;
@property (nonatomic , strong)UILabel *commentsLabel;
@property (nonatomic , strong)UILabel *commentTimeLabel;

@end


@implementation ZHRBReportsCommentsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
        _avatarImageView = [[UIImageView alloc]init];
        _avatarImageView.layer.masksToBounds = YES;
        [self.contentView addSubview:_avatarImageView];
        
        
        _nickNameLabel = [[UILabel alloc]init];
        _nickNameLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_nickNameLabel];
        
        _applaudImageView = [[UIImageView alloc]init];
        [self.contentView addSubview:_applaudImageView];
        
        _applaudCountLabel = [[UILabel alloc]init];
        _applaudCountLabel.font = [UIFont systemFontOfSize:10];
        [self.contentView addSubview:_applaudCountLabel];
        
        _commentsLabel = [[UILabel alloc]init];
        _commentsLabel.font = [UIFont systemFontOfSize:12];
        _commentsLabel.numberOfLines = 0;
        [_commentsLabel sizeToFit];
        [self.contentView addSubview:_commentsLabel];
        
        _commentTimeLabel = [[UILabel alloc]init];
        _commentTimeLabel.font = [UIFont systemFontOfSize:10];
        [self.contentView addSubview:_commentTimeLabel];
        
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self setSubviewsFrame];
    
}


- (void)setSubviewsFrame{
    WS(weakSelf);
    
    [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@10);
        make.top.equalTo(@10);
        make.width.equalTo(@30);
        make.height.equalTo(weakSelf.avatarImageView.mas_width);
    }];
    self.avatarImageView.layer.cornerRadius = self.avatarImageView.bounds.size.width * 0.5;
    
    
    [self.nickNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(weakSelf.avatarImageView.mas_right).with.offset(10);
        make.top.equalTo(weakSelf.avatarImageView);
        
    }];
    
    
    [self.applaudCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(weakSelf.nickNameLabel.mas_centerY);
        make.right.equalTo(@(-10));
        
    }];
    
    [self.applaudImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.applaudCountLabel.mas_left).with.offset(-5);
        make.centerY.equalTo(weakSelf.nickNameLabel.mas_centerY);
        make.width.equalTo(@15);
        make.height.equalTo(weakSelf.applaudImageView.mas_width);
    }];
    
    
    [self.commentsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(weakSelf.nickNameLabel);
        make.top.equalTo(weakSelf.nickNameLabel.mas_bottom).with.offset(10);
        make.right.equalTo(@(-10));
    }];
    
    
    [self.commentTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.commentsLabel);
        make.top.equalTo(weakSelf.commentsLabel.mas_bottom).with.offset(10);
        make.bottom.equalTo(@(-5));
    }];
}

- (void)setComment:(NSDictionary *)comment{
    
    _comment = comment;
    
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:comment[@"avatar"]]];
    self.nickNameLabel.text = comment[@"author"];
    self.applaudCountLabel.text = [NSString stringWithFormat:@"%@",comment[@"likes"]];
    self.commentsLabel.text = comment[@"content"];
    self.commentTimeLabel.text = [NSString stringWithFormat:@"%@",comment[@"time"]];
    
}


//使用计算frame模式的时候，需要在cell里面实现sizeThatFits这个方法
//- (CGSize)sizeThatFits:(CGSize)size {
//    CGFloat totalHeight = 0;
//    totalHeight += [self.avatarImageView sizeThatFits:size].height;
//    totalHeight += [self.commentsLabel sizeThatFits:size].height;
//    totalHeight += [self.commentTimeLabel sizeThatFits:size].height;
//    totalHeight += 40; // margins
//    return CGSizeMake(size.width, totalHeight);
//}

@end
