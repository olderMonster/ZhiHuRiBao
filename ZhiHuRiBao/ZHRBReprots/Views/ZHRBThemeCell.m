//
//  ZHRBThemeCell.m
//  ZhiHuRiBao
//
//  Created by kehwa on 16/7/28.
//  Copyright © 2016年 kehwa. All rights reserved.
//

#import "ZHRBThemeCell.h"

@interface ZHRBThemeCell()

@property (nonatomic , strong)UIButton *addButton;

@end


@implementation ZHRBThemeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        self.selectedBackgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"menubg"]];
        
        _addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addButton setBackgroundImage:[UIImage imageNamed:@"Menu_Follow"] forState:UIControlStateNormal];
        [self.contentView addSubview:_addButton];
        
    }
    return self;
}


- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.addButton.bounds = CGRectMake(0, 0, 20, 20);
    self.addButton.center = CGPointMake(self.contentView.frame.size.width - 30 - 10, self.contentView.center.y);
    
}

@end
