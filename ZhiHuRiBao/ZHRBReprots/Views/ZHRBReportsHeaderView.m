//
//  ZHRBReportsHeaderView.m
//  ZhiHuRiBao
//
//  Created by kehwa on 16/7/22.
//  Copyright © 2016年 kehwa. All rights reserved.
//

#import "ZHRBReportsHeaderView.h"

@implementation ZHRBReportsHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
    
        
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.textLabel.center = self.contentView.center;
}

@end
