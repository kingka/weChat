//
//  AppDelegate.m
//  weChat
//
//  Created by Imanol on 15/11/23.
//  Copyright © 2015年 Imanol. All rights reserved.
//

#import "AppDelegate.h"
#import "WCXMPPTool.h"
#import "DDLog.h"
#import "DDTTYLogger.h"

@interface AppDelegate (){

}

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //配置XMPP的日志
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    
    WCAccount *account = [WCAccount shareAccount];
    if(account.isLogin){
        id main = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateInitialViewController];
         self.window.rootViewController = main;
        //[WCXMPPTool sharedXMPPTool].registerOperation = NO;
        [[WCXMPPTool sharedXMPPTool] login:nil];
    }
    return YES;
}

@end
