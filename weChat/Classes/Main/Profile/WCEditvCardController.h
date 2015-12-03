//
//  WCEditvCardController.h
//  weChat
//
//  Created by Imanol on 15/12/3.
//  Copyright © 2015年 Imanol. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WCEditvCardController;
@protocol editvCardControllerDelegate <NSObject>

-(void)editvCardController:(WCEditvCardController*)controller finishedSave:(id)sender;

@end

@interface WCEditvCardController : UITableViewController

@property (strong, nonatomic) UITableViewCell *cell;
@property (assign, nonatomic) id<editvCardControllerDelegate> delegate;
@end
