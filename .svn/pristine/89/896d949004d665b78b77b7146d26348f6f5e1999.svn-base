//
//  PSMicros.h
//  emake
//
//  Created by chenyi on 2017/7/14.
//  Copyright © 2017年 emake. All rights reserved.
//  Version 0.0.1 Modify by chenyi on 2017-09-12

#ifndef PSMicros_h
#define PSMicros_h

//颜色和字体
#define RGBColor(r,g,b) [UIColor colorWithRed: (r) / 255.0 green: (g) / 255.0 blue: (b) / 255.0 alpha: 1.0]
#define RGBAColor(r,g,b,a) [UIColor colorWithRed: (r) / 255.0 green: (g) / 255.0 blue: (b) / 255.0 alpha: 1.0]
#define COLOR_CLEAR [UIColor clearColor]

//shared
#define DEFINE_SINGLETON_FOR_CLASS(className) \
\
+ (className *)shared { \
static className *instance = nil; \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
instance = [[self alloc] init]; \
}); \
return instance; \
}

//方法和属性弃用
//__attribute__((unavailable("该方法废弃")))
//方法和属性过时
//

#endif /* PSMicros_h */
