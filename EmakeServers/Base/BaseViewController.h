//
//  BaseViewController.h
//  EmakeServers
//
//  Created by 谷伟 on 2018/1/31.
//  Copyright © 2018年 谷伟. All rights reserved.
//

#import <UIKit/UIKit.h>
//通用block传值
typedef void(^Block)(id);
@interface BaseViewController : UIViewController

//通用block
@property (nonatomic, copy) Block block;
-(void) back:(UIButton *)button;
-(void) addRightNavBtn:(NSString *)title;
- (void)rightBtnClick:(UIButton *)sender;
- (void)setRightBtnTitle:(NSString *)title;
- (void)setRightBtnImage:(NSString *)imageName;
//右上角左侧按钮点击事件
- (void)leftDropBtnStyleClick:(UIButton *)sender;
//改右上角左侧按钮标题
- (void)changeLeftDropBtnStyleTitle:(NSString *)title;
//下拉展示
- (void)addRigthDropBtn;
- (void)addRigthDropBtnAndLeftTitle:(NSString *)tilte;
-(UIToolbar *)addToolbar;
//
@end
