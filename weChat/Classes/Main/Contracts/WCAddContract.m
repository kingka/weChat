//
//  WCAddContract.m
//  weChat
//
//  Created by Imanol on 15/12/8.
//  Copyright © 2015年 Imanol. All rights reserved.
//

#import "WCAddContract.h"

@interface WCAddContract()

@property (weak, nonatomic) IBOutlet UITextField *searchTextField;

@end

@implementation WCAddContract



- (IBAction)addBtnClick:(id)sender {
    
    NSString *user = self.searchTextField.text;
    
    if([user isEqualToString:[WCAccount shareAccount].lName]){
        
        [self showMsg:@"不能添加自己"];
        return;
    }
    
    //与存在的也不需要添加
    XMPPJID *userJid = [XMPPJID jidWithUser:self.searchTextField.text domain:[WCAccount shareAccount].domain resource:nil];
    BOOL exist = [[WCXMPPTool sharedXMPPTool].rosterStorage userExistsWithJID:userJid xmppStream:[WCXMPPTool sharedXMPPTool].xmppStream];
    if(exist){
        
        [self showMsg:@"已存在"];
        return;
    }
    
    //订阅
    [[WCXMPPTool sharedXMPPTool].roster subscribePresenceToUser:userJid];
    /*添加好友在现有openfire存在的问题
     1.添加不存在的好友，通讯录里面也现示了好友
     解决办法1. 服务器可以拦截好友添加的请求，如当前数据库没有好友，不要返回信息
     <presence type="subscribe" to="werqqrwe@teacher.local"><x xmlns="vcard-temp:x:update"><photo>b5448c463bc4ea8dae9e0fe65179e1d827c740d0</photo></x></presence>
     
     解决办法2.过滤数据库的Subscription字段查询请求
     none 对方没有同意添加好友
     to 发给对方的请求
     from 别人发来的请求
     both 双方互为好友
     
     */

}

-(void)showMsg:(NSString *)msg{
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
    
    [av show];
}
@end
