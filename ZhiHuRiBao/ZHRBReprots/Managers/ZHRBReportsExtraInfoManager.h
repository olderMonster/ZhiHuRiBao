//
//  ZHRBReportsExtraInfoManager.h
//  ZhiHuRiBao
//
//  Created by kehwa on 16/7/22.
//  Copyright © 2016年 kehwa. All rights reserved.
//

#import "OMBaseApiManager.h"

@interface ZHRBReportsExtraInfoManager : OMBaseApiManager<OMApiManager,OMApiManagerValidator>

@property (nonatomic , copy)NSString *reportsId;

@end
