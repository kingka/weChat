//
//  MBProgressHUD+KK.h
//  小团购
//
//  Created by Imanol on 10/5/15.
//  Copyright (c) 2015 Imanol. All rights reserved.
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (KK)

+ (void)showSuccess:(NSString *)success toView:(UIView *)view;
+ (void)showError:(NSString *)error toView:(UIView *)view;

+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view;


+ (void)showSuccess:(NSString *)success;
+ (void)showError:(NSString *)error;

+ (MBProgressHUD *)showMessage:(NSString *)message;

+ (void)hideHUDForView:(UIView *)view;
+ (void)hideHUD;
@end
