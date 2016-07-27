//
//  OMBaseApiManager.m
//  仿熊猫TV
//
//  Created by kehwa on 16/5/4.
//  Copyright © 2016年 kehwa. All rights reserved.
//

#import "OMBaseApiManager.h"
#import "OMCache.h"
#import "OMAppContext.h"
#import "OMApiProxy.h"
#import "OMNetworkingConfiguration.h"
#define OMCallAPI(REQUEST_METHOD,REQUEST_ID){\
REQUEST_ID =[[OMApiProxy sharedInstance] call##REQUEST_METHOD##WithParams:apiParams serviceIdentifier:self.child.serviceType methodName:self.child.methodName success:^(OMApiResponse *response) {\
    [self successedCallingOnApi:response];\
} failure:^(OMApiResponse *response) {\
    [self failedOnCallingApi:response withErrorType:OMAPIManagerErrorTypeDefault];\
}];\
[self.requestIdList addObject:@(REQUEST_ID)];\
}\

@interface OMBaseApiManager()

@property (nonatomic , readwrite)OMAPIManagerErrorType errorType;
@property (nonatomic , copy , readwrite)NSString *errorMessage;

@property (nonatomic , strong)OMCache *cache;
@property (nonatomic , strong)NSMutableArray *requestIdList;
@property (nonatomic , strong)id fetchRawData;

@end

@implementation OMBaseApiManager

#pragma mark -- life cycle
- (instancetype)init{
    self = [super init];
    if (self) {
        _callBackDelegate = nil;
        _validator = nil;
        _sourceDelegate = nil;
        
        _errorMessage = nil;
        _errorType = OMAPIManagerErrorTypeDefault;
        
        if ([self conformsToProtocol:@protocol(OMApiManager)]) {
            self.child = (id<OMApiManager>)self;
        }
    }
    return self;
}


#pragma mark -- public method
- (NSInteger)loadData{
    
    NSDictionary *params = [self.sourceDelegate paramsForApi:self];
    NSInteger requestId = [self loadDataWithParams:params];
    return requestId;
}

- (void)cancelAllRequests{
    [[OMApiProxy sharedInstance] cancelRequsetWithRequestList:self.requestIdList];
    [self.requestIdList removeAllObjects];
}


- (void)cancelRequestWithRequestId:(NSInteger)requestId{
    [self removeRequestIdWithRequestId:requestId];
    [[OMApiProxy sharedInstance] cancelRequestWithRequestId:@(requestId)];
}


- (BOOL)isLoading{
    return [self.requestIdList count]>0;
}


#pragma mark -- private method
- (NSInteger)loadDataWithParams:(NSDictionary *)params{
    NSInteger requestId = 0;
    NSDictionary *apiParams = [self reformParams:params];
    if ([self shouldCallApiWithParams:apiParams]) {
        //对参数进行验证
        if ([self.validator manager:self isCorrectWithParamsData:apiParams]) {
            
            //检测缓存
            if ([self shouldCache] && [self hasCacheWithApiParams:apiParams]) {
                return 0;
            }
            //网络畅通
            if ([self isReachable]) {
                switch (self.child.requestType) {
                    case OMAPIManagerRequestTypeGet:
                        OMCallAPI(GET, requestId);
                        break;
                    case OMAPIManagerRequestTypePost:
                        OMCallAPI(POST, requestId);
                        break;
                    case OMAPIManagerRequestTypeRestGet:
                        OMCallAPI(RestfulGET, requestId);
                        break;
                    case OMAPIManagerRequestTypeRestPost:
                        OMCallAPI(RestfulPOST, requestId);
                        break;
                    default:
                        break;
                }
                
                NSMutableDictionary *params = [apiParams mutableCopy];
                params[kOMApiBaseManagerRequestId] = @(requestId);
                [self afterCallingApiWithParams:params];
                return requestId;
                
            }else{ //网络不通
                [self failedOnCallingApi:nil withErrorType:OMAPIManagerErrorTypeNoNetWork];
                return requestId;
            }
            
            
        }else{
            //参数错误
            [self failedOnCallingApi:nil withErrorType:OMAPIManagerErrorTypeParamsError];
        }
        
    }
    return requestId;
}

