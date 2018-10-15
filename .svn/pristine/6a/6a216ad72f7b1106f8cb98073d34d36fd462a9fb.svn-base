//
//  OSSClient.h
//  emake
//
//  Created by apple on 2017/8/23.
//  Copyright © 2017年 emake. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Header.h"
@interface OSSClientLike : NSObject

+(OSSClientLike *)sharedClient;

//第一次上传必须初始化client
- (void)initOSSClient;

//上传图片
- (void)uploadObjectAsync:(UIImage *)uploadImage withFileName:(NSString *)fileName andType:(OSSUploadType)type succcessBlock:(void(^)())success failBLock:(void(^)())failBlock;
//上传语音
- (void)uploadVoiceObjectAsync:(NSString *)uploadPath withFileName:(NSString *)fileName andType:(OSSUploadType)type succcessBlock:(void(^)())success failBLock:(void(^)())failBlock;
//上传文件
- (void)uploadFileObjectAsync:(NSData *)uploadData withFileName:(NSString *)fileName andType:(OSSUploadType)type succcessBlock:(void(^)())success failBLock:(void(^)())failBlock;
//下载文件到本地
- (void)downloadFileObjectAsyncWithFileName:(NSString *)fileName andDownloadTargetFile:(NSString *)downLoadFile succcessBlock:(void(^)())success failBLock:(void(^)())failBlock;
@end
