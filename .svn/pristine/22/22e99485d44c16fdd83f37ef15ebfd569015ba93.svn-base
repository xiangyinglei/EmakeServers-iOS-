//
//  YHSendFileTipsView.h
//  EmakeServers
//
//  Created by 谷伟 on 2018/5/22.
//  Copyright © 2018年 谷伟. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol YHSendFileTipsViewDelegete <NSObject>
@optional

- (void)alertViewLeftBtnClick:(id)alertView;


- (void)alertViewRightBtnClick:(id)alertView;;

@end
@interface YHSendFileTipsView : UIView
@property (nonatomic, weak)UIViewController<YHSendFileTipsViewDelegete>* delegate;

- (instancetype)initWithDelegete:(id)delegate andUserType:(NSString *)userType andUserName:(NSString *)userName andUserAvata:(NSString *)userAvata andFileName:(NSString *)fileName;

- (void)showAnimated;
@end
