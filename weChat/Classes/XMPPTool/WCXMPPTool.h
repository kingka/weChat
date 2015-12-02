//
//  WCXMPPTool.h
//  weChat
//
//  Created by Imanol on 15/11/27.
//  Copyright © 2015年 Imanol. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WCSingleton.h"
#import "XMPPFramework.h"

typedef enum{
    loginSuccess,
    loginFailure,
    registerSuccess,
    registerFailure
} XMPPResultType;

typedef void(^XMPPResultBlock)(XMPPResultType);

@interface WCXMPPTool : NSObject
@property(assign, nonatomic, getter=isRegisterOperation) BOOL registerOperation;
@property (strong, nonatomic)  XMPPvCardTempModule *vCard;//电子名片
@property (strong, nonatomic)  XMPPvCardCoreDataStorage *vCardStorage;//电子名片数据存储
-(void)login:(XMPPResultBlock)block;
-(void)registerToServer:(XMPPResultBlock)block;
-(void)logout;
WCSingletonH(XMPPTool);
@end
