//
//  PDCacheObject.h
//  仿熊猫TV
//
//  Created by kehwa on 16/5/6.
//  Copyright © 2016年 kehwa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OMCacheObject : NSObject

@property (nonatomic , copy , readonly)NSData *content;
@property (nonatomic , copy , readonly)NSDate *lastUpdateTime;

@property (nonatomic , assign , readonly)BOOL isOutdated;
@property (nonatomic , assign , readonly)BOOL isEmpty;


- (instancetype)initWithContent:(NSData *)content;
- (void)updateContent:(NSData *)content;

@end
