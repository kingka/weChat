//
//  WCMeController.m
//  weChat
//
//  Created by Imanol on 15/11/30.
//  Copyright © 2015年 Imanol. All rights reserved.
//

#import "WCMeController.h"
#import "WCXMPPTool.h"
#import "CategoryWF.h"
#import "WCXMPPTool.h"
#import "XMPPvCardTemp.h"

@interface WCMeController()
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *jidLabel;

@end

@implementation WCMeController
- (IBAction)logout:(id)sender {
    //zhuxiao
    [[WCXMPPTool sharedXMPPTool] logout];
    // 注销的时候，把沙盒的登录状态设置为NO
    [WCAccount shareAccount].login = NO;
    [[WCAccount shareAccount] saveToSandBox];
    //回登录的控制器
    [UIStoryboard showInitialVCWithName:@"Login"];
}

-(void)viewDidLoad{
    self.jidLabel.text = [@"微信号: " stringByAppendingString:[WCAccount shareAccount].lName];
    XMPPvCardTemp *vCardTemp = [WCXMPPTool sharedXMPPTool].vCard.myvCardTemp;
    self.avatarImageView.image = [UIImage imageWithData:vCardTemp.photo];
}
@end
