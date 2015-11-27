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
    loginFailure
} XMPPResultType;

typedef void(^XMPPResultBlock)(XMPPResultType);

@interface WCXMPPTool : NSObject
-(void)login:(XMPPResultBlock)block;
WCSingletonH(XMPPTool);
@end
