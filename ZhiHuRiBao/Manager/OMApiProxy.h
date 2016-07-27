//
//  PDApiProxy.h
//  仿熊猫TV
//
//  Created by kehwa on 16/5/4.
//  Copyright © 2016年 kehwa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>
#import "OMApiResponse.h"
typedef void(^PDCallback)(OMApiResponse *response);
@interface OMApiProxy : NSObject

+ (instancetype)sharedInstance;

- (NSInteger)callGETWithParams:(NSDictionary *)params serviceIdentifier:(NSString *)serviceIdntifier methodName:(NSString *)methodName success:(PDCallback)success failure:(PDCallback)failure;
- (NSInteger)callPOSTWithParams:(NSDictionary *)params serviceIdentifier:(NSString *)serviceIdntifier methodName:(NSString *)methodName success:(PDCallback)success failure:(PDCallback)failure;

- (NSInteger)callRestfulGETWithParams:(NSDictionary *)params serviceIdentifier:(NSString *)serviceIdntifier methodName:(NSString *)methodName success:(PDCallback)success failure:(PDCallback)failure;
- (NSInteger)callRestfulPOSTWithParams:(NSDictionary *)params serviceIdentifier:(NSString *)serviceIdntifier methodName:(NSString *)methodName success:(PDCallback)success failure:(PDCallback)failure;


- (void)cancelRequestWithRequestId:(NSNumber *)requestId;
- (void)cancelRequsetWithRequestList:(NSArray *)requestList;

@end
