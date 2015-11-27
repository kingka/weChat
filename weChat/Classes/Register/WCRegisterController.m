//
//  WCRegisterController.m
//  weChat
//
//  Created by Imanol on 15/11/27.
//  Copyright © 2015年 Imanol. All rights reserved.
//

#import "WCRegisterController.h"

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
}

- (IBAction)dismiss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
