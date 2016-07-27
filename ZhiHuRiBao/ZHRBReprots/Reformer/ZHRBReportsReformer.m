//
//  ZHRBReportsReformer.m
//  ZhiHuRiBao
//
//  Created by kehwa on 16/7/21.
//  Copyright © 2016年 kehwa. All rights reserved.
//

#import "ZHRBReportsReformer.h"
#import "NSString+PDNetworkingMethods.h"
@implementation ZHRBReportsReformer


//处理时间串
- (id)manager:(OMBaseApiManager *)manager reformData:(NSDictionary *)data{
    NSMutableDictionary *responseData = [NSMutableDictionary dictionaryWithDictionary:data];
    NSString *responseDate = @"";
    
    NSString *date = data[@"date"];
    NSString *todayStr = [NSString getDateString:[NSDate date]];
    if ([todayStr isEqualToString:date]) {
        responseDate = @"今日热闻";
    }else{
        responseDate = [date getWeekDay];
    }
    responseData[@"date"] = responseDate;
    return responseData;
}


@end
