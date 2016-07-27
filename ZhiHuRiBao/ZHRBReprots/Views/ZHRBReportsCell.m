//
//  ZHRBReportsCell.m
//  ZhiHuRiBao
//
//  Created by kehwa on 16/7/21.
//  Copyright © 2016年 kehwa. All rights reserved.
//

#import "ZHRBReportsCell.h"
#import "OMNetworkingConfiguration.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <Masonry/Masonry.h>
@interface ZHRBReportsCell()

@property (nonatomic , strong)UILabel *titleLabel;
@property (nonatomic , strong)UIImageView *pictureImageView;

@end

@implementation ZHRBReportsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.numberOfLines = 0;
        [_titleLabel sizeToFit];
        [self.contentView addSubview:_titleLabel];
        
        
        _pictureImageView = [[UIImageView alloc]init];
        _pictureImageView.backgroundColor = RGB(235, 235, 243);
        [self.contentView addSubview:_pictureImageView];
        
        
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self.pictureImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@10);
        make.bottom.equalTo(@(-10));
        make.width.equalTo(@60);
        make.right.equalTo(@(-10));
    }];
    
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(@10);
        make.top.equalTo(@10);
        make.right.equalTo(self.pictureImageView.mas_left).with.offset(-10);
        make.bottom.lessThanOrEqualTo(@(-10));
        
    }];
    
    
}

- (void)setReports:(NSDictionary *)reports{
    _reports = reports;
    
    [self.pictureImageView sd_setImageWithURL:[NSURL URLWithString:reports[@"images"][0]]];
    self.titleLabel.text = reports[@"title"];
    
}


@end
