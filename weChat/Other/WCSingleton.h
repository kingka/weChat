//
//  WCSingleton.h
//  weChat
//
//  Created by Imanol on 15/11/27.
//  Copyright © 2015年 Imanol. All rights reserved.
//

// .h文件
#define WCSingletonH(name) + (instancetype)shared##name;

// .m文件
#define WCSingletonM(name) \
static id _instance = nil; \
+ (id)allocWithZone:(struct _NSZone *)zone \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instance = [super allocWithZone:zone]; \
}); \
return _instance; \
} \
+ (instancetype)shared##name \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instance = [[self alloc] init]; \
}); \
return _instance; \
} \
- (id)copyWithZone:(NSZone *)zone \
{ \
return _instance; \
}

