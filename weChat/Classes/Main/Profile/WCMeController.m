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
@implementation WCMeController
- (IBAction)logout:(id)sender {
    [[WCXMPPTool sharedXMPPTool] logout];
    [UIStoryboard showInitialVCWithName:@"Login"];
}

@end
