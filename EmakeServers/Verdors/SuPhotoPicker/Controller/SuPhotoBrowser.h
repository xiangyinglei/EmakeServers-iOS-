//
//  SuPhotoBrowser.h
//  LazyWeather
//
//  Created by KevinSu on 15/12/6.
//  Copyright © 2015年 SuXiaoMing. All rights reserved.
//

#import "SuPhotoBaseController.h"
typedef void(^photoBlock) (NSArray *);
@class PHAssetCollection;
@interface SuPhotoBrowser : SuPhotoBaseController

@property (nonatomic, copy) NSString * collectionTitle;
@property (nonatomic, strong) PHAssetCollection * assetCollection;
@property (nonatomic,copy)photoBlock blockSomething;
@end
