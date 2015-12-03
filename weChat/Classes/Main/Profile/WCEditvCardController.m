//
//  WCEditvCardController.m
//  weChat
//
//  Created by Imanol on 15/12/3.
//  Copyright © 2015年 Imanol. All rights reserved.
//

#import "WCEditvCardController.h"

@interface WCEditvCardController ()
@property (weak, nonatomic) IBOutlet UITextField *textField;
- (IBAction)saveBtnClick:(UIBarButtonItem *)sender;

@end

@implementation WCEditvCardController

-(void)viewDidLoad{
    
    self.title = _cell.textLabel.text;
    self.textField.text = _cell.detailTextLabel.text;
}

- (IBAction)saveBtnClick:(UIBarButtonItem *)sender {
    
    _cell.detailTextLabel.text = self.textField.text;
    [self.navigationController popViewControllerAnimated:YES];
    if([self.delegate respondsToSelector:@selector(editvCardController:finishedSave:)]){
        
        [self.delegate editvCardController:self finishedSave:sender];
    }
}
@end
