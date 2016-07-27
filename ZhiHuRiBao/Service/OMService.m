//
//  PDService.m
//  仿熊猫TV
//
//  Created by kehwa on 16/5/4.
//  Copyright © 2016年 kehwa. All rights reserved.
//

#import "OMService.h"

@implementation OMService
- (instancetype)init{
    self = [super init];
    if (self) {
        if ([self conformsToProtocol:@protocol(OMServiceProtocal)]) {
            self.child = (id<OMServiceProtocal>)self;
        }
        
    }
    return self;
}


#pragma mark -- getters and setters
- (NSString *)privateKey{
    return self.child.isOnline ? self.child.onlinePrivateKey : self.child.offlinePrivateKey;
}

- (NSString *)publicKey{
    return self.child.isOnline ? self.child.onlinePublicKey : self.child.offlinePublicKey;
}


- (NSString *)apiBaseUrl{
    return self.child.isOnline ? self.child.onlineApiBaseUrl : self.child.offlineApiBaseUrl;
}


- (NSString *)apiVersion{
    return self.child.isOnline ? self.child.onlineApiVersion : self.child.offlineApiVersion;
}



@end
