//
//  chatBodyModel.m
//  emake
//
//  Created by 谷伟 on 2017/9/26.
//  Copyright © 2017年 emake. All rights reserved.
//

#import "chatBodyModel.h"

@implementation chatBodyModel

- (instancetype)initWithText:(NSString *)Text Type:(NSString *)Type{
    
    self.Text = Text;
    self.Type = Type;
    return self;
}
- (instancetype)initWithImage:(NSString *)Image Type:(NSString *)Type{
    self.Image = Image;
    self.Type = Type;
    return self;
}
- (instancetype)initWithEventType:(NSString *)EventType EventText:(NSString *)EventText{
    self.EventType = EventType;
    self.Text = EventText;
    return self;
}
- (instancetype)initWithImage:(NSString *)Image Text:(NSString *)Text ImageUrl:(NSString *)ImageUrl Url:(NSString *)Url Type:(NSString *)Type contract:(NSString *)contract  contractType:(NSString *)contractType contractState:(NSString *)contractState isIncludeTax:(NSString *)isIncludeTax{
    
    self.Image = Image;
    self.Text = Text;
    self.ImageUrl = ImageUrl;
    self.Url = Url;
    self.Type = Type;
    self.Contract = contract;
    self.ContractState = contractState;
    self.ContractType = contractType;
    self.IsIncludeTax = isIncludeTax;
    return self;
}
- (instancetype)initWithJsonString:(NSString *)jsonString Type:(NSString *)Type{
    
    self.Text = jsonString;
    self.Type = Type;
    return self;
}
- (instancetype)initWithVoicePath:(NSString *)voicePath voiceDuration:(NSString *)duration Type:(NSString *)Type{
    self.Type = Type;
    self.Voice = voicePath;
    self.VoiceDuration = duration;
    return self;
}
- (instancetype)initWithText:(NSString *)jsonText FilePath:(NSString *)filePath Type:(NSString *)Type{
    self.Text = jsonText;
    self.Type = Type;
    self.Url = filePath;
    return self;
}
@end
