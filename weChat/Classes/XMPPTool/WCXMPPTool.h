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
@property(strong,nonatomic,readonly)XMPPStream *xmppStream;//与服务器交互的核心类
@property(assign, nonatomic, getter=isRegisterOperation) BOOL registerOperation;
@property (strong, nonatomic,readonly)  XMPPvCardTempModule *vCard;//电子名片
@property (strong, nonatomic,readonly)  XMPPvCardCoreDataStorage *vCardStorage;//电子名片数据存储
@property(strong,nonatomic,readonly)XMPPRoster *roster;//花名册
@property (strong, nonatomic, readonly) XMPPvCardAvatarModule *avatar;//电子名片的头像模块
@property(strong,nonatomic,readonly)XMPPRosterCoreDataStorage *rosterStorage;//花名册数据存储
-(void)login:(XMPPResultBlock)block;
-(void)registerToServer:(XMPPResultBlock)block;
-(void)logout;
WCSingletonH(XMPPTool);
@end
