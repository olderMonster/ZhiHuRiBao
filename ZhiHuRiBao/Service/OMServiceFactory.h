//
//  PDServiceFactory.h
//  仿熊猫TV
//
//  Created by kehwa on 16/5/4.
//  Copyright © 2016年 kehwa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OMService.h"
#import "OMNetworkingConfiguration.h"

#import "ZHRBService.h"

@interface OMServiceFactory : NSObject

+ (instancetype)sharedInstance;

- (OMService<OMServiceProtocal> *)serviceWithIdentifier:(NSString *)identifier;

@end
