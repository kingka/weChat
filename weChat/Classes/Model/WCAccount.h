//
//  WCAccount.h
//  weChat
//
//  Created by Imanol on 15/11/25.
//  Copyright © 2015年 Imanol. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WCAccount : NSObject
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *pwd;
@property (assign, nonatomic, getter=isLogin) BOOL login;

//singleton
+ (instancetype)shareAccount;
//save
- (void)saveToSandBox;
@end