- (BOOL)hasCacheWithApiParams:(NSDictionary *)apiParams{
    NSString *serviceIdentifier = self.child.serviceType;
    NSString *methodName = self.child.methodName;
    NSData *result = [self.cache fetchCacheDataWithServiceIdentifier:serviceIdentifier methodName:methodName requestParams:apiParams];
    
    if (result == nil) {
        return NO;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        OMApiResponse *response = [[OMApiResponse alloc]initWithData:result];
        response.requestParams = apiParams;
        [self successedCallingOnApi:response];
    });
    return YES;
}

- (void)successedCallingOnApi:(OMApiResponse *)response{
    
    if (response.content) {
        self.fetchRawData = [response.content copy];
    }else{
        self.fetchRawData = [response.responseData copy];
    }
    [self removeRequestIdWithRequestId:response.requestId];
    if ([self.validator manager:self isCorrectWithCallBackData:response.content]) {
        
        if ([self shouldCache] && !response.isCache) {
            [self.cache saveCacheWithData:response.responseData serviceIdentifier:self.child.serviceType methodName:self.child.methodName requestParams:response.requestParams];
        }
        
        [self beforePerformSuccessWithResponse:response];
        [self.callBackDelegate managerCallApiDidSuccess:self];
        [self afterPerformSuccessWithResponse:response];
        
    }else{
        [self failedOnCallingApi:response withErrorType:OMAPIManagerErrorTypeNoContent];
    }
}


- (void)failedOnCallingApi:(OMApiResponse *)response withErrorType:(OMAPIManagerErrorType)errorType{
    
    self.errorType = errorType;
    [self beforePerformFailureWithResponse:response];
    [self.callBackDelegate managerCallApiDidFailure:self];
    [self afterPerformFailureWithResponse:response];
}

- (void)removeRequestIdWithRequestId:(NSInteger)requestId{
    NSNumber *requestIdToRemove = nil;
    for (NSNumber *storedRequestId in self.requestIdList) {
        if ([storedRequestId integerValue] == requestId) {
            requestIdToRemove = storedRequestId;
        }
    }
    if (requestIdToRemove) {
        [self.requestIdList removeObject:requestIdToRemove];
    }
}


#pragma mark -- OMApiManagerCallBackDataReformer

//数据转换
- (id)fetchDataWithReformer:(id<OMApiManagerCallBackDataReformer>)reformer{
    id resultData = nil;
    if ([reformer respondsToSelector:@selector(manager:reformData:)]) {
        //如果对数据进行了处理则将处理的数据返回
        resultData = [reformer manager:self reformData:self.fetchRawData];
    }else{
        //如果对数据进行了处理则将原数据返回
        resultData = [self.fetchRawData mutableCopy];
    }
    return  resultData;
}



#pragma mark -- OMApiManagerInterceptor
/*
 拦截器的功能可以由子类通过继承实现，也可以由其它对象实现,两种做法可以共存
 当两种情况共存的时候，子类重载的方法一定要调用一下super
 然后它们的调用顺序是BaseManager会先调用子类重载的实现，再调用外部interceptor的实现
 
 notes:
 正常情况下，拦截器是通过代理的方式实现的，因此可以不需要以下这些代码
 但是为了将来拓展方便，如果在调用拦截器之前manager又希望自己能够先做一些事情，所以这些方法还是需要能够被继承重载的
 所有重载的方法，都要调用一下super,这样才能保证外部interceptor能够被调到
 这就是decorate pattern
 */
