//
//  AppDelegate.h
//  weChat
//
//  Created by Imanol on 15/11/23.
//  Copyright © 2015年 Imanol. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    loginSuccess,
    loginFailure
} XMPPResultType;

typedef void(^XMPPResultBlock)(XMPPResultType);

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

-(void)login:(XMPPResultBlock)block;
@end

