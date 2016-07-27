//
//  PDApiProxy.m
//  仿熊猫TV
//
//  Created by kehwa on 16/5/4.
//  Copyright © 2016年 kehwa. All rights reserved.
//

#import "OMApiProxy.h"
#import "OMRequestGenerator.h"
@interface OMApiProxy()

@property (nonatomic , strong)AFHTTPSessionManager *sessionManager;

@property (nonatomic , strong)NSNumber *recoredRequestId;

@property (nonatomic , strong)NSMutableDictionary *dispatchTable;

@end

@implementation OMApiProxy

+ (instancetype)sharedInstance{
    
    static dispatch_once_t onceToken;
    static OMApiProxy *sharedInstance = nil;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[OMApiProxy alloc]init];
    });
    return sharedInstance;
    
}

#pragma mark -- public method

- (NSInteger)callGETWithParams:(NSDictionary *)params serviceIdentifier:(NSString *)serviceIdntifier methodName:(NSString *)methodName success:(PDCallback)success failure:(PDCallback)failure{
    
    NSURLRequest *request = [[OMRequestGenerator sharedInstance] generateGETRequestWidthServiceIdentifier:serviceIdntifier requestParams:params methodName:methodName];
    NSNumber *requestId = [self callApiWithRequest:request success:success failure:failure];
    return [requestId integerValue];
}

- (NSInteger)callPOSTWithParams:(NSDictionary *)params serviceIdentifier:(NSString *)serviceIdntifier methodName:(NSString *)methodName success:(PDCallback)success failure:(PDCallback)failure{
    NSURLRequest *request = [[OMRequestGenerator sharedInstance] generatePOSTRequestWidthServiceIdentifier:serviceIdntifier requestParams:params methodName:methodName];
    NSNumber *requestId = [self callApiWithRequest:request success:success failure:failure];
    return [requestId integerValue];
}

- (NSInteger)callRestfulGETWithParams:(NSDictionary *)params serviceIdentifier:(NSString *)serviceIdntifier methodName:(NSString *)methodName success:(PDCallback)success failure:(PDCallback)failure{
    NSURLRequest *request = [[OMRequestGenerator sharedInstance] generatePOSTRequestWidthServiceIdentifier:serviceIdntifier requestParams:params methodName:methodName];
    NSNumber *requestId = [self callApiWithRequest:request success:success failure:failure];
    return [requestId integerValue];
}
- (NSInteger)callRestfulPOSTWithParams:(NSDictionary *)params serviceIdentifier:(NSString *)serviceIdntifier methodName:(NSString *)methodName success:(PDCallback)success failure:(PDCallback)failure{
    NSURLRequest *request = [[OMRequestGenerator sharedInstance] generatePOSTRequestWidthServiceIdentifier:serviceIdntifier requestParams:params methodName:methodName];
    NSNumber *requestId = [self callApiWithRequest:request success:success failure:failure];
    return [requestId integerValue];
}


- (void)cancelRequestWithRequestId:(NSNumber *)requestId{
    NSURLSessionDataTask * task = self.dispatchTable[requestId];
    [task cancel];
    [self.dispatchTable removeObjectForKey:requestId];
}


- (void)cancelRequsetWithRequestList:(NSArray *)requestList{
    for (NSNumber *requestId in requestList) {
        [self cancelRequestWithRequestId:requestId];
    }
}

#pragma mark -- private method
- (NSNumber *)callApiWithRequest:(NSURLRequest *)request success:(PDCallback)success failure:(PDCallback)failure{
    NSNumber *requestId = [self generteRequestId];
    
    // 跑到这里的block的时候，就已经是主线程了。
    NSURLSessionDataTask *dataTask=[self.sessionManager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        NSURLSessionDataTask *storedTask = self.dispatchTable[requestId];
        if (storedTask == nil) {
            // 如果这个operation是被cancel的，那就不用处理回调了。
            return;
        }else{
            [self.dispatchTable removeObjectForKey:requestId];
        }
        
        
        
        NSString *responseString = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        
//        NSLog(@"responseObject ===>> %@",responseString);
        
        if (!error) {
            OMApiResponse *response = [[OMApiResponse alloc]initWithResponseString:responseString requestId:requestId request:request responseData:responseObject status:OMApiResponseStatusSuccess];
            
            success?success(response):nil;
        }else{
            OMApiResponse *response = [[OMApiResponse alloc]initWithResponseString:responseString requestId:requestId request:request responseData:responseObject error:error];
            failure?failure(response):nil;
        }
        
    }];
    self.dispatchTable[requestId] = dataTask;
    [dataTask resume];
    return requestId;
}

- (NSNumber *)generteRequestId{
    if (_recoredRequestId == nil) {
        _recoredRequestId = @(1);
    }else{
        if ([_recoredRequestId integerValue] == NSIntegerMax) {
            _recoredRequestId = @(1);
        }else{
            _recoredRequestId = @([_recoredRequestId integerValue] + 1);
        }
    }
    return _recoredRequestId;
}


#pragma mark -- getters and setters
- (AFHTTPSessionManager *)sessionManager{
    if (_sessionManager == nil) {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        _sessionManager = [[AFHTTPSessionManager alloc]initWithBaseURL:nil sessionConfiguration:configuration];
        _sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    }
    return _sessionManager;
}


- (NSMutableDictionary *)dispatchTable{
    if (_dispatchTable == nil) {
        _dispatchTable = [[NSMutableDictionary alloc]init];
    }
    return _dispatchTable;
}

@end
