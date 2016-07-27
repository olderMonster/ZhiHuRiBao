//
//  ZHRBBeforeReportsManager.m
//  ZhiHuRiBao
//
//  Created by kehwa on 16/7/21.
//  Copyright © 2016年 kehwa. All rights reserved.
//

#import "ZHRBBeforeReportsManager.h"
#import "NSString+PDNetworkingMethods.h"
@interface ZHRBBeforeReportsManager()

@property (nonatomic , copy)NSString *newsTime;

@end

@implementation ZHRBBeforeReportsManager

- (instancetype)init{
    self = [super init];
    if (self) {
        NSString *todayDate = [NSString getDateString:[NSDate date]];
        NSString *yesterdayDate = [todayDate getYesterdayDateString];
        self.newsTime = yesterdayDate;
        self.validator = self;
    }
    return self;
}

- (NSString *)methodName{
    return [NSString stringWithFormat:@"news/before/%@",self.newsTime];
}

- (OMAPIManagerRequestType)requestType{
    return OMAPIManagerRequestTypeGet;
}

- (NSString *)serviceType{
    return kZHRBService;
}

- (NSDictionary *)reformParams:(NSDictionary *)params{
    NSMutableDictionary *apiParams = [NSMutableDictionary dictionaryWithDictionary:params];
    return apiParams;
}

#pragma mark - OMApiManagerValidator
- (BOOL)manager:(OMBaseApiManager *)manager isCorrectWithParamsData:(NSDictionary *)params{
    return YES;
}
- (BOOL)manager:(OMBaseApiManager *)manager isCorrectWithCallBackData:(NSDictionary *)responseData{
    NSString *date = responseData[@"date"];
    self.newsTime = [date getYesterdayDateString];
//    NSLog(@"%@",date);
    NSLog(@"%@",self.newsTime);
    
    return YES;
}

@end
