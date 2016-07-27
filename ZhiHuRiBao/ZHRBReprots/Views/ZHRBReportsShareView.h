//
//  ZHRBReportsShareView.h
//  ZhiHuRiBao
//
//  Created by kehwa on 16/7/22.
//  Copyright © 2016年 kehwa. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,ZHRBReportsShareViewAnimation) {
    ZHRBReportsShareViewAnimationTop,
    ZHRBReportsShareViewAnimationLeft,
    ZHRBReportsShareViewAnimationBottom,
    ZHRBReportsShareViewAnimationRight
};

@protocol ZHRBReportsShareViewDelegate <NSObject>

@optional
- (void)didCancelAction;
- (void)didCollectionAction;

@end

@interface ZHRBReportsShareView : UIView

@property (nonatomic , weak)id<ZHRBReportsShareViewDelegate>delegate;

@end