- (void)beforePerformSuccessWithResponse:(OMApiResponse *)response{
    self.errorType = OMAPIManagerErrorTypeSuccess;
    if (self != self.interceptor && [self.interceptor respondsToSelector:@selector(manager:beforePerformSuccessWithResponse:)]) {
        [self.interceptor manager:self beforePerformSuccessWithResponse:response];
    }
}
- (void)afterPerformSuccessWithResponse:(OMApiResponse *)response{
    if (self != self.interceptor && [self.interceptor respondsToSelector:@selector(manager:afterPerformSuccessWithResponse:)]) {
        [self.interceptor manager:self afterPerformSuccessWithResponse:response];
    }
}


- (void)beforePerformFailureWithResponse:(OMApiResponse *)response{
    if (self != self.interceptor && [self.interceptor respondsToSelector:@selector(manager:beforePerformFailureWithResponse:)]) {
        [self.interceptor manager:self beforePerformFailureWithResponse:response];
    }
}
- (void)afterPerformFailureWithResponse:(OMApiResponse *)response{
    if (self != self.interceptor && [self.interceptor respondsToSelector:@selector(manager:beforePerformFailureWithResponse:)]) {
        [self.interceptor manager:self afterPerformFailureWithResponse:response];
    }
}

//只有返回YES才会继续调用API
- (BOOL)shouldCallApiWithParams:(NSDictionary *)params
{
    if (self != self.interceptor && [self.interceptor respondsToSelector:@selector(manager:shouldCallApiWithParams:)]) {
        return [self.interceptor manager:self shouldCallApiWithParams:params];
    } else {
        return YES;
    }
}

- (void)afterCallingApiWithParams:(NSDictionary *)params
{
    if (self != self.interceptor && [self.interceptor respondsToSelector:@selector(manager:afterCallingApiWithParams:)]) {
        [self.interceptor manager:self afterCallingApiWithParams:params];
    }
}


#pragma mark -- OMApiManager
- (void)cleanData{
    IMP childIMP = [self.child methodForSelector:@selector(cleanData)];
    IMP selfIMP = [self methodForSelector:@selector(cleanData)];
    
    if (childIMP == selfIMP) {
        self.fetchRawData = nil;
        self.errorMessage = nil;
        self.errorType = OMAPIManagerErrorTypeDefault;
    }else{
        if ([self.child respondsToSelector:@selector(cleanData)]) {
            [self.child cleanData];
        }
    }
}

//如果需要在调用API之前额外添加一些参数，比如pageNumber和pageSize之类的就在这里添加
//子类中覆盖这个函数的时候就不需要调用[super reformParams:params]了
- (NSDictionary *)reformParams:(NSDictionary *)params
{
    IMP childIMP = [self.child methodForSelector:@selector(reformParams:)];
    IMP selfIMP = [self methodForSelector:@selector(reformParams:)];
    
    if (childIMP == selfIMP) {
        return params;
    } else {
        // 如果child是继承得来的，那么这里就不会跑到，会直接跑子类中的IMP。
        // 如果child是另一个对象，就会跑到这里
        NSDictionary *result = nil;
        result = [self.child reformParams:params];
        if (result) {
            return result;
        } else {
            return params;
        }
    }
}

//默认不主动缓存数据
//只有在manager中主动设置为yes才缓存
- (BOOL)shouldCache{
    return kOMShouldCache;
}


#pragma mark -- getters and setters
- (OMCache *)cache{
    if (_cache == nil) {
        _cache = [OMCache sharedInstance];
    }
    return _cache;
}

- (NSMutableArray *)requestIdList{
    if(_requestIdList == nil){
        _requestIdList = [[NSMutableArray alloc]init];
    }
    return _requestIdList;
}


- (BOOL)isReachable{
    BOOL isReachablity = [OMAppContext sharedInstance].isReachable;
    if (!isReachablity) {
        self.errorType = OMAPIManagerErrorTypeNoNetWork;
    }
    return isReachablity;
}


@end
