//
//  ZHRBReportsShortCommentsManager.h
//  ZhiHuRiBao
//
//  Created by kehwa on 16/7/26.
//  Copyright © 2016年 kehwa. All rights reserved.
//

#import "OMBaseApiManager.h"

@interface ZHRBReportsShortCommentsManager : OMBaseApiManager<OMApiManager,OMApiManagerValidator>

@property (nonatomic , copy)NSString *reportsId;
@end
