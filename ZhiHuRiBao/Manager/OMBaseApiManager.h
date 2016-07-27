//
//  OMBaseApiManager.h
//  仿熊猫TV
//
//  Created by kehwa on 16/5/4.
//  Copyright © 2016年 kehwa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OMApiResponse.h"
@class OMBaseApiManager;

// 在调用成功之后的params字典里面，用这个key可以取出requestID
static NSString *const kOMApiBaseManagerRequestId = @"kOMApiBaseManagerRequestId";

/******* 请求完成之后的回调 *******/
@protocol OMApiManagerCallBackDelegate <NSObject>
@required
- (void)managerCallApiDidSuccess:(OMBaseApiManager *)manager;
- (void)managerCallApiDidFailure:(OMBaseApiManager *)manager;

@end


/******* 数据组装器 *******/
@protocol OMApiManagerCallBackDataReformer<NSObject>

@required
- (id)manager:(OMBaseApiManager *)manager reformData:(NSDictionary *)data;

@end


/******* 验证器 *******/
@protocol OMApiManagerValidator <NSObject>

@required
- (BOOL)manager:(OMBaseApiManager *)manager isCorrectWithParamsData:(NSDictionary *)params;
- (BOOL)manager:(OMBaseApiManager *)manager isCorrectWithCallBackData:(NSDictionary *)responseData;

@end



/******* 数据源 *******/
@protocol OMApiManagerParamsSourceDelegate <NSObject>

@required
- (NSDictionary *)paramsForApi:(OMBaseApiManager *)manager;

@end



/*
 当产品要求返回数据不正确或者为空的时候显示一套UI，请求超时和网络不通的时候显示另一套UI时，使用这个enum来决定使用哪种UI。（安居客PAD就有这样的需求，sigh～）
 你不应该在回调数据验证函数里面设置这些值，事实上，在任何派生的子类里面你都不应该自己设置manager的这个状态，baseManager已经帮你搞定了。
 强行修改manager的这个状态有可能会造成程序流程的改变，容易造成混乱。
 */
typedef NS_ENUM (NSUInteger,OMAPIManagerErrorType){
    OMAPIManagerErrorTypeDefault,       //没有产生过API请求，这个是manager的默认状态。
    OMAPIManagerErrorTypeSuccess,       //API请求成功且返回数据正确，此时manager的数据是可以直接拿来使用的。
    OMAPIManagerErrorTypeNoContent,     //API请求成功但返回数据不正确。如果回调数据验证函数返回值为NO，manager的状态就会是这个。
    OMAPIManagerErrorTypeParamsError,   //参数错误，此时manager不会调用API，因为参数验证是在调用API之前做的。
    OMAPIManagerErrorTypeTimeout,       //请求超时。RTApiProxy设置的是20秒超时，具体超时时间的设置请自己去看RTApiProxy的相关代码。
    OMAPIManagerErrorTypeNoNetWork      //网络不通。在调用API之前会判断一下当前网络是否通畅，这个也是在调用API之前验证的，和上面超时的状态是有区别的。
};

typedef NS_ENUM (NSUInteger, OMAPIManagerRequestType){
    OMAPIManagerRequestTypeGet,
    OMAPIManagerRequestTypePost,
    OMAPIManagerRequestTypeRestGet,
    OMAPIManagerRequestTypeRestPost
};



@protocol OMApiManager <NSObject>

@required
- (NSString *)methodName;
- (NSString *)serviceType;
- (OMAPIManagerRequestType)requestType;


@optional
- (void)cleanData;
- (NSDictionary *)reformParams:(NSDictionary *)params;
- (BOOL)shouldCache;

@end


/******* 拦截器 *******/
@protocol OMApiManagerInterceptor <NSObject>

@optional
- (void)manager:(OMBaseApiManager *)manager beforePerformSuccessWithResponse:(OMApiResponse *)response;
- (void)manager:(OMBaseApiManager *)manager afterPerformSuccessWithResponse:(OMApiResponse *)response;

- (void)manager:(OMBaseApiManager *)manager beforePerformFailureWithResponse:(OMApiResponse *)response;
- (void)manager:(OMBaseApiManager *)manager afterPerformFailureWithResponse:(OMApiResponse *)response;

- (BOOL)manager:(OMBaseApiManager *)manager shouldCallApiWithParams:(NSDictionary *)params;
- (void)manager:(OMBaseApiManager *)manager afterCallingApiWithParams:(NSDictionary *)params;

@end


@interface OMBaseApiManager : NSObject

@property (nonatomic , weak)id<OMApiManagerParamsSourceDelegate>sourceDelegate;
@property (nonatomic , weak)id<OMApiManagerValidator>validator;
@property (nonatomic , weak)id<OMApiManagerInterceptor>interceptor;
@property (nonatomic , weak)id<OMApiManagerCallBackDelegate>callBackDelegate;
@property (nonatomic , weak)NSObject<OMApiManager> *child;//里面会调用到NSObject的方法，所以这里不用id

/*
 baseManager是不会去设置errorMessage的，派生的子类manager可能需要给controller提供错误信息。所以为了统一外部调用的入口，设置了这个变量。
 派生的子类需要通过extension来在保证errorMessage在对外只读的情况下使派生的manager子类对errorMessage具有写权限。
 */
@property (nonatomic , copy , readonly)NSString *errorMessage;
@property (nonatomic , readonly)OMAPIManagerErrorType errorType;

@property (nonatomic , assign , readonly)BOOL isReachable;
@property (nonatomic , assign , readonly)BOOL isLoading;


- (id)fetchDataWithReformer:(id<OMApiManagerCallBackDataReformer>)reformer;

- (NSInteger)loadData; //manager调用该方法请求数据

- (void)cancelAllRequests;
- (void)cancelRequestWithRequestId:(NSInteger)requestId;

// 拦截器方法，继承之后需要调用一下super
- (void)beforePerformSuccessWithResponse:(OMApiResponse *)response;
- (void)afterPerformSuccessWithResponse:(OMApiResponse *)response;

- (void)beforePerformFailureWithResponse:(OMApiResponse *)response;
- (void)afterPerformFailureWithResponse:(OMApiResponse *)response;

- (BOOL)shouldCallApiWithParams:(NSDictionary *)params;
- (void)afterCallingApiWithParams:(NSDictionary *)params;


/*
 用于给继承的类做重载，在调用API之前额外添加一些参数,但不应该在这个函数里面修改已有的参数。
 子类中覆盖这个函数的时候就不需要调用[super reformParams:params]了
 RTAPIBaseManager会先调用这个函数，然后才会调用到 id<RTAPIManagerValidator> 中的 manager:isCorrectWithParamsData:
 所以这里返回的参数字典还是会被后面的验证函数去验证的。
 
 假设同一个翻页Manager，ManagerA的paramSource提供page_size=15参数，ManagerB的paramSource提供page_size=2参数
 如果在这个函数里面将page_size改成10，那么最终调用API的时候，page_size就变成10了。然而外面却觉察不到这一点，因此这个函数要慎用。
 
 这个函数的适用场景：
 当两类数据走的是同一个API时，为了避免不必要的判断，我们将这一个API当作两个API来处理。
 那么在传递参数要求不同的返回时，可以在这里给返回参数指定类型。
 
 具体请参考AJKHDXFLoupanCategoryRecommendSamePriceAPIManager和AJKHDXFLoupanCategoryRecommendSameAreaAPIManager
 
 */
- (NSDictionary *)reformParams:(NSDictionary *)params;
- (void)cleanData;
- (BOOL)shouldCache;

@end
