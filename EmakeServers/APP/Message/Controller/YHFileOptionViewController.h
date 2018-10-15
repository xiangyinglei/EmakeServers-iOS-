//
//  YHFileOptionViewController.h
//  EmakeServers
//
//  Created by 谷伟 on 2018/5/28.
//  Copyright © 2018年 谷伟. All rights reserved.
//

#import "BaseViewController.h"
#import "YHFileModel.h"
@interface YHFileOptionViewController : BaseViewController
@property (nonatomic,strong)YHFileModel *fileModel;
@property (nonatomic,copy)NSString *filePath;
@end
