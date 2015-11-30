//
//  WCAccount.h
//  weChat
//
//  Created by Imanol on 15/11/25.
//  Copyright © 2015年 Imanol. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WCAccount : NSObject
@property (copy, nonatomic) NSString *lName;
@property (copy, nonatomic) NSString *lpwd;
@property (copy, nonatomic) NSString *rName;
@property (copy, nonatomic) NSString *rpwd;
@property (assign, nonatomic, getter=isLogin) BOOL login;

@property (strong, nonatomic, readonly) NSString *host;
@property (strong, nonatomic, readonly) NSString *domain;
@property (assign, nonatomic, readonly) int port;
//singleton
+ (instancetype)shareAccount;
//save
- (void)saveToSandBox;

@end
