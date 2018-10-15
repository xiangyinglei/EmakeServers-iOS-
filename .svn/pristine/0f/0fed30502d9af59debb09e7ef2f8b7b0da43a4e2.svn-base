//
//  YHJsonRequest.h
//  emake
//
//  Created by chenyi on 2017/8/7.
//  Copyright © 2017年 emake. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "YHLoginUser.h"
#import "YHUserModel.h"
#import "YHUserMainModel.h"
#import "YHProductDetailModel.h"
#import "YHReplyModel.h"
#import "YHOrderContract.h"
#import "YHOrder.h"
#import "YHArchiveModel.h"
#import "YHStoreModel.h"
@interface YHJsonRequest : NSObject
@property(nonatomic,strong) NSLock *lock;
@property(nonatomic,strong) NSLock *tokenLock;
+(YHJsonRequest *)shared;
//登陆
-(void)loginWithPassword: (NSString *) Password UserName:(NSString *) userName
           succeededBlock:(void (^)(NSDictionary *loginDict))succeededBlock
              failedBlock:(void (^)(NSString *errorMessage))failedBlock;
//搜索
- (void)searchUserWithMoblieNumberWithParameter:(NSDictionary *)params SucceededBlock:(void (^)(YHUserMainModel *model))succeededBlock failedBlock:(void (^)(NSString *errorMessage))failedBlock;
//获取用户信息
- (void)getUsersInfoWithUserId:(NSString *)userId SucceededBlock:(void (^)(YHUserModel *model))succeededBlock failedBlock:(void (^)(NSString *errorMessage))failedBlock;
//产品右侧列表
- (void)getShoppingGoodCategoriesSeriesId:(NSString *)SeriesId SuccessBlock:(void(^)(NSDictionary *successMessage))successBLock fialureBlock:(void(^)(NSString *errorMessages))filaedBlock;
//产品详情
- (void)getProductDetailsInfoWith:(NSString *)CategoryId seriesCode:(NSString *)seriesCode successBlock:(void(^)(YHProductDetailModel *model))successBLock fialureBlock:(void(^)(NSString *errorMessages))filaedBlock;
//快捷回复
- (void)getQuickReplySuccessBlock:(void(^)(NSArray *array))successBLock fialureBlock:(void(^)(NSString *errorMessages))filaedBlock;
//获取合同、协议
- (void)getWebContractWithContractNo:(NSString *)contractNo successBlock:(void(^)(NSDictionary *dict))successBLock fialureBlock:(void(^)(NSString *errorMessages))filaedBlock;
//用户订单
- (void)getOrderListWithUserId:(NSString *)userId orStoreId:(NSString *)storeId SuccessBlock:(void(^)(NSArray *dataArray))successBLock fialureBlock:(void(^)(NSString *errorMessages))filaedBlock;
//消息归档
- (void)appChatPostToServers:(NSDictionary *)dict SuccessBlock:(void(^)(NSString *successMessages))successBLock fialureBlock:(void(^)(NSString *errorMessages))filaedBlock;
//消息获取
- (void)getAppChatFromServers:(NSString *)params SuccessBlock:(void(^)(NSArray *messageArray))successBLock fialureBlock:(void(^)(NSString *errorMessages))filaedBlock;
//店铺信息平台
- (void)getAppCustomerPlatformDataWithRequestType:(NSInteger)requestType SuccessBlock:(void(^)(NSDictionary *dict))successBLock fialureBlock:(void(^)(NSString *errorMessages))filaedBlock;
//所有店铺
- (void)getAppCustomerAllStoreWithPageIndex:(NSInteger)PageIndex andPageSize:(NSInteger)PageSize SuccessBlock:(void(^)(NSArray *messageArray))successBLock fialureBlock:(void(^)(NSString *errorMessages))filaedBlock;
//待审核店铺
- (void)getAppCustomerAuditStoreWithPageIndex:(NSInteger)PageIndex andPageSize:(NSInteger)PageSize SuccessBlock:(void(^)(NSArray *messageArray))successBLock fialureBlock:(void(^)(NSString *errorMessages))filaedBlock;
//所有用户
- (void)getAppCustomerAllUserWithUserIdentity:(NSString *)userIdentity PageIndex:(NSInteger)PageIndex andPageSize:(NSInteger)PageSize SuccessBlock:(void(^)(NSDictionary *dict))successBlock fialureBlock:(void(^)(NSString *errorMessages))filaedBlock;
//店铺资料
- (void)getAppCustomerStoreDetailWithStoreId:(NSString *)storeId SuccessBlock:(void(^)(YHStoreModel *model))successBLock fialureBlock:(void(^)(NSString *errorMessages))filaedBlock;
//店铺审核
- (void)auditAppCustomerStoreWithParams:(NSDictionary *)parameters SuccessBlock:(void(^)(NSString *successMessages))successBLock fialureBlock:(void(^)(NSString *errorMessages))filaedBlock;
//店铺搜索
- (void)searchAppCustomerStoreWithSearchText:(NSString *)searchText SuccessBlock:(void(^)(NSArray *messageArray))successBLock fialureBlock:(void(^)(NSString *errorMessages))filaedBlock;
//店铺下架
- (void)storeDownWithParameters:(NSDictionary *)params  SuccessBlock:(void(^)(NSString *successMessage))successBLock fialureBlock:(void(^)(NSString *errorMessages))filaedBlock;

//订单查询
-(void)userUseOrderManageParams:(NSDictionary *)params SucceededBlock:(void (^)(NSArray *orderArray))succeededBlock failedBlock:(void (^)(NSString *errorMessage))failedBlock;
//城市代理人
- (void)getAppCityDelegateUserWithAgentState:(NSString *)AgentState PageIndex:(NSInteger)PageIndex andPageSize:(NSInteger)PageSize SuccessBlock:(void(^)(NSDictionary *dict))successBlock fialureBlock:(void(^)(NSString *errorMessages))filaedBlock;
//城市代理人审核
- (void)auditCityDelegateUserWithParams:(NSDictionary *)parameters SuccessBlock:(void(^)(NSString *successMessages))successBLock fialureBlock:(void(^)(NSString *errorMessages))filaedBlock;
//修改代理商资料
- (void)auditCityDelegateUserCategoryExchangeWithParams:(NSDictionary *)parameters SuccessBlock:(void(^)(NSString *successMessages))successBLock fialureBlock:(void(^)(NSString *errorMessages))filaedBlock;
@end






