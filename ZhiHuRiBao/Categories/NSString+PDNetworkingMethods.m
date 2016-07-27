//
//  NSString+PDNetworkingMethods.m
//  仿熊猫TV
//
//  Created by kehwa on 16/5/5.
//  Copyright © 2016年 kehwa. All rights reserved.
//

#import "NSString+PDNetworkingMethods.h"

#include <CommonCrypto/CommonDigest.h>

@implementation NSString (PDNetworkingMethods)
- (NSString *)PD_md5
{
    NSData* inputData = [self dataUsingEncoding:NSUTF8StringEncoding];
    unsigned char outputData[CC_MD5_DIGEST_LENGTH];
    CC_MD5([inputData bytes], (unsigned int)[inputData length], outputData);
    
    NSMutableString* hashStr = [NSMutableString string];
    int i = 0;
    for (i = 0; i < CC_MD5_DIGEST_LENGTH; ++i)
        [hashStr appendFormat:@"%02x", outputData[i]];
    
    return hashStr;
}

+ (NSString *)getDateString:(NSDate *)date{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMdd"];
    NSString *dateStr = [formatter stringFromDate:date];
    return dateStr;
}

/**
 *  找到给地时间字符串的前一天的日期
 */
- (NSString *)getYesterdayDateString{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMdd"];
    NSDate *date = [formatter dateFromString:self];
    NSDate *yesterday = [NSDate dateWithTimeInterval:-60 * 60 * 24 sinceDate:date];
    NSString *yesterdayStr = [formatter stringFromDate:yesterday];
//    NSLog(@"yesterdayStr ===>> %@",yesterdayStr);
    return yesterdayStr;
}

//根据时间戳获取星期几
- (NSString *)getWeekDay
{
    NSArray *weekday = [NSArray arrayWithObjects: [NSNull null], @"星期日", @"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六", nil];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMdd"];
    NSDate *fectureDate = [formatter dateFromString:self];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [calendar components:NSCalendarUnitWeekday fromDate:fectureDate];
    NSString *weekStr = [weekday objectAtIndex:components.weekday];
    
    [formatter setDateFormat:@"MM月dd日"];
    NSString *dateStr = [formatter stringFromDate:fectureDate];
    NSString *resStr = [NSString stringWithFormat:@"%@ %@",dateStr,weekStr];
    
    return resStr;

}

@end
