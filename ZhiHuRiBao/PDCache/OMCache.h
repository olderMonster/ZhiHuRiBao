//
//  PDCache.h
//  仿熊猫TV
//
//  Created by kehwa on 16/5/6.
//  Copyright © 2016年 kehwa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OMNetworkingConfiguration.h"
#import "OMCacheObject.h"
#import "NSDictionary+PDNetworkingMethods.h"
@interface OMCache : NSObject

+ (instancetype)sharedInstance;

//生成key
- (NSString *)keyWithServiceIdentifier:(NSString *)serviceIdentifier methodName:(NSString *)method requestParams:(NSDictionary *)requestParams;

//获取缓存的数据
- (NSData *)fetchCacheDataWithServiceIdentifier:(NSString *)serviceIdentifier methodName:(NSString *)methodName requestParams:(NSDictionary *)requestParams;
//将数据缓存
- (void)saveCacheWithData:(NSData *)cachedData serviceIdentifier:(NSString *)serviceIdentifier methodName:(NSString *)methodName requestParams:(NSDictionary *)requestParams;
//删除缓存的数据
- (void)deleteCacheWithServiceIdentifier:(NSString *)serviceIdentifier methodName:(NSString *)methodName requestParams:(NSDictionary *)requestParams;
//获取缓存的数据
- (NSData *)fetchCachedDataWithKey:(NSString *)key;
//将数据缓存
- (void)saveCacheWithData:(NSData *)cacheData key:(NSString *)key;
//删除缓存的数据
- (void)deleteCacheWithKey:(NSString *)key;

//清空所有缓存
- (void)clean;


@end
