//
//  UIDevice+IdentifierAddition.m
//  仿熊猫TV
//
//  Created by kehwa on 16/5/5.
//  Copyright © 2016年 kehwa. All rights reserved.
//

#import "UIDevice+IdentifierAddition.h"
#import "NSString+PDNetworkingMethods.h"
#include <sys/socket.h> // Per msqr
#include <sys/sysctl.h>
#include <sys/utsname.h>
#include <net/if.h>
#include <net/if_dl.h>

@interface UIDevice(Private)
- (NSString *)localMAC;
@end


@implementation UIDevice (IdentifierAddition)


#pragma mark -- private method
- (NSString *)localMAC{
    int                 mib[6];
    size_t              len;
    char                *buf;
    unsigned char       *ptr;
    struct if_msghdr    *ifm;
    struct sockaddr_dl  *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1\n");
        return NULL;
    }
    
    if ((buf = malloc(len)) == NULL) {
        printf("Could not allocate memory. error!\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2");
        free(buf);
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    NSString *outstring = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X",
                           *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);
    
    return outstring;
}

#pragma mark -- public method
- (NSString *)PD_createUUID{
    CFUUIDRef uuid = CFUUIDCreate(NULL);
    CFStringRef string = CFUUIDCreateString(NULL, uuid);
    CFRelease(uuid);
    return (__bridge NSString *)string;
}

