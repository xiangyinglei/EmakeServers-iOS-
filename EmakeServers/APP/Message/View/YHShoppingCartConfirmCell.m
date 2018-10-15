//
//  YHShoppingCartConfirmCell.m
//  emake
//
//  Created by 谷伟 on 2017/11/13.
//  Copyright © 2017年 emake. All rights reserved.
//

#import "YHShoppingCartConfirmCell.h"
#import "Header.h"
static CGFloat const GoodsNameFont = 15.f;
static CGFloat const GoodsDetailFont = 13.0f;

static CGFloat const spaceLeft = 95.0f;
@interface YHShoppingCartConfirmCell()
@property (nonatomic,strong)UIImageView *itemImage;
@property (nonatomic,strong)UILabel *itemNameLabel;
@property (nonatomic,strong)UILabel *salePrice;
@property (nonatomic,strong)UILabel *itemWeight;
@property (nonatomic,strong)UILabel *itemSize;
@property (nonatomic,strong)UILabel *itemNumber;
@property (nonatomic,strong)UILabel *parameter;
@property (nonatomic,strong)UILabel *WeightStandard;
@property (nonatomic,strong)UILabel *Brand;
@property (nonatomic,strong)UILabel *sizeAndWeight;
@end
@implementation YHShoppingCartConfirmCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (instancetype)init{
    self = [super init];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        UILabel *line = [[UILabel alloc] init];
        line.translatesAutoresizingMaskIntoConstraints =NO;
        line.backgroundColor = SepratorLineColor;
        [self addSubview:line];
        [line PSSetTop:0];
        [line PSSetLeft:0];
        [line PSSetSize:ScreenWidth Height:1];
        
        //产品image
        UIImageView *productionImageView = [[UIImageView alloc] init];
        productionImageView.translatesAutoresizingMaskIntoConstraints = NO;
        productionImageView.backgroundColor = ColorWithHexString(@"ffffff");
        productionImageView.image = [UIImage imageNamed:@"placehold"];
        [self addSubview:productionImageView];
        productionImageView.contentMode = UIViewContentModeScaleAspectFit;
        productionImageView.autoresizesSubviews = YES;
        productionImageView.layer.borderWidth = 1;
        productionImageView.layer.borderColor = SepratorLineColor.CGColor;
        productionImageView.autoresizingMask =
        UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [productionImageView PSSetSize:WidthRate(74) Height:HeightRate(69)];
        [productionImageView PSSetLeft:WidthRate(12)];
        [productionImageView PSSetTop:HeightRate(13)];
        self.productImage = productionImageView;
        
        //产品名称
        UILabel *productNameLable = [[UILabel alloc] init];
        productNameLable.translatesAutoresizingMaskIntoConstraints = NO;
        productNameLable.numberOfLines = 0;
        productNameLable.text = @"200kv-scb11-quanklu";
        productNameLable.font = [UIFont systemFontOfSize:AdaptFont(GoodsNameFont)];
        [self addSubview:productNameLable];
        [productNameLable PSSetTop:HeightRate(11)];
        [productNameLable PSSetLeft:WidthRate(spaceLeft)];
        self.productNameLable = productNameLable;
        
        UILabel *capacityLabel = [[UILabel alloc] init];
        capacityLabel.translatesAutoresizingMaskIntoConstraints = NO;
        capacityLabel.text = @";";
        capacityLabel.font = [UIFont systemFontOfSize:AdaptFont(GoodsDetailFont)];
        capacityLabel.textColor =ColorWithHexString(BASE_FAINTLY_COLOR);
        capacityLabel.numberOfLines = 0;
        capacityLabel.lineBreakMode = NSLineBreakByWordWrapping;
        
        [self addSubview:capacityLabel];
        [capacityLabel PSSetBottomAtItem:productNameLable Length:HeightRate(3)];
        [capacityLabel PSSetLeft:WidthRate(spaceLeft)];
        [capacityLabel PSSetRight:WidthRate(8)];
        self.lbOrderDetail = capacityLabel;
        
        //产品价格
        UILabel *priceLable = [[UILabel alloc] init];
        priceLable.translatesAutoresizingMaskIntoConstraints = NO;
        priceLable.font = [UIFont systemFontOfSize:AdaptFont(GoodsNameFont)];
        priceLable.text = @"¥28888";
        priceLable.textColor =  TextColor_666666;
        priceLable.textAlignment = NSTextAlignmentRight;
        [self addSubview:priceLable];
        self.productPriceLable = priceLable;
        [priceLable PSSetRight:WidthRate(7)];
        [priceLable PSSetBottomAtItem:capacityLabel Length:HeightRate(10)];
        
        
        
        UIView *addView = [[UIView alloc] init];
        addView.translatesAutoresizingMaskIntoConstraints = NO;
        addView.backgroundColor = ColorWithHexString(@"ffffff");//ColorWithHexString(@"FFFBF5");
        [self addSubview:addView];
        [addView PSSetBottomAtItem:priceLable Length:HeightRate(13)];
        [addView PSSetLeft:0];
        [addView PSSetWidth:ScreenWidth];
        self.addSeviceView = addView;

        
        //数量
        UILabel *numberLable = [[UILabel alloc] init];
        numberLable.translatesAutoresizingMaskIntoConstraints = NO;
        numberLable.font = [UIFont systemFontOfSize:AdaptFont(GoodsDetailFont)];
        numberLable.text = @"x2";
        numberLable.textColor =ColorWithHexString(BASE_FAINTLY_COLOR);
        [self addSubview:numberLable];
        [numberLable PSSetRight:WidthRate(9)];
        [numberLable PSSetBottomAtItem:addView Length:HeightRate(3)];
        self.productNumberLable = numberLable;
        
        //小计
        UILabel *weightLabel = [[UILabel alloc] init];
        weightLabel.translatesAutoresizingMaskIntoConstraints = NO;
        weightLabel.text = @"￥1801000.00";
        weightLabel.font = [UIFont systemFontOfSize:AdaptFont(16)];
        weightLabel.textColor =ColorWithHexString(StandardBlueColor);
        [self addSubview:weightLabel];
        [weightLabel PSSetRight:WidthRate(6)];
        [weightLabel PSSetBottomAtItem:numberLable Length:HeightRate(3)];
        self.smallPrice = weightLabel;
        
        UILabel *weight = [[UILabel alloc] init];
        weight.font = [UIFont systemFontOfSize:AdaptFont(12)];
        weight.text = @"小计";
        weight.translatesAutoresizingMaskIntoConstraints = NO;
        weight.textColor =TextColor_666666;
        [self addSubview:weight];
        [weight PSSetLeftAtItem:weightLabel Length:0];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"技术协议" forState:UIControlStateNormal];
        [button setTitleColor:ColorWithHexString(APP_THEME_MAIN_COLOR) forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"fasong02"] forState:UIControlStateNormal];
        [button setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, WidthRate(7))];
        button.layer.borderWidth = WidthRate(1);
        button.layer.borderColor = ColorWithHexString(APP_THEME_MAIN_COLOR).CGColor;
        button.layer.cornerRadius = HeightRate(15);
        button.titleLabel.font = SYSTEM_FONT(AdaptFont(13));
        [button addTarget:self action:@selector(sendProtocol) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        button.translatesAutoresizingMaskIntoConstraints = NO;
        [button PSSetSize:WidthRate(107) Height:HeightRate(30)];
        [button PSSetLeft:WidthRate(WidthRate(10))];
        [button PSSetCenterHorizontalAtItem:weight];
        
        self.sendProtocolButton = button;
        
        UILabel *lable = [[UILabel alloc] init];
        lable.translatesAutoresizingMaskIntoConstraints = NO;
        lable.backgroundColor = SepratorLineColor;
        [self addSubview:lable];
        [lable PSSetBottomAtItem:weight Length:15];
        [lable PSSetLeft:0];
        [lable PSSetSize:ScreenWidth Height:HeightRate(0.5)];
        [lable PSSetBottom:HeightRate(0)];

    }
    return self;
}
- (void)setData:(YHOrder *)model{
    
    [self.productImage sd_setImageWithURL:[NSURL URLWithString:model.GoodsSeriesIcon]];
    self.productNameLable.text = [NSString stringWithFormat:@"%@",model.GoodsTitle];
    self.productPriceLable.text = [NSString stringWithFormat:@"¥%@",[Tools getHaveNum:model.MainProductPrice.doubleValue]];
    
    self.productNumberLable.text =[NSString stringWithFormat:@"x%@",model.GoodsNumber];
    self.lbOrderDetail.text = model.GoodsExplain;
    self.smallPrice.text = [NSString stringWithFormat:@"¥%@",[Tools getHaveNum:floorNumber([model.TotalProductGroupPrice doubleValue])]];
    
   
    if (model.AddServiceArr.count ==0){
        self.addSeviceView.hidden = YES;
    }else{
        CGFloat height = model.AddServiceArr.count*25;
        [self.addSeviceView PSSetHeight:HeightRate(height)];
        self.addSeviceView.hidden = NO;
    }
    for ( int i = 0;i < model.AddServiceArr.count;i++) {
        YHOrderAddSevice *sevice = model.AddServiceArr[i];
            NSString *leftText;
            if ([sevice.GoodsType isEqualToString:@"2"]) {
                if(i==0){
                    leftText = [NSString stringWithFormat:@"%@%@",sevice.GoodsTypeName,sevice.GoodsTitle];
                }else{
                    leftText = [NSString stringWithFormat:@"           %@",sevice.GoodsTitle];
                }
            }else{
                leftText = [NSString stringWithFormat:@"%@%@",sevice.GoodsTypeName,sevice.GoodsTitle];
            }
            NSString *rigthText = [NSString stringWithFormat:@"¥%@",[Tools getHaveNum:sevice.GoodsPrice.doubleValue]];
            UIView *view = [self itemView:leftText rightText:rigthText];
            CGFloat viewY =25*i;
            view.frame = CGRectMake(0, HeightRate(viewY), ScreenWidth, HeightRate(25));
            [self.addSeviceView addSubview:view];
    }
}

- (UIView *)itemView:(NSString *)leftText rightText:(NSString *)rightText{
    
    UIView *view = [[UIView alloc]init];
    UILabel *labelLeft = [[UILabel alloc]init];
    labelLeft.text  = leftText;
    labelLeft.textColor = ColorWithHexString(@"333333");
    labelLeft.tag = 10;
    labelLeft.font = SYSTEM_FONT(AdaptFont(13));
    [view addSubview:labelLeft];
    
    [labelLeft mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(WidthRate(8));
        make.centerY.mas_equalTo(view.centerY);
    }];
    
    UILabel *labelRigth = [[UILabel alloc]init];
    labelRigth.text  = rightText;
    labelRigth.textColor = ColorWithHexString(@"A1A1A1");
    labelRigth.font = SYSTEM_FONT(AdaptFont(13));
    [view addSubview:labelRigth];
    
    [labelRigth mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-WidthRate(8));
        make.centerY.mas_equalTo(view.centerY);

    }];
    
    return view;
}
- (void)sendProtocol{
    if (self.sendBlock) {
        self.sendBlock();
    }
}
@end
