//
//  chatBodyModel.h
//  emake
//
//  Created by 谷伟 on 2017/9/26.
//  Copyright © 2017年 emake. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface chatBodyModel : NSObject
@property (nonatomic,copy)NSString *EventType;
@property (nonatomic,copy)NSString *EventText;
@property (nonatomic,copy)NSString *Type;
@property (nonatomic,copy)NSString *Text;
@property (nonatomic,copy)NSString *Image;
@property (nonatomic,copy)NSString *Voice;
@property (nonatomic,assign)NSInteger VoiceDuration;
@property (nonatomic,copy)NSString *Url;
@property (nonatomic,copy)NSString *ImageUrl;
@property (nonatomic,assign)NSInteger UserState;
@property (nonatomic,assign)NSInteger UserType;
@property (nonatomic,copy)NSString *GroupId;
@property (nonatomic,copy)NSString *GroupName;
@property (nonatomic,copy)NSString *GroupDescription;
@property (nonatomic,copy)NSString *LeaderName;
@property (nonatomic,copy)NSString *RefNo;
@property (nonatomic,copy)NSString *Contract;
@property (nonatomic,copy)NSString *ContractType;
@property (nonatomic,copy)NSString *ContractState;
@property (nonatomic,copy)NSString *IsIncludeTax;
//事件
- (instancetype)initWithEventType:(NSString *)EventType EventText:(NSString *)EventText;
//发送文字
- (instancetype)initWithText:(NSString *)Text Type:(NSString *)Type;
//发送图片
- (instancetype)initWithImage:(NSString *)Image Type:(NSString *)Type;
//发送音频
- (instancetype)initWithVoicePath:(NSString *)voicePath voiceDuration:(NSString *)duration Type:(NSString *)Type;
//发送协议
- (instancetype)initWithImage:(NSString *)Image Text:(NSString *)Text ImageUrl:(NSString *)ImageUrl Url:(NSString *)Url Type:(NSString *)Type contract:(NSString *)contract  contractType:(NSString *)contractType contractState:(NSString *)contractState isIncludeTax:(NSString *)isIncludeTax;
//发送产品
- (instancetype)initWithJsonString:(NSString *)jsonString Type:(NSString *)Type;
//发送文件
- (instancetype)initWithText:(NSString *)jsonText FilePath:(NSString *)filePath Type:(NSString *)Type;
@end
 
