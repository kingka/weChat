//
//  WCAccount.m
//  weChat
//
//  Created by Imanol on 15/11/25.
//  Copyright © 2015年 Imanol. All rights reserved.
//

#import "WCAccount.h"

static NSString *domain = @"imanol.local";
static NSString *host = @"127.0.0.1";
static int port = 5222;

@implementation WCAccount

+(instancetype)shareAccount{
    return [[self alloc]init];
}

+(instancetype)allocWithZone:(struct _NSZone *)zone{
    static WCAccount *account;
    // 为了线程安全
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if(account == nil){
            account = [super allocWithZone:zone];
            //从沙盒获取上次的用户登录信息
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            account.lName = [defaults objectForKey:WCName];
            account.lpwd = [defaults objectForKey:WCPWD];
            account.login = [defaults boolForKey:WCLoginStatus];
        }
    });
    return account;
}

-(void)saveToSandBox{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.lName forKey:WCName];
    [defaults setObject:self.lpwd forKey:WCPWD];
    [defaults setBool:self.login forKey:WCLoginStatus];
    [defaults synchronize];
}

-(NSString *)domain{
    return domain;
}

-(NSString *)host{
    return host;
}

-(int)port{
    return port;
}
@end
