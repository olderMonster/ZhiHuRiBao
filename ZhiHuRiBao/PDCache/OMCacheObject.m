//
//  PDCacheObject.m
//  仿熊猫TV
//
//  Created by kehwa on 16/5/6.
//  Copyright © 2016年 kehwa. All rights reserved.
//

#import "OMCacheObject.h"
#import "OMNetworkingConfiguration.h"
@interface OMCacheObject()

@property (nonatomic , copy , readwrite)NSData *content;
@property (nonatomic , copy , readwrite)NSDate *lastUpdateTime;

@end

@implementation OMCacheObject
#pragma mark -- life cycle
- (instancetype)initWithContent:(NSData *)content{
    self = [super init];
    if (self) {
        
        self.content = content;
    }
    return self;
}

#pragma mark -- public method
- (void)updateContent:(NSData *)content{
    self.content = content;
}


#pragma mark -- getters and setters
- (BOOL)isOutdated{
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:self.lastUpdateTime];
    return timeInterval > kPDCacheOutdateTimeSeconds;
}
- (BOOL)isEmpty{
    return self.content == nil;
}

- (void)setContent:(NSData *)content{
    _content = [content copy];
    self.lastUpdateTime = [NSDate dateWithTimeIntervalSinceNow:0];
}


@end
