//
//  PDCache.m
//  仿熊猫TV
//
//  Created by kehwa on 16/5/6.
//  Copyright © 2016年 kehwa. All rights reserved.
//

#import "OMCache.h"
@interface OMCache()
@property (nonatomic , strong)NSCache *cache;
@end

@implementation OMCache

+ (instancetype)sharedInstance{
    static dispatch_once_t onceToken;
    static OMCache *sharedInstance = nil;
    dispatch_once(&onceToken, ^{
        sharedInstance =[[OMCache alloc]init];
    });
    return sharedInstance;
    
}


#pragma mark -- public method
- (NSData *)fetchCacheDataWithServiceIdentifier:(NSString *)serviceIdentifier methodName:(NSString *)methodName requestParams:(NSDictionary *)requestParams{
    return [self fetchCachedDataWithKey:[self keyWithServiceIdentifier:serviceIdentifier methodName:methodName requestParams:requestParams]];
}

- (void)saveCacheWithData:(NSData *)cachedData serviceIdentifier:(NSString *)serviceIdentifier methodName:(NSString *)methodName requestParams:(NSDictionary *)requestParams{
    [self saveCacheWithData:cachedData key:[self keyWithServiceIdentifier:serviceIdentifier methodName:methodName requestParams:requestParams]];
}
- (void)deleteCacheWithServiceIdentifier:(NSString *)serviceIdentifier methodName:(NSString *)methodName requestParams:(NSDictionary *)requestParams{
    [self deleteCacheWithKey:[self keyWithServiceIdentifier:serviceIdentifier methodName:methodName requestParams:requestParams]];
}


- (NSData *)fetchCachedDataWithKey:(NSString *)key{
    OMCacheObject *cacheObject = [self.cache objectForKey:key];
    if (cacheObject.isOutdated || cacheObject.isEmpty) {
        return nil;
    }else{
        return cacheObject.content;
    }
}

- (void)saveCacheWithData:(NSData *)cacheData key:(NSString *)key{
    OMCacheObject *cacheObject = [self.cache objectForKey:key];
    if (cacheObject == nil) {
        cacheObject = [[OMCacheObject alloc]init];
    }
    [cacheObject updateContent:cacheData];
    [self.cache setObject:cacheObject forKey:key];
}

- (void)deleteCacheWithKey:(NSString *)key{
    [self.cache removeObjectForKey:key];
}

- (void)clean{
    [self.cache removeAllObjects];
}


- (NSString *)keyWithServiceIdentifier:(NSString *)serviceIdentifier methodName:(NSString *)method requestParams:(NSDictionary *)requestParams{
    return [NSString stringWithFormat:@"%@%@%@",serviceIdentifier,method,[requestParams PD_urlParamsStringSignature:NO]];;
}


#pragma mark -- getters and setters
- (NSCache *)cache{
    if (_cache == nil) {
        _cache = [[NSCache alloc]init];
        _cache.countLimit = kPDCacheCountLimit;
    }
    return _cache;
}


@end
