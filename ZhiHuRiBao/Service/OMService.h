//
//  PDService.h
//  仿熊猫TV
//
//  Created by kehwa on 16/5/4.
//  Copyright © 2016年 kehwa. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol OMServiceProtocal <NSObject>

@property (nonatomic , readonly , assign)BOOL isOnline;

@property (nonatomic , readonly , copy)NSString *offlineApiBaseUrl;
@property (nonatomic , readonly , copy)NSString *onlineApiBaseUrl;

@property (nonatomic , readonly , copy)NSString *offlineApiVersion;
@property (nonatomic , readonly , copy)NSString *onlineApiVersion;

@property (nonatomic , readonly , copy)NSString *onlinePublicKey;
@property (nonatomic , readonly , copy)NSString *offlinePublicKey;


@property (nonatomic , readonly , copy)NSString *onlinePrivateKey;
@property (nonatomic , readonly , copy)NSString *offlinePrivateKey;

@end

@interface OMService : NSObject
@property (nonatomic , strong , readonly)NSString *publicKey;
@property (nonatomic , strong , readonly)NSString *privateKey;
@property (nonatomic , strong , readonly)NSString *apiBaseUrl;
@property (nonatomic , strong , readonly)NSString *apiVersion;

@property (nonatomic , weak)id<OMServiceProtocal>child;

@end
