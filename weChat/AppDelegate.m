//
//  AppDelegate.m
//  weChat
//
//  Created by Imanol on 15/11/23.
//  Copyright © 2015年 Imanol. All rights reserved.
//

#import "AppDelegate.h"
#import "XMPP.h"
/*
 1 用户登录流程
 1.初始化XMPPStream
 2.连接服务器(传一个jid)
 3.连接成功，接着发送密码
 // 默认登录成功是不在线的
 4.发送一个 "在线消息" 给服务器 ->可以通知其它用户你上线
 */
@interface AppDelegate ()<XMPPStreamDelegate>{
    
    XMPPStream *_xmppStream;
}
-(void)setupXmppStream;
-(void)connectToHost;
-(void)sendPwdToHost;
-(void)sendOnlineMsg;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self setupXmppStream];
    [self connectToHost];
    return YES;
}

#pragma mark - public methods

#pragma mark - private Methods
#pragma mark 初始化XMPPStream
-(void)setupXmppStream{
    _xmppStream = [[XMPPStream alloc]init];
    //1 设置jid resource 用户登录客户端设备登录的类型
    XMPPJID *jid = [XMPPJID jidWithUser:@"zhangsan" domain:@"imanol.local" resource:@"iPhone"];
    _xmppStream.myJID = jid;
    //2 设置host
    _xmppStream.hostName = @"127.0.0.1";
    //3 设置端口 The default port is 5222.
    _xmppStream.hostPort = 5222;
    //4 设置代理
    [_xmppStream addDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
}

-(void)connectToHost{
    NSError *error = nil;
    [_xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:&error];
    if(error){
        NSLog(@"%@",error);
    }else{
        NSLog(@"发送jid 成功");
    }
}

-(void)sendPwdToHost{
    NSError *error = nil;
    [_xmppStream authenticateWithPassword:@"123456" error:&error];
    if(error){
        NSLog(@"%@",error);
    }
}

-(void)sendOnlineMsg{
    //XMPP框架，已经把所有的指令封闭成对象
    XMPPPresence *presence = [XMPPPresence presence];
    [_xmppStream sendElement:presence];
}

#pragma mark - xmppstream delegate
-(void)xmppStreamDidConnect:(XMPPStream *)sender{
    NSLog(@"%s",__func__);
    [self sendPwdToHost];
}

-(void)xmppStreamDidAuthenticate:(XMPPStream *)sender{
    NSLog(@"%s",__func__);
    [self sendOnlineMsg];
}

-(void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(DDXMLElement *)error{
    NSLog(@"%s",__func__);
}
@end
