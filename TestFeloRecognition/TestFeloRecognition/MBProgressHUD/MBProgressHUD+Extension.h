//
//  MBProgressHUD+Extension.h
//  YouDu
//
//  Created by Walter on 15/8/26.
//  Copyright (c) 2015年 Felo. All rights reserved.
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (Extension)

+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view;
+ (MBProgressHUD *)showMessage:(NSString *)message;

+ (void)showSuccess:(NSString *)success toView:(UIView *)view duration:(NSTimeInterval)interval;
+ (void)showSuccess:(NSString *)success duration:(NSTimeInterval)interval;
+ (void)showSuccess:(NSString *)success toView:(UIView *)view;
+ (void)showSuccess:(NSString *)success;

+ (void)showError:(NSString *)error toView:(UIView *)view duration:(NSTimeInterval)interval;
+ (void)showError:(NSString *)error duration:(NSTimeInterval)interval;
+ (void)showError:(NSString *)error toView:(UIView *)view;
+ (void)showError:(NSString *)error;

+ (void)showText:(NSString *)text toView:(UIView *)view duration:(NSTimeInterval)interval;
+ (void)showText:(NSString *)text duration:(NSTimeInterval)interval;
+ (void)showText:(NSString *)text toView:(UIView *)view;
+ (void)showText:(NSString *)text;
+ (void)showTextAndNetwork:(NSString *)text;

+ (void)hideHUDForView:(UIView *)view;
+ (void)hideHUD;

+ (void)toSuccess:(NSString *)success toView:(UIView *)view duration:(NSTimeInterval)interval;
+ (void)toSuccess:(NSString *)success duration:(NSTimeInterval)interval;
+ (void)toSuccess:(NSString *)success toView:(UIView *)view;
+ (void)toSuccess:(NSString *)success;

+ (void)toError:(NSString *)error toView:(UIView *)view duration:(NSTimeInterval)interval;
+ (void)toError:(NSString *)error duration:(NSTimeInterval)interval;
+ (void)toError:(NSString *)error toView:(UIView *)view;
+ (void)toError:(NSString *)error;

+ (void)toText:(NSString *)text toView:(UIView *)view duration:(NSTimeInterval)interval;
+ (void)toText:(NSString *)text duration:(NSTimeInterval)interval;
+ (void)toText:(NSString *)text toView:(UIView *)view;
+ (void)toText:(NSString *)text;
    
@end
