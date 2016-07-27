//
//  PDApiResponse.h
//  仿熊猫TV
//
//  Created by kehwa on 16/5/4.
//  Copyright © 2016年 kehwa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OMNetworkingConfiguration.h"
@interface OMApiResponse : NSObject

@property (nonatomic , assign , readonly)OMApiResponseStatus status;
@property (nonatomic , copy , readonly)NSString *contentString;
@property (nonatomic , copy , readonly)id content;
@property (nonatomic , assign , readonly)NSInteger requestId;
@property (nonatomic , copy , readonly)NSURLRequest *request;
@property (nonatomic , copy , readonly)NSData *responseData;
@property (nonatomic , copy)NSDictionary *requestParams;
@property (nonatomic , assign , readonly)BOOL isCache;  //是否是缓存数据

//请求成功时的response
- (instancetype)initWithResponseString:(NSString *)responseString requestId:(NSNumber *)requestId request:(NSURLRequest *)request
                          responseData:(NSData *)responseData status:(OMApiResponseStatus)status;
//请求失败时的response
- (instancetype)initWithResponseString:(NSString *)responseString requestId:(NSNumber *)requestId request:(NSURLRequest *)request responseData:(NSData *)responseData error:(NSError *)error;

// 使用initWithData的response，它的isCache是YES，上面两个函数生成的response的isCache是NO
- (instancetype)initWithData:(NSData *)data;

@end
