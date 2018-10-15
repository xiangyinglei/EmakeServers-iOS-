//
//  YHTabBarViewController.m
//  emake
//
//  Created by eMake on 2017/9/28.
//  Copyright © 2017年 emake. All rights reserved.
//

#import "YHTabBarViewController.h"
#import "WZLBadgeImport.h"
#import "YHMessageListViewController.h"
#import "YHUserMainViewController.h"
#import "YHMineViewController.h"
#import "Header.h"
@interface YHTabBarViewController ()

@end

@implementation YHTabBarViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    YHMessageListViewController *messageListViewController = [[YHMessageListViewController alloc] init];
    
    YHUserMainViewController *userMainViewController = [[YHUserMainViewController alloc] init];
    
    YHMineViewController *mineViewController =[[YHMineViewController alloc] init];
    
    [self addChildControllerWithNav:messageListViewController Name:@"消息" Image:@"xiaoxi-hui" SelectImage:@"xiaoxi"];
    
    [self addChildControllerWithNav:userMainViewController Name:@"平台" Image:@"pingtai-hui" SelectImage:@"pintai"];
    
    [self addChildControllerWithNav:mineViewController Name:@"我" Image:@"wo-hui" SelectImage:@"wo"];

    
    UITabBarItem *Item1 = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemContacts tag:0];
    messageListViewController.tabBarItem = Item1;
    UITabBarItem *Item2 = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemHistory tag:1];
    userMainViewController.tabBarItem = Item2;
    UITabBarItem *Item3 = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemHistory tag:2];
    mineViewController.tabBarItem = Item3;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
