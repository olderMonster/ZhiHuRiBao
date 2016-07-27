//
//  ZHRBReportsShareCell.m
//  ZhiHuRiBao
//
//  Created by kehwa on 16/7/25.
//  Copyright © 2016年 kehwa. All rights reserved.
//

#import "ZHRBReportsShareCell.h"

@interface ZHRBReportsShareCell()

@property (nonatomic , strong)UIImageView *itemImageView;
@property (nonatomic , strong)UILabel *itemLabel;

@end


@implementation ZHRBReportsShareCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        _itemImageView = [[UIImageView alloc]init];
//        _itemImageView.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:_itemImageView];
        
        
        _itemLabel = [[UILabel alloc]init];
//        _itemLabel.backgroundColor = [UIColor redColor];
        _itemLabel.font = [UIFont systemFontOfSize:12];
        _itemLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_itemLabel];
        
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.itemLabel.frame = CGRectMake(0, self.contentView.bounds.size.height - 20, self.contentView.bounds.size.width, 20);

    self.itemImageView.bounds = CGRectMake(0, 0, (self.itemLabel.frame.origin.y - 5 - 15), (self.itemLabel.frame.origin.y - 5 - 15));
    self.itemImageView.center = CGPointMake(self.contentView.center.x, 15 + self.itemImageView.bounds.size.height*0.5);
}

- (void)setShareItems:(NSDictionary *)shareItems{
    _shareItems = shareItems;
    
    self.itemLabel.text = shareItems[@"title"];
    self.itemImageView.image = [UIImage imageNamed:shareItems[@"image"]];
}


@end
