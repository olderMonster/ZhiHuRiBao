//
//  PDServiceFactory.m
//  仿熊猫TV
//
//  Created by kehwa on 16/5/4.
//  Copyright © 2016年 kehwa. All rights reserved.
//

#import "OMServiceFactory.h"
NSString *const kZHRBService = @"kZHRBService";


@interface OMServiceFactory()

@property (nonatomic , strong)NSCache *serviceStorage;

@end

@implementation OMServiceFactory

+ (instancetype)sharedInstance{
    static dispatch_once_t onceToken;
    static OMServiceFactory *sharedInstance = nil;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[OMServiceFactory alloc]init];
    });
    return sharedInstance;
}

#pragma mark -- public method
- (OMService<OMServiceProtocal> *)serviceWithIdentifier:(NSString *)identifier{
    if ([self.serviceStorage objectForKey:identifier] == nil) {
        [self.serviceStorage setObject:[self newServiceWithIdentifier:identifier] forKey:identifier];
    }
    return [self.serviceStorage objectForKey:identifier];
}

#pragma mark -- private method
- (OMService<OMServiceProtocal> *)newServiceWithIdentifier:(NSString *)identifier{
    if ([identifier isEqualToString:kZHRBService]) {
        return [[ZHRBService alloc]init];
    }
    return nil;
}


#pragma mark -- getters and setters
- (NSCache *)serviceStorage{
    if (_serviceStorage == nil) {
        _serviceStorage = [[NSCache alloc]init];
        _serviceStorage.countLimit = 10;
    }
    return _serviceStorage;
}

@end
