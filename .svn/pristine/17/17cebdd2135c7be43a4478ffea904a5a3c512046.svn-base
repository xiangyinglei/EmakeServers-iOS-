


//
//  YHLoginViewController.m
//  emake
//
//  Created by 袁方 on 2017/7/13.
//  Copyright © 2017年 emake. All rights reserved.
//

#import "YHLoginViewController.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "Header.h"
#import "YHLoginView.h"
#import "YHMQTTClient.h"
#import "YHLoginUser.h"
@interface YHLoginViewController ()<UITextFieldDelegate>

@property (nonatomic, weak) UIButton *getCaptchaButton;
@property (nonatomic, weak) UIButton *loginButton;
@property YHLoginView *loginView;
@end

@implementation YHLoginViewController

#pragma mark - LifeCycle
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
}

#pragma mark - IBActions
- (void)login {
    [self.view endEditing:YES];
    [self.view showWait:@"登录中" viewType:CurrentView];
    [[YHJsonRequest shared] loginWithPassword:_loginView.textPassword.text UserName:_loginView.textPhone.text succeededBlock:^(NSDictionary *loginDict) {
        [self.view makeToast:@"登录成功" duration:2 position:CSToastPositionBottom];
        [self.view hideWait:CurrentView];
        //登陆成功后跳转到tabbar
        //保存手机号码
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *accessToken = [loginDict objectForKey:@"access_token"];
        NSString *refreshToken = [loginDict objectForKey:@"refresh_token"];
        YHLoginUser *loginUser = [YHLoginUser mj_objectWithKeyValues:[loginDict objectForKey:@"userinfo"]];
        [userDefaults setObject:accessToken forKey:LOGIN_TOKEN];
        [userDefaults setObject:refreshToken forKey:LOGIN_REFRESHTOKEN];
        [userDefaults setObject:loginUser.MobileNumber forKey:LOGIN_MOBILEPHONE];
        [userDefaults setObject:_loginView.textPassword.text forKey:LOGIN_PASSWORD];
        [userDefaults setObject:loginUser.UserId forKey:LOGIN_USERID];
        [userDefaults setObject:loginUser.UserName forKey:LOGIN_USERNAME];
        [userDefaults setObject:loginUser.RealName forKey:LOGIN_UserRealName];
        [userDefaults setObject:loginUser.Email forKey:LOGIN_UserEmail];
        [userDefaults setObject:loginUser.ServiceID forKey:LOGIN_ServiceID];
        [userDefaults setObject:loginUser.ConsoleType forKey:LOGIN_ConsoleType];
        [userDefaults setObject:loginUser.HeadImageUrl forKey:LOGIN_HeadImageUrl];
        [userDefaults setBool:YES forKey:Is_Login];
        [userDefaults setObject:loginUser.HeadImageUrl forKey:LOGIN_HeadImageUrl];
        [userDefaults synchronize];
        NSString *messageTopic = [NSString stringWithFormat:@"chatroom/%@",loginUser.ServiceID];
        [[YHMQTTClient sharedClient] connectToHost:MQTT_IP Port:MQTT_PORT subcriceCMDTopic:messageTopic withServerId:loginUser.ServiceID];
            [[FMDBManager sharedManager] initMessageChatListData];
            [self.navigationController popToRootViewControllerAnimated:YES];
        } failedBlock:^(NSString *errorMessage) {
            [self.view hideWait:CurrentView];
            [self.view makeToast:errorMessage duration:1.0 position:CSToastPositionCenter];
        }];
}

-(void)showPassword{
    
    CGFloat imageOff = -12;
    if (_loginView.textPassword.isSecureTextEntry) {
        UIImage *imgageBTn = [[UIImage imageNamed:@"login_eyes_opend" ] imageWithAlignmentRectInsets:UIEdgeInsetsMake(imageOff, imageOff, imageOff, imageOff)];
        [_loginView.showPasswordBtn setBackgroundImage:imgageBTn forState:UIControlStateNormal];
        _loginView.textPassword.secureTextEntry = NO;
        
    }else{
        
        UIImage *imgageBTn = [[UIImage imageNamed:@"login_eyes_closed" ] imageWithAlignmentRectInsets:UIEdgeInsetsMake(imageOff, imageOff, imageOff, imageOff)];
        [_loginView.showPasswordBtn setBackgroundImage:imgageBTn forState:UIControlStateNormal];
        _loginView.textPassword.secureTextEntry = YES;
    
    }
}
#pragma mark - Private

- (void)configUI{
    
    self.view.backgroundColor = APP_THEME_MAIN_GRAY;
    _loginView  = [[YHLoginView alloc] init];
    TPKeyboardAvoidingScrollView *containerScrollView = [[TPKeyboardAvoidingScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    containerScrollView.backgroundColor = APP_THEME_MAIN_GRAY;
    [self.view addSubview:containerScrollView];
    [_loginView loginVIewWith:containerScrollView];
    [_loginView.loginBtn addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    [_loginView.showPasswordBtn addTarget:self action:@selector(showPassword) forControlEvents:UIControlEventTouchUpInside];
}

@end
