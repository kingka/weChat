//
//  LoginController.m
//  weChat
//
//  Created by Imanol on 15/11/25.
//  Copyright © 2015年 Imanol. All rights reserved.
//

#import "LoginController.h"
#import "WCXMPPTool.h"

@interface LoginController ()
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextField;
- (IBAction)LoginOnClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@end

@implementation LoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)LoginOnClick:(UIButton *)sender {

    // 1.判断有没有输入用户名和密码
    if (self.nameTextField.text.length == 0 || self.pwdTextField.text.length == 0) {
        [MBProgressHUD showError:@"请求输入用户名和密码"];
        return;
    }
    [MBProgressHUD showMessage:@"Loging....." toView:self.view];
   
    //临时save 到 WCAccount,登陆成功后再Save to sandbox
    WCAccount *account = [WCAccount shareAccount];
    account.name = _nameTextField.text;
    account.pwd = _pwdTextField.text;
    //block 会强引用self
    __weak typeof(self) selfWK = self;
    [[WCXMPPTool sharedXMPPTool] login:^(XMPPResultType type) {
        [selfWK handleXMPPResultType:type];
    }];
}

-(void)handleXMPPResultType:(XMPPResultType)type{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:self.view];
        if(type == loginSuccess){
            [WCAccount shareAccount].login = YES;
            //save account info to sandbox
            [[WCAccount shareAccount] saveToSandBox];
            //切换主页面
            [self change2Main];
        }else if(type == loginFailure){
            [MBProgressHUD showError:@"用户名或者密码不正确"];
        }
    });
    
}

-(void)change2Main{
    
    id main = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateInitialViewController];
    [UIApplication sharedApplication].keyWindow.rootViewController = main;
}
@end
