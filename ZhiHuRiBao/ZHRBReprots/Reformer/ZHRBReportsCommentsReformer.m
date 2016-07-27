//
//  ZHRBReportsCommentsReformer.m
//  ZhiHuRiBao
//
//  Created by kehwa on 16/7/25.
//  Copyright © 2016年 kehwa. All rights reserved.
//

#import "ZHRBReportsCommentsReformer.h"
#import "ZHRBReportsLongCommentsManager.h"
#import "ZHRBReportsShortCommentsManager.h"

@interface ZHRBReportsCommentsReformer()

@property (nonatomic , strong)NSMutableArray *commentsTable;

@end


@implementation ZHRBReportsCommentsReformer

//处理时间串
- (id)manager:(OMBaseApiManager *)manager reformData:(NSDictionary *)data{
    
    NSMutableDictionary *tmpDict = [NSMutableDictionary dictionary];
    NSArray *comments = data[@"comments"];
    tmpDict[@"comments"] = comments;  //评论数据
    
    if ([manager isKindOfClass:[ZHRBReportsLongCommentsManager class]]) {
         tmpDict[@"show"] = @1;
        [self.commentsTable replaceObjectAtIndex:0 withObject:tmpDict];
    }else if ([manager isKindOfClass:[ZHRBReportsShortCommentsManager class]]){
         tmpDict[@"show"] = @0;
        [self.commentsTable replaceObjectAtIndex:1 withObject:tmpDict];
    }
    
    return self.commentsTable;
}


- (NSMutableArray *)commentsTable{
    if (_commentsTable == nil) {
        _commentsTable = [[NSMutableArray alloc]initWithArray:@[@"",@""]];
    }
    return _commentsTable;
}

@end
