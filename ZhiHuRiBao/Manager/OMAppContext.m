//
//  PDAppContext.m
//  仿熊猫TV
//
//  Created by kehwa on 16/5/5.
//  Copyright © 2016年 kehwa. All rights reserved.
//

#import "OMAppContext.h"
#import "UIDevice+IdentifierAddition.h"
#import <AFNetworking/AFNetworkReachabilityManager.h>

#import <ifaddrs.h>
#import <arpa/inet.h>
@interface OMAppContext()

@property (nonatomic , strong)UIDevice *device;
@property (nonatomic , copy , readwrite)NSString *deviceName;
@property (nonatomic , copy , readwrite)NSString *ip;
@property (nonatomic , copy , readwrite)NSString *from;
@property (nonatomic , copy , readwrite)NSString *uuid;
@property (nonatomic , copy , readwrite)NSString *macid;
@property (nonatomic , copy , readwrite)NSString *systemName;
@property (nonatomic , copy , readwrite)NSString *systemVersion;
@property (nonatomic, copy, readwrite) NSString *bundleVersion;           //Bundle版本
@property (nonatomic , copy , readwrite)NSString *currentTime;

@property (nonatomic, readwrite) NSString *net;
@property (nonatomic, readwrite) BOOL isReachable;

@end

@implementation OMAppContext

- (instancetype)init{
    self = [super init];
    if (self) {
        _currentPageNumber = @"-1";
    }
    return self;
}

+ (instancetype)sharedInstance{
    static dispatch_once_t onceToken;
    static OMAppContext *sharedInstance = nil;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[OMAppContext alloc]init];
    });
    return sharedInstance;
}


- (void)configWithAppName:(NSString *)appName{
    
}


#pragma mark -- getters and setters
- (UIDevice *)device{
    if (_device == nil) {
        _device = [UIDevice currentDevice];
    }
    return _device;
}


#warning 差异
- (NSString *)deviceName{
    if (_deviceName == nil) {
        _deviceName = [self.device.model stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
    return _deviceName;
}

- (NSString *)systemName{
    if (_systemName == nil) {
        _systemName = [self.device.model stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
    return _systemName;
}

- (NSString *)systemVersion{
    if (_systemVersion == nil) {
        _systemVersion = [self.device systemVersion];
    }
    return _systemVersion;
}

- (NSString *)bundleVersion{
    if(_bundleVersion == nil){
        _bundleVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    }
    return _bundleVersion;
}

- (NSString *)appName{
    if (_appName == nil) {
        _appName = @"仿熊猫TV";
    }
    return _appName;
}

- (NSString *)net
{
    if (_net == nil) {
        _net = @"";
        if ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus == AFNetworkReachabilityStatusReachableViaWWAN) {
            _net = @"2G3G";
        }
        if ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus == AFNetworkReachabilityStatusReachableViaWiFi) {
            _net = @"WiFi";
        }
    }
    return _net;
}



- (NSString *)ip{
    if (_ip == nil) {
        _ip = @"Error";
        struct ifaddrs *interfaces = NULL;
        struct ifaddrs *temp_addr = NULL;
        int success = 0;
        // retrieve the current interfaces - returns 0 on success
        success = getifaddrs(&interfaces);
        if (success == 0) {
            // Loop through linked list of interfaces
            temp_addr = interfaces;
            while(temp_addr != NULL) {
                if(temp_addr->ifa_addr->sa_family == AF_INET) {
                    // Check if interface is en0 which is the wifi connection on the iPhone
                    if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                        // Get NSString from C String
                        _ip = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                    }
                }
                temp_addr = temp_addr->ifa_next;
            }
        }
        // Free memory
        freeifaddrs(interfaces);
    }
    return _ip;
}

- (NSString *)app{
    return self.appName;
}


- (NSString *)currentTime{
    if (_currentTime == nil) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss.SSS";
        _currentTime = [dateFormatter stringFromDate:[NSDate date]];
    }
    return _currentTime;
}


- (BOOL)isReachable{
    if ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus == AFNetworkReachabilityStatusUnknown) {
        return YES;
    }else{
        return [[AFNetworkReachabilityManager sharedManager] isReachable];
    }
}




@end
