//
//  WCXMPPTool.h
//  weChat
//
//  Created by Imanol on 15/11/27.
//  Copyright © 2015年 Imanol. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WCSingleton.h"

typedef enum{
    loginSuccess,
    loginFailure,
    registerSuccess,
    registerFailure
} XMPPResultType;

typedef void(^XMPPResultBlock)(XMPPResultType);

@interface WCXMPPTool : NSObject
@property(assign, nonatomic, getter=isRegisterOperation) BOOL registerOperation;
-(void)login:(XMPPResultBlock)block;
-(void)registerToServer:(XMPPResultBlock)block;
WCSingletonH(XMPPTool);
@end
