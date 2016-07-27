//
//  PDRequestGenerator.m
//  仿熊猫TV
//
//  Created by kehwa on 16/5/4.
//  Copyright © 2016年 kehwa. All rights reserved.
//

#import "OMRequestGenerator.h"

@interface OMRequestGenerator()

@property (nonatomic , strong)AFHTTPRequestSerializer *requestSerializer;

@end

@implementation OMRequestGenerator

+ (instancetype)sharedInstance{
    static OMRequestGenerator *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[OMRequestGenerator alloc]init];

    });
    return  sharedInstance;
}

- (NSURLRequest *)generateGETRequestWidthServiceIdentifier:(NSString *)serviceIdentifier requestParams:(NSDictionary *)requestParams methodName:(NSString *)methodName{
    OMService *service = [[OMServiceFactory sharedInstance] serviceWithIdentifier:serviceIdentifier];
    
    NSMutableDictionary *sigParams = [NSMutableDictionary dictionaryWithDictionary:requestParams];
//    sigParams[@"api_key"] = service.publicKey;
//    NSString *signature = [PDSignatureGenerator signGetWithSigParams:sigParams methodName:methodName apiVerison:service.apiVersion privateKey:service.privateKey publicKey:service.publicKey];
    
    NSMutableDictionary *allParams = [NSMutableDictionary dictionaryWithDictionary:[OMCommonParamsGenerator commonParamsDictionary]];
    [allParams addEntriesFromDictionary:sigParams];
    NSString *urlString = [NSString stringWithFormat:@"%@/%@?%@",service.apiBaseUrl,methodName,[allParams PD_urlParamsStringSignature:NO]];
    
    NSMutableURLRequest *request = [self.requestSerializer requestWithMethod:@"GET" URLString:urlString parameters:nil error:NULL];
    request.timeoutInterval = kOMNetworkingTimeoutSeconds; //请求超时的时间
    request.requestParams = requestParams;
    return request;
}

- (NSURLRequest *)generatePOSTRequestWidthServiceIdentifier:(NSString *)serviceIdentifier requestParams:(NSDictionary *)requestParams methodName:(NSString *)methodName{
    OMService *service = [[OMServiceFactory sharedInstance] serviceWithIdentifier:serviceIdentifier];
//    NSString *signature = [PDSignatureGenerator signPostWithAllParams:requestParams privateKey:service.privateKey publicKey:service.publicKey];
//    NSString *urlString = [NSString stringWithFormat:@"%@%@/%@?api_key=%@&sig=%@&%@",service.apiBaseUrl,service.apiVersion,methodName,service.publicKey,signature,[[PDCommonParamsGenerator commonParamsDictionary] PD_urlParamsStringSignature:NO]];
    NSString *urlString = [NSString stringWithFormat:@"%@/%@?%@",service.apiBaseUrl,methodName,[[OMCommonParamsGenerator commonParamsDictionary] PD_urlParamsStringSignature:NO]];
    
    NSURLRequest *request = [self.requestSerializer requestWithMethod:@"POST" URLString:urlString parameters:requestParams error:NULL];
    request.requestParams = requestParams;
    return request;
}


- (NSURLRequest *)generateRestfulGETRequestWidthServiceIdentifier:(NSString *)serviceIdentifier requestParams:(NSDictionary *)requestParams methodName:(NSString *)methodName{
    
    NSMutableDictionary *allParams = [NSMutableDictionary dictionaryWithDictionary:[OMCommonParamsGenerator commonParamsDictionary]];
    [allParams addEntriesFromDictionary:requestParams];
    
    OMService *service = [[OMServiceFactory sharedInstance] serviceWithIdentifier:serviceIdentifier];
    NSString *signature = [OMSignatureGenerator signRestfulGetWithAllParams:allParams methodName:methodName apiVerison:service.apiVersion privateKey:service.privateKey];
    NSString *urlString = [NSString stringWithFormat:@"%@%@/%@?%@",service.apiBaseUrl,service.apiVersion,methodName,[allParams PD_urlParamsStringSignature:NO]];
    
    NSDictionary *restfulHeader = [self commRESTHeadersWithService:service signature:signature];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:kOMNetworkingTimeoutSeconds];
    request.HTTPMethod = @"GET";
    [restfulHeader enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [request setValue:obj forHTTPHeaderField:key];
    }];
    request.HTTPBody = [NSJSONSerialization dataWithJSONObject:requestParams options:NSJSONWritingPrettyPrinted error:NULL];
    request.requestParams = requestParams;
    return request;
}

- (NSURLRequest *)generateRestfulPOSTRequestWidthServiceIdentifier:(NSString *)serviceIdentifier requestParams:(NSDictionary *)requestParams methodName:(NSString *)methodName{
    NSMutableDictionary *allParams = [NSMutableDictionary dictionaryWithDictionary:[OMCommonParamsGenerator commonParamsDictionary]];
    [allParams addEntriesFromDictionary:requestParams];
    
    OMService *service = [[OMServiceFactory sharedInstance] serviceWithIdentifier:serviceIdentifier];
    NSString *signature = [OMSignatureGenerator signRestfulGetWithAllParams:allParams methodName:methodName apiVerison:service.apiVersion privateKey:service.privateKey];
    NSString *urlString = [NSString stringWithFormat:@"%@%@/%@?%@",service.apiBaseUrl,service.apiVersion,methodName,[allParams PD_urlParamsStringSignature:NO]];
    
    NSDictionary *restfulHeader = [self commRESTHeadersWithService:service signature:signature];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:kOMNetworkingTimeoutSeconds];
    request.HTTPMethod = @"POST";
    [restfulHeader enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [request setValue:obj forHTTPHeaderField:key];
    }];
    request.HTTPBody = [NSJSONSerialization dataWithJSONObject:requestParams options:NSJSONWritingPrettyPrinted error:NULL];
    request.requestParams = requestParams;
    return request;
}

#pragma mark - private methods
- (NSDictionary *)commRESTHeadersWithService:(OMService *)service signature:(NSString *)signature
{
    NSMutableDictionary *headerDic = [NSMutableDictionary dictionary];
    [headerDic setValue:signature forKey:@"sig"];
    [headerDic setValue:service.publicKey forKey:@"key"];
    [headerDic setValue:@"application/json" forKey:@"Accept"];
    [headerDic setValue:@"application/json" forKey:@"Content-Type"];
    NSDictionary *loginResult = [[NSUserDefaults standardUserDefaults] objectForKey:@"______"];
    if (loginResult[@"auth_token"]) {
        [headerDic setValue:loginResult[@"auth_token"] forKey:@"AuthToken"];
    }
    return headerDic;
}



#pragma mark -- getters and setters
- (AFHTTPRequestSerializer *)requestSerializer{
    if (_requestSerializer == nil) {
        _requestSerializer = [AFHTTPRequestSerializer serializer];
        _requestSerializer.timeoutInterval = 20.0f; //超时时间
        _requestSerializer.cachePolicy = NSURLRequestUseProtocolCachePolicy;
    }
    return _requestSerializer;
}

@end
