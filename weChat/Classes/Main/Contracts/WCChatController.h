//
//  WCChatController.h
//  weChat
//
//  Created by Imanol on 15/12/14.
//  Copyright © 2015年 Imanol. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WCChatController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)send:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (strong, nonatomic) XMPPJID *friendJid;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstrain;
@end
