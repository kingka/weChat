//
//  AppDelegate.m
//  weChat
//
//  Created by Imanol on 15/11/23.
//  Copyright © 2015年 Imanol. All rights reserved.
//

#import "AppDelegate.h"
#import "WCXMPPTool.h"

@interface AppDelegate (){

}

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    WCAccount *account = [WCAccount shareAccount];
    if(account.isLogin){
        id main = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateInitialViewController];
         self.window.rootViewController = main;
        [[WCXMPPTool sharedXMPPTool] login:nil];
    }
    return YES;
}

@end
