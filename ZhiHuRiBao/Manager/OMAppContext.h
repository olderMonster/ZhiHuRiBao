//
//  PDAppContext.h
//  仿熊猫TV
//
//  Created by kehwa on 16/5/5.
//  Copyright © 2016年 kehwa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OMAppContext : NSObject
//凡是未声明成readonly的都是需要在初始化的时候由外面给的

@property (nonatomic , copy)NSString *appName; //应用名称


@property (nonatomic , copy , readonly)NSString *cityId;  //城市id
@property (nonatomic , copy , readonly)NSString *deviceName; //设备名称
@property (nonatomic , copy , readonly)NSString *systemName; //系统名称
@property (nonatomic , copy , readonly)NSString *systemVersion; //系统版本
@property (nonatomic, copy, readonly) NSString *from;         //请求来源，值都是@"mobile"
@property (nonatomic, copy, readonly) NSString *ostype2;      //操作系统类型
@property (nonatomic, copy, readonly) NSString *qtime;        //发送请求的时间
@property (nonatomic, copy, readonly) NSString *macid;
@property (nonatomic, copy, readonly) NSString *uuid;
@property (nonatomic, copy, readonly) NSString *udid2;
@property (nonatomic, copy, readonly) NSString *uuid2;
@property (nonatomic, copy, readonly) NSString *bundleVersion;           //Bundle版本

@property (nonatomic, readonly) NSString *net;
@property (nonatomic, readonly) BOOL isReachable;

// log相关的参数
@property (nonatomic, copy) NSString *currentPageNumber;    //当前controller的pageNumber，记log用
@property (nonatomic, copy) NSString *uid; //登录用户token
@property (nonatomic, copy) NSString *chatid; //登录用户chat id
@property (nonatomic, copy) NSString *ccid; // 用户选择的城市id

@property (nonatomic, copy, readonly) NSString *bp;         //上一个页面的pageNumber,记log用
@property (nonatomic , copy , readonly)NSString *ip;
@property (nonatomic, copy, readonly) NSString *ver; // log 版本
@property (nonatomic , copy , readonly)NSString *mac;
@property (nonatomic , copy , readonly)NSString *os;
@property (nonatomic , copy , readonly)NSString *app;
@property (nonatomic , copy , readonly)NSString *currentTime;

+ (instancetype)sharedInstance;

- (void)configWithAppName:(NSString *)appName;

@end
