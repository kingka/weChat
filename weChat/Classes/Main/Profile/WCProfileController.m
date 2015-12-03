//
//  WCProfileController.m
//  weChat
//
//  Created by Imanol on 15/12/3.
//  Copyright © 2015年 Imanol. All rights reserved.
//

#import "WCProfileController.h"
#import "XMPPvCardTemp.h"

@interface WCProfileController ()
@property (weak, nonatomic) IBOutlet UIImageView *avatarImgView;//头像
@property (weak, nonatomic) IBOutlet UILabel *nicknameLabel;//昵称
@property (weak, nonatomic) IBOutlet UILabel *wechatNumLabel;//微信号
@property (weak, nonatomic) IBOutlet UILabel *orgNameLabel;//公司
@property (weak, nonatomic) IBOutlet UILabel *departmentLabel;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;//职位

@property (weak, nonatomic) IBOutlet UILabel *telLabel;//电话

@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@end

@implementation WCProfileController

-(void)viewDidLoad{
    [super viewDidLoad];
    XMPPvCardTemp *myvCard = [WCXMPPTool sharedXMPPTool].vCard.myvCardTemp;
    if(myvCard.photo){
        self.avatarImgView.image = [UIImage imageWithData:myvCard.photo];
    }
    // 微信号 (显示用户名)
    self.wechatNumLabel.text =[WCAccount shareAccount].lName;
    
    self.nicknameLabel.text = myvCard.nickname;
    
    //公司
    self.orgNameLabel.text = myvCard.orgName;
    
    //部门
    if (myvCard.orgUnits.count > 0) {
        self.departmentLabel.text = myvCard.orgUnits[0];
    }
    
    //职位
    self.titleLabel.text = myvCard.title;
    
    //电话
    //self.telLabel.text = myvCard.telecomsAddresses[0];
    //使用note充当电话
    self.telLabel.text = myvCard.note;
    
    //邮箱
    // 使用mailer充当
    self.emailLabel.text = myvCard.mailer;

}
@end
