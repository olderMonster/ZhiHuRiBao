//
//  UIDevice+IdentifierAddition.h
//  仿熊猫TV
//
//  Created by kehwa on 16/5/5.
//  Copyright © 2016年 kehwa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIDevice (IdentifierAddition)

- (NSString *)PD_uuid;
//- (NSString *)PD_udid;
- (NSString *)PD_macaddress;
- (NSString *)PD_macaddressMD5;
- (NSString *)PD_machineType;
- (NSString *)PD_osType; //显示“ios6，ios5”，只显示大版本号
- (NSString *)PD_createUUID;

@end
