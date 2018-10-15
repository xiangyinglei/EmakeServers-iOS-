//
//  UITabBarController+Common.m
//  emake
//
//  Created by chenyi on 2017/7/14.
//  Copyright © 2017年 emake. All rights reserved.
//

#import "UITabBarController+Common.h"
#import "PSMicros.h"

@implementation UITabBarController (Common)

-(void) addChildControllerWithNav: (UIViewController *) controller Name:(NSString *) name Image:(NSString *) image SelectImage:(NSString *) selectImage
{
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:controller];
    nav.tabBarItem.title = name;
    nav.tabBarItem.image = [[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    nav.tabBarItem.selectedImage = [[UIImage imageNamed:selectImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    [[UITabBarItem appearance]setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13],NSForegroundColorAttributeName:[UIColor grayColor]}   forState:UIControlStateNormal];
    
    [[UITabBarItem appearance]setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13],NSForegroundColorAttributeName:RGBColor(66, 191, 197)} forState:UIControlStateSelected];
    
    [self addChildViewController:nav];
}

@end
