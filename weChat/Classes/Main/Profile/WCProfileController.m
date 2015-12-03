//
//  WCProfileController.m
//  weChat
//
//  Created by Imanol on 15/12/3.
//  Copyright © 2015年 Imanol. All rights reserved.
//

#import "WCProfileController.h"
#import "XMPPvCardTemp.h"
#import "WCEditvCardController.h"

@interface WCProfileController ()<editvCardControllerDelegate>
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    switch (selectedCell.tag) {
        case 0:
            WCLog(@"换头像");
            break;
        case 1:
            WCLog(@"进入下一个控制器");
            [self performSegueWithIdentifier:@"toEditVcSegue" sender:selectedCell];
            break;
        case 2:
            WCLog(@"不做任何操作");
            break;
        default:
            break;
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    id destination = segue.destinationViewController;
    WCEditvCardController *controller = destination;
    controller.delegate = self;
    controller.cell = sender;
}

#pragma mark -editvCardControllerDelegate
-(void)editvCardController:(WCEditvCardController *)controller finishedSave:(id)sender{
    
    WCLog(@"完成保存");
    
    //获取当前电子名片
    XMPPvCardTemp *myVCard = [WCXMPPTool sharedXMPPTool].vCard.myvCardTemp;
    
    //重新设置myVCard里的属性
    myVCard.nickname = self.nicknameLabel.text;
    myVCard.orgName = self.orgNameLabel.text;
    
    if (self.departmentLabel.text != nil) {
        myVCard.orgUnits = @[self.departmentLabel.text];
    }
    
    myVCard.title = self.telLabel.text;
    myVCard.note = self.telLabel.text;
    myVCard.mailer = self.emailLabel.text;
    
    //把数据保存到服务器
    // 内部实现数据上传是把整个电子名片数据都从新上传了一次，包括图片
    [[WCXMPPTool sharedXMPPTool].vCard updateMyvCardTemp:myVCard];

}
@end
