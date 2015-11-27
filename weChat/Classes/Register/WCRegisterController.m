//
//  WCRegisterController.m
//  weChat
//
//  Created by Imanol on 15/11/27.
//  Copyright © 2015年 Imanol. All rights reserved.
//

#import "WCRegisterController.h"
#import "WCAccount.h"
#import "WCXMPPTool.h"

@interface WCRegisterController ()
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextField;
- (IBAction)registerOnClick:(UIButton *)sender;
- (IBAction)dismiss:(id)sender;

@end

@implementation WCRegisterController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)registerOnClick:(UIButton *)sender {
    // 1.判断有没有输入用户名和密码
    if (self.nameTextField.text.length == 0 || self.pwdTextField.text.length == 0) {
        [MBProgressHUD showError:@"请求输入用户名和密码"];
        return;
    }
    [MBProgressHUD showMessage:@"Registing....." toView:self.view];
    
    //临时save 到 WCAccount,登陆成功后再Save to sandbox
    WCAccount *account = [WCAccount shareAccount];
    account.rName = _nameTextField.text;
    account.rpwd = _pwdTextField.text;
    //block 会强引用self
    __weak typeof(self) selfWK = self;
    [WCXMPPTool sharedXMPPTool].registerOperation = YES;
    [[WCXMPPTool sharedXMPPTool] registerToServer:^(XMPPResultType type) {
        [selfWK handleXMPPResultType:type];
    }];

}

-(void)handleXMPPResultType:(XMPPResultType)type{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:self.view];
        if(type == registerSuccess){
            //切换主页面
            [self dismiss:nil];
        }else if(type == registerFailure){
            [MBProgressHUD showError:@"用户已存在"];
        }
    });
    
}

- (IBAction)dismiss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
