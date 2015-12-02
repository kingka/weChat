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
    [[WCXMPPTool sharedXMPPTool] logout];
    [UIStoryboard showInitialVCWithName:@"Login"];
}

-(void)viewDidLoad{
    self.jidLabel.text = [@"微信号: " stringByAppendingString:[WCAccount shareAccount].lName];
    XMPPvCardTemp *vCardTemp = [WCXMPPTool sharedXMPPTool].vCard.myvCardTemp;
    self.avatarImageView.image = [UIImage imageWithData:vCardTemp.photo];
}
@end
