//
//  YHMissonCreatSuccessView.h
//  emake
//
//  Created by 谷伟 on 2018/1/7.
//  Copyright © 2018年 emake. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^Block)(id);
@interface YHMissonCreatSuccessView : UIView
@property (nonatomic, copy)Block block;
//店铺下架
- (instancetype)initDisbandView;

- (void)showAnimated;
@end