- (NSString *)PD_uuid{
    NSString *key = @"PDUUID";
    NSString *uuid = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    if (uuid.length == 0) {
        [[NSUserDefaults standardUserDefaults] setObject:[self PD_createUUID] forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
        return [[NSUserDefaults standardUserDefaults] objectForKey:key];
    }else{
        return uuid;
    }
}


#warning 缺少udid


- (NSString *)PD_macaddress{
    NSString *key = @"macaddress";
    NSString *macAddress = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    if (macAddress.length == 0) {
        macAddress = [self localMAC];
        if (macAddress.length >0) {
            [[NSUserDefaults standardUserDefaults] setObject:macAddress forKey:key];
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"macaddressMD5"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
    return macAddress;
}


- (NSString *)PD_macaddressMD5{
    NSString *key = @"MACAddressMD5";
    NSString *macid = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    if (macid.length == 0) {
        NSString *macaddress = [[UIDevice currentDevice] PD_macaddress];
        macid = [macaddress PD_md5];
        if (!macid) {
            macid = @"macaddress_empty";
        }else{
            [[NSUserDefaults standardUserDefaults] setObject:macid forKey:key];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
    return macid;
}

- (NSString *)PD_machineType{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *machineType = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    //iPhone
    
    if ([machineType isEqualToString:@"iPhone1,1"]) return @"iPhone 2G (A1203)";
    
    if ([machineType isEqualToString:@"iPhone1,2"]) return @"iPhone 3G (A1241/A1324)";
    
    if ([machineType isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS (A1303/A1325)";
    
    if ([machineType isEqualToString:@"iPhone3,1"]) return @"iPhone 4 (A1332)";
    
    if ([machineType isEqualToString:@"iPhone3,2"]) return @"iPhone 4 (A1332)";
    
    if ([machineType isEqualToString:@"iPhone3,3"]) return @"iPhone 4 (A1349)";
    
    if ([machineType isEqualToString:@"iPhone4,1"]) return @"iPhone 4S (A1387/A1431)";
    
    if ([machineType isEqualToString:@"iPhone5,1"]) return @"iPhone 5 (A1428)";
    
    if ([machineType isEqualToString:@"iPhone5,2"]) return @"iPhone 5 (A1429/A1442)";
    
    if ([machineType isEqualToString:@"iPhone5,3"]) return @"iPhone 5c (A1456/A1532)";
    
    if ([machineType isEqualToString:@"iPhone5,4"]) return @"iPhone 5c (A1507/A1516/A1526/A1529)";
    
    if ([machineType isEqualToString:@"iPhone6,1"]) return @"iPhone 5s (A1453/A1533)";
    
    if ([machineType isEqualToString:@"iPhone6,2"]) return @"iPhone 5s (A1457/A1518/A1528/A1530)";
    
    if ([machineType isEqualToString:@"iPhone7,2"]) return @"iPhone 6 (A1549/A1586)";
    
    if ([machineType isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus (A1522/A1524)";
    
    if ([machineType isEqualToString:@"iPhone8,1"]) return @"iPhone 6s (A1633/A1688/A1691/A1700)";
    
    if ([machineType isEqualToString:@"iPhone8,2"]) return @"iPhone 6s Plus (A1634/A1687/A1690/A1699)";
    
    
    
    //iPod Touch
    
    if ([machineType isEqualToString:@"iPod1,1"])   return @"iPod Touch (A1213)";
    
    if ([machineType isEqualToString:@"iPod2,1"])   return @"iPod Touch 2G (A1288)";
    
    if ([machineType isEqualToString:@"iPod3,1"])   return @"iPod Touch 3G (A1318)";
    
    if ([machineType isEqualToString:@"iPod4,1"])   return @"iPod Touch 4G (A1367)";
    
    if ([machineType isEqualToString:@"iPod5,1"])   return @"iPod Touch 5G (A1421/A1509)";
    
    if ([machineType isEqualToString:@"iPod7,1"])   return @"iPod Touch 6G (A1574)";
    
    
    
    //iPad
    
    if ([machineType isEqualToString:@"iPad1,1"])   return @"iPad (A1219/A1337)";
    
    if ([machineType isEqualToString:@"iPad2,1"])   return @"iPad 2 (A1395)";
    
    if ([machineType isEqualToString:@"iPad2,2"])   return @"iPad 2 (A1396)";
    
    if ([machineType isEqualToString:@"iPad2,3"])   return @"iPad 2 (A1397)";
    
    if ([machineType isEqualToString:@"iPad2,4"])   return @"iPad 2 (A1395+New Chip)";
    
    if ([machineType isEqualToString:@"iPad3,1"])   return @"iPad 3 (A1416)";
    
    if ([machineType isEqualToString:@"iPad3,2"])   return @"iPad 3 (A1403)";
    
    if ([machineType isEqualToString:@"iPad3,3"])   return @"iPad 3 (A1430)";
    
    if ([machineType isEqualToString:@"iPad3,4"])   return @"iPad 4 (A1458)";
    
    if ([machineType isEqualToString:@"iPad3,5"])   return @"iPad 4 (A1459)";
    
    if ([machineType isEqualToString:@"iPad3,6"])   return @"iPad 4 (A1460)";
    
    
    
    //iPad Air
    
    if ([machineType isEqualToString:@"iPad4,1"])   return @"iPad Air (A1474)";
    
    if ([machineType isEqualToString:@"iPad4,2"])   return @"iPad Air (A1475)";
    
    if ([machineType isEqualToString:@"iPad4,3"])   return @"iPad Air (A1476)";
    
    if ([machineType isEqualToString:@"iPad5,3"])   return @"iPad Air 2 (A1566)";
    
    if ([machineType isEqualToString:@"iPad5,4"])   return @"iPad Air 2 (A1567)";
    
    
    
    //iPad mini
    
    if ([machineType isEqualToString:@"iPad2,5"])   return @"iPad mini 1G (A1432)";
    
    if ([machineType isEqualToString:@"iPad2,6"])   return @"iPad mini 1G (A1454)";
    
    if ([machineType isEqualToString:@"iPad2,7"])   return @"iPad mini 1G (A1455)";
    
    if ([machineType isEqualToString:@"iPad4,4"])   return @"iPad mini 2 (A1489)";
    
    if ([machineType isEqualToString:@"iPad4,5"])   return @"iPad mini 2 (A1490)";
    
    if ([machineType isEqualToString:@"iPad4,6"])   return @"iPad mini 2 (A1491)";
    
    if ([machineType isEqualToString:@"iPad4,7"])   return @"iPad mini 3 (A1599)";
    
    if ([machineType isEqualToString:@"iPad4,8"])   return @"iPad mini 3 (A1600)";
    
    if ([machineType isEqualToString:@"iPad4,9"])   return @"iPad mini 3 (A1601)";
    
    if ([machineType isEqualToString:@"iPad5,1"])   return @"iPad mini 4 (A1538)";
    
    if ([machineType isEqualToString:@"iPad5,2"])   return @"iPad mini 4 (A1550)";
    
    
    
    if ([machineType isEqualToString:@"i386"])      return @"iPhone Simulator";
    
    if ([machineType isEqualToString:@"x86_64"])    return @"iPhone Simulator";
    
    
    return machineType;
}


- (NSString *)PD_osType{
    UIDevice *device = [UIDevice currentDevice];
    NSString *os = [device systemVersion];
    NSArray *array = [os componentsSeparatedByString:@"."];
    NSString *ostype = @"ios";
    if (array.count>0) {
        ostype = [NSString stringWithFormat:@"%@%@",ostype,array[0]];
    }
    return ostype;
}

@end
