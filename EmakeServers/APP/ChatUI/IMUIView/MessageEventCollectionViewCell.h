//
//  MessageEventCollectionViewCell.h
//  sampleObjectC
//
//  Created by oshumini on 2017/6/16.
//  Copyright © 2017年 HXHG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EmakeServers-Swift.h"
#import "Header.h"
#import "YHShoppingCartModel.h"
#import "MessageEventCollectionViewDelegate.h"
#import "YHOrderContract.h"
@interface MessageEventCollectionViewCell : UICollectionViewCell
@property (nonatomic, weak)UIViewController<MessageEventCollectionViewDelegate>* delegate;
@property(strong, nonatomic)UIView *backView;
@property(strong, nonatomic)UILabel *timeView;
@property(copy, nonatomic)NSString *eventText;
- (void)presentCell:(NSString *)eventText;
- (void)setData:(NSString *)eventText;
@end

