//
//  ViewController.h
//  sampleObjectC
//
//  Created by oshumini on 2017/6/6.
//  Copyright © 2017年 HXHG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "Header.h"
@interface ChatNewViewController :BaseViewController
@property(nonatomic,assign)BOOL isDisplayArchiveMessage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topHeight;
@property(nonatomic,copy)NSString *contractNo;
@property(nonatomic,copy)NSString *userAvatar;
@property(nonatomic,copy)NSString *userName;
@property(nonatomic,copy)NSString *userType;
@property(nonatomic,copy)NSString *phoneNumber;
@property(nonatomic,copy)NSString *filePath;
@property(nonatomic,copy)NSString *fileName;
@property(nonatomic,copy)NSData *fileData;
@property(nonatomic,copy)NSArray *archiveData;
@property (nonatomic,assign)BOOL isUploadFile;
@property (nonatomic,assign)BOOL isLookUpArchive;

//和店铺聊天的建立的唯一标识listID (storeID_userID)/（userID）
@property (nonatomic,copy)NSString *listID;
@property (nonatomic,copy)NSString *storeID;

@property (nonatomic,copy)NSString *titleName;


-(void)onMessgae:(NSData *)messgae topic:(NSString *)topic;

@end

