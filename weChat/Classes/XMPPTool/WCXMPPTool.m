//
//  WCXMPPTool.m
//  weChat
//
//  Created by Imanol on 15/11/27.
//  Copyright © 2015年 Imanol. All rights reserved.
//

#import "WCXMPPTool.h"

/*
 1 用户登录流程
 1.初始化XMPPStream
 2.连接服务器(传一个jid)
 3.连接成功，接着发送密码
 // 默认登录成功是不在线的
 4.发送一个 "在线消息" 给服务器 ->可以通知其它用户你上线
 */
@interface WCXMPPTool ()<XMPPStreamDelegate>{
    
    
    XMPPResultBlock _resultBlock;
}
-(void)setupXmppStream;
-(void)connectToHost;
-(void)sendPwdToHost;
-(void)sendPwdToHostFromRegister;
-(void)sendOnlineMsg;
@end

@implementation WCXMPPTool

WCSingletonM(XMPPTool);

-(void)dealloc{
    
    [self teardownStream];
    
}

#pragma mark - public methods
-(void)logout{
    [self sendOffLineMsg];
    [_xmppStream disconnect];
}

-(void)login:(XMPPResultBlock)block{
    //先断开之前发送的连接
    [_xmppStream disconnect];
    //保存block, 因为不是在本方法回掉block
    _resultBlock = block;
    
    [self connectToHost];
}

-(void)registerToServer:(XMPPResultBlock)block{
    //先断开之前发送的连接
    [_xmppStream disconnect];
    //保存block, 因为不是在本方法回掉block
    _resultBlock = block;
    
    [self connectToHost];
}
#pragma mark - private Methods
-(void)sendOffLineMsg{
    XMPPPresence *offline = [XMPPPresence presenceWithType:@"unavailable"];
    [_xmppStream sendElement:offline];
}

-(void)teardownStream{
    //移除代理
    [_xmppStream removeDelegate:self];
    
    //取消模块
    [_avatar deactivate];
    [_vCard deactivate];
    [_roster deactivate];
    [_msgArchiving deactivate];
    
    //断开连接
    [_xmppStream disconnect];
    
    //清空资源
    _roster = nil;
    _rosterStorage = nil;
    _vCardStorage = nil;
    _vCard = nil;
    _avatar = nil;
    _xmppStream = nil;
    _msgArchiving = nil;
    _msgArchingStorage = nil;
    
}

#pragma mark 初始化XMPPStream
-(void)setupXmppStream{
    _xmppStream = [[XMPPStream alloc]init];
    //*添加xmpp 其他模块
    _vCardStorage = [XMPPvCardCoreDataStorage sharedInstance];
    _vCard = [[XMPPvCardTempModule alloc]initWithvCardStorage:_vCardStorage];
    _avatar = [[XMPPvCardAvatarModule alloc]initWithvCardTempModule:_vCard];
    _rosterStorage = [XMPPRosterCoreDataStorage sharedInstance];
    _roster = [[XMPPRoster alloc]initWithRosterStorage:_rosterStorage];
    _msgArchingStorage = [XMPPMessageArchivingCoreDataStorage sharedInstance];
    _msgArchiving = [[XMPPMessageArchiving alloc]initWithMessageArchivingStorage:_msgArchingStorage];
    //*激活
    [_vCard activate:_xmppStream];
    [_avatar activate:_xmppStream];
    [_roster activate:_xmppStream];
    [_msgArchiving activate:_xmppStream];
    // 设置代理
    [_xmppStream addDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
}

-(void)connectToHost{
    if(_xmppStream == nil){
        [self setupXmppStream];
    }
    
     WCAccount *account = [WCAccount shareAccount];
    //1 设置jid resource 用户登录客户端设备登录的类型
    XMPPJID *jid = nil;
    //判断登陆or 注册
    if(self.registerOperation){
        jid = [XMPPJID jidWithUser:account.rName domain:account.domain resource:nil];
    }else{
        jid = [XMPPJID jidWithUser:account.lName domain:account.domain resource:nil];
    }
    _xmppStream.myJID = jid;
    //2 设置host
    _xmppStream.hostName = account.host;
    //3 设置端口 The default port is 5222.
    _xmppStream.hostPort = account.port;
    
    NSError *error = nil;
    [_xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:&error];
    if(error){
        WCLog(@"%@",error);
    }else{
        WCLog(@"发送jid 成功");
    }
}

-(void)sendPwdToHost{
    WCAccount *account = [WCAccount shareAccount];
    NSError *error = nil;
    WCLog(@"登陆： %@",account.lName);
    [_xmppStream authenticateWithPassword:account.lpwd error:&error];
    if(error){
        WCLog(@"%@",error);
    }
}

-(void)sendPwdToHostFromRegister{
    WCAccount *account = [WCAccount shareAccount];
    NSError *error = nil;
    WCLog(@"注册： %@",account.rName);
    [_xmppStream registerWithPassword:account.rpwd error:&error];
    if(error){
        WCLog(@"%@",error);
    }
}

-(void)sendOnlineMsg{
    //XMPP框架，已经把所有的指令封闭成对象
    XMPPPresence *presence = [XMPPPresence presence];
    [_xmppStream sendElement:presence];
}

#pragma mark - xmppstream delegate
-(void)xmppStreamDidConnect:(XMPPStream *)sender{
    WCLog(@"连接成功");
    if(self.isRegisterOperation){
        [self sendPwdToHostFromRegister];
    }else{
        [self sendPwdToHost];
    }
    
}

-(void)xmppStreamDidAuthenticate:(XMPPStream *)sender{
    WCLog(@"授权成功");
    //回掉resultBlock
    if(_resultBlock){
        _resultBlock(loginSuccess);
    }
    [self sendOnlineMsg];
}

-(void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(DDXMLElement *)error{
    WCLog(@"授权失败");
    //回掉resultBlock
    if(_resultBlock){
        _resultBlock(loginFailure);
    }

}

#pragma mark - 注册成功
-(void)xmppStreamDidRegister:(XMPPStream *)sender{
    WCLog(@"注册成功");
    //回掉resultBlock
    if(_resultBlock){
        _resultBlock(registerSuccess);
    }

}

#pragma mark - 注册失败
-(void)xmppStream:(XMPPStream *)sender didNotRegister:(DDXMLElement *)error{
    WCLog(@"注册失败");
    //回掉resultBlock
    if(_resultBlock){
        _resultBlock(registerFailure);
    }

}
@end
