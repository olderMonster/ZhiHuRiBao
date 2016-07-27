//
//  PDApiResponse.m
//  仿熊猫TV
//
//  Created by kehwa on 16/5/4.
//  Copyright © 2016年 kehwa. All rights reserved.
//

#import "OMApiResponse.h"
#import "NSURLRequest+PDNetworkingMethods.h"
@interface OMApiResponse()

@property (nonatomic , assign , readwrite)OMApiResponseStatus status;
@property (nonatomic , copy ,readwrite)NSString *contentString;
@property (nonatomic , copy , readwrite)id content;
@property (nonatomic , assign ,readwrite)NSInteger requestId;
@property (nonatomic , copy , readwrite)NSURLRequest *request;
@property (nonatomic , copy , readwrite)NSData *responseData;
@property (nonatomic , assign , readwrite)BOOL isCache;  //是否是缓存数据

@end

@implementation OMApiResponse

//请求成功时的response
- (instancetype)initWithResponseString:(NSString *)responseString requestId:(NSNumber *)requestId request:(NSURLRequest *)request
                          responseData:(NSData *)responseData status:(OMApiResponseStatus)status{
    self = [super init];
    if (self) {
        self.status = status;
        self.contentString = responseString;
        self.content = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:NULL];
        self.requestId = [requestId integerValue];
        self.request = request;
        self.responseData = responseData;
        self.requestParams = request.requestParams;
        self.isCache = NO; //非缓存数据
        
    }
    return self;
    
}
//请求失败时的response
- (instancetype)initWithResponseString:(NSString *)responseString requestId:(NSNumber *)requestId request:(NSURLRequest *)request responseData:(NSData *)responseData error:(NSError *)error{
    self = [super init];
    if (self) {
        self.contentString = responseString;
        self.status = [self responseStatusWithError:error];
        self.requestId = [requestId integerValue];
        self.request = request;
        self.responseData = responseData;
        self.requestParams = request.requestParams;
        self.isCache = NO;
        
        if (responseData) {
            self.content = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:NULL];
        }else{
            self.content = nil;
        }
    }
    return self;
}


- (instancetype)initWithData:(NSData *)data
{
    self = [super init];
    if (self) {
        self.contentString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        self.status = [self responseStatusWithError:nil];
        self.requestId = 0;
        self.request = nil;
        self.responseData = [data copy];
        self.content = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:NULL];
        self.isCache = YES;
    }
    return self;
}

#pragma mark - private methods
- (OMApiResponseStatus)responseStatusWithError:(NSError *)error
{
    if (error) {
        OMApiResponseStatus result = OMApiResponseStatusErrorNoNetwork;
        
        // 除了超时以外，所有错误都当成是无网络
        if (error.code == NSURLErrorTimedOut) {
            result = OMApiResponseStatusErrorNoNetwork;
        }
        return result;
    } else {
        return OMApiResponseStatusSuccess;
    }
}

@end
