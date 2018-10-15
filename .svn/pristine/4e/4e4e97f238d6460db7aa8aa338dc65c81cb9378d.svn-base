//
//  YHShoppingCartConfirmCell.h
//  emake
//
//  Created by 谷伟 on 2017/11/13.
//  Copyright © 2017年 emake. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YHOrder.h"
typedef void(^sendProtocolBlock)(void);
@interface YHShoppingCartConfirmCell : UITableViewCell
@property(nonatomic,strong)UIImageView *productImage;
@property(nonatomic,strong)UILabel *productNameLable;
@property(nonatomic,strong)UILabel *productPriceLable;
@property(nonatomic,strong)UILabel *productNumberLable;
@property (nonatomic,strong)UILabel *lbBrandPrice;
@property (nonatomic,strong)UILabel *lbAccessoryPrice;
@property (nonatomic,strong)UILabel *smallPrice;
@property (nonatomic,strong)UILabel *sizeLabel;
@property (nonatomic,strong)UILabel *lbAccessory;
@property (nonatomic,strong)UILabel *lbBrand;
@property (nonatomic,strong)UILabel *lbRemark;
@property (nonatomic,strong)UIView *addSeviceView;
@property (nonatomic,strong)UILabel *lbOrderDetail;
@property (nonatomic,strong)UIButton *sendProtocolButton;
@property (nonatomic,copy)sendProtocolBlock sendBlock;
- (void)setData:(YHOrder *)model;
@end
