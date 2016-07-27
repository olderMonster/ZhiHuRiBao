//
//  NSString+PDNetworkingMethods.h
//  仿熊猫TV
//
//  Created by kehwa on 16/5/5.
//  Copyright © 2016年 kehwa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (PDNetworkingMethods)
- (NSString *)PD_md5;

/**
 *  获取指定日期的前一天的时间
 *
 *  @return 时间字符串
 */
- (NSString *)getYesterdayDateString;
/**
 *  获取指定日期对应的日期以及星期
 *
 *  @return 日期 星期
 */
- (NSString *)getWeekDay;
/**
 *  讲指定的日期转为字符串
 *
 *  @param date 日期
 *
 *  @return 日期字符串
 */
+ (NSString *)getDateString:(NSDate *)date;
@end
