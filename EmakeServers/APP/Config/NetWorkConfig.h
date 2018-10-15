//
//  NetWorkConfig.h
//  emake
//
//  Created by 袁方 on 2017/7/24.
//  Copyright © 2017年 emake. All rights reserved.
//
#ifndef NetWorkConfig_h
#define NetWorkConfig_h

//上线 0  下线 1
#define Debug   @"0"


//请求地址

//#define CLOUD_URL(res)  [NSString stringWithFormat:@"http://mallapi.emake.cn/%@",res]//试服务器
#define CLOUD_URL(res)  [NSString stringWithFormat:@"http://mallapi.emake.cn/%@",res]//本地地址
#define CLOUDTest_URL(res)  [NSString stringWithFormat:@"http://192.168.0.1212:3100/%@",res]//本地地址


//服务器统一返回字段
#define RESPONSE_RESULT_CODE                    @"ResultCode"
#define RESPONSE_RESULT_INFO                    @"ResultInfo"
#define RESPONSE_RESULT_DATA                    @"Data"


//错误信息提示
#define Tips_RESULT_INFO                    @""


//请求头字段
#define Emake_App_Version            [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
#define HTTP_Header_Patameter        [NSString stringWithFormat:@"emakeServers.ios.%@",Emake_App_Version]


/*--------------------------------------------接口---------------------------------------*/
//用户登录
#define URL_ConsoleUserLogin CLOUD_URL(@"console/user/login")
//搜索用户
#define URL_CustomerUserSearch CLOUD_URL(@"customer/user/searchnew")
//用户信息查询接口
#define URL_CustomerUserQuery CLOUD_URL(@"app/customer/user/data")
//分类列表
#define URL_ShoppingGoodCategories           CLOUD_URL(@"shopping/good/categories")
//产品系列
#define URL_Goodsseries     CLOUD_URL(@"shopping/good/seriescode")
//商品详情
#define URL_ShoppingDetail           CLOUD_URL(@"shopping/series/detail")
//快捷回复
#define URL_AppQuickReplay          CLOUD_URL(@"app/quickreplay")
//获取合同协议
#define URL_WebMakeContractChat         CLOUD_URL(@"web/make/contract/chat")
//用户订单
#define URL_AppChatOrder      CLOUD_URL(@"app/chat/order")
//平台页面接口
#define URL_AppCustomerPlatform       CLOUD_URL(@"app/customer/agent/platform")
//所有店铺\待审核店铺
#define URL_AppCustomerAll_Store       CLOUD_URL(@"app/customer/all_store")
//所有用户
#define URL_AppCustomerAll_User       CLOUD_URL(@"app/customer/user/identity")
//店铺详情
#define URL_AppCustomerStoreDetail      CLOUD_URL(@"app/customer/store/detail")
//用户订单
#define URL_AppCustomerMakeOrder       CLOUD_URL(@"app/customer/make/order")
//店铺下架
#define URL_ConsoleStore       CLOUD_URL(@"app/customer/store")
//客服订单详情
#define URL_StoreContractOder            CLOUD_URL(@"app/customer/make/order")
//客服订单详情
#define URL_AccessToken            CLOUD_URL(@"access_token")
//城市代理商
#define URL_AppCustomerAgentUnaudit            CLOUD_URL(@"app/customer/agent/unaudit")
//代理商审核
#define URL_AppCustomerAgentAudit            CLOUD_URL(@"app/customer/agent/audit")
//修改代理商资料
#define URL_AppCustomerAgentCategory            CLOUD_URL(@"app/customer/agent/category")

#endif /* NetWorkConfig_h */
