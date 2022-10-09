//
//  MBProgressHUD+Extension.m
//  YouDu
//
//  Created by Walter on 15/8/26.
//  Copyright (c) 2015年 Felo. All rights reserved.
//

#import "MBProgressHUD+Extension.h"

// display duration
static const NSTimeInterval DefaultDuration  = 1.0;
static const NSTimeInterval DefaultLongDuration  = 2.0;

@implementation MBProgressHUD (Extension)

+ (UIView *)window {
    for (UIView *view in [UIApplication sharedApplication].windows.reverseObjectEnumerator) {
        NSString *className = [NSString stringWithUTF8String:object_getClassName(view)];
        if ([className rangeOfString:@"EffectsWindow"].location == NSNotFound &&
            [className rangeOfString:@"EffectWindow"].location == NSNotFound &&
            [className rangeOfString:@"KeyboardWindow"].location == NSNotFound) {
            return view;
        }
    }
    return [UIApplication sharedApplication].windows.firstObject;
}

#pragma mark - showMessage
+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view {
    if (view == nil) view = [MBProgressHUD window];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.labelText = message;
    hud.removeFromSuperViewOnHide = YES;
    hud.minSize = CGSizeMake(20, 20);
    hud.userInteractionEnabled = YES;
    return hud;
}

+ (MBProgressHUD *)showMessage:(NSString *)message {
    return [self showMessage:message toView:nil];
}

#pragma mark - show

//暂时用负数的时间表示，小号字体，不设置最小size
+ (void)show:(NSString *)text icon:(NSString *)icon view:(UIView *)view duration:(NSTimeInterval)interval {
    if (view == nil) view = [MBProgressHUD window];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.labelText = text;
    if (icon == nil) {
        hud.mode = MBProgressHUDModeText;
        if (interval < 0) {
            interval = interval * -1;
            hud.labelFont = [UIFont systemFontOfSize:14];
        } else {
            hud.minSize = CGSizeMake(113, 113);
        }
    } else {
        hud.mode = MBProgressHUDModeCustomView;
        hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"MBProgressHUD.bundle/%@", icon]]];
        hud.minSize = CGSizeMake(118, 101);
    }
    hud.userInteractionEnabled = NO;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:interval];
}

#pragma mark - showSuccess
+ (void)showSuccess:(NSString *)success toView:(UIView *)view duration:(NSTimeInterval)interval {
    [self show:success icon:@"success.png" view:view duration:interval];
}

+ (void)showSuccess:(NSString *)success duration:(NSTimeInterval)interval {
    [self showSuccess:success toView:nil duration:interval];
}

+ (void)showSuccess:(NSString *)success toView:(UIView *)view {
    [self showSuccess:success toView:view duration:DefaultDuration];
}

+ (void)showSuccess:(NSString *)success {
    [self showSuccess:success toView:nil];
}

#pragma mark - showError
+ (void)showError:(NSString *)error toView:(UIView *)view duration:(NSTimeInterval)interval {
    [self show:error icon:@"error.png" view:view duration:interval];
}

+ (void)showError:(NSString *)error duration:(NSTimeInterval)interval {
    [self showError:error toView:nil duration:interval];
}

+ (void)showError:(NSString *)error toView:(UIView *)view {
    [self showError:error toView:view duration:DefaultDuration];
}

+ (void)showError:(NSString *)error {
    [self showError:error toView:nil];
}

#pragma mark - showText
+ (void)showText:(NSString *)text toView:(UIView *)view duration:(NSTimeInterval)interval {
    if (text == nil) {
        return;
    }
    [self show:text icon:nil view:view duration:interval];
}

+ (void)showText:(NSString *)text duration:(NSTimeInterval)interval {
    [self showText:text toView:nil duration:interval];
}

+ (void)showText:(NSString *)text toView:(UIView *)view {
    [self showText:text toView:view duration:DefaultDuration];
}

+ (void)showText:(NSString *)text {
    [self showText:text toView:nil];
}

+ (void)showTextAndNetwork:(NSString *)text {
    [self showText:[NSString stringWithString:text] duration:DefaultLongDuration];
}

#pragma mark - to
+ (void)toText:(NSString *)text icon:(NSString *)icon toView:(UIView *)view duration:(NSTimeInterval)interval {
    if (view == nil) view = [self window];
    MBProgressHUD *hud = [self HUDForView:view];
    if (hud == nil) {
        return;
    }
    hud.labelText = text;
    if (icon == nil) {
        hud.mode = MBProgressHUDModeText;
    } else {
        hud.mode = MBProgressHUDModeCustomView;
        hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"MBProgressHUD.bundle/%@", icon]]];
    }
    hud.userInteractionEnabled = NO;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:interval];
}

+ (void)toSuccess:(NSString *)success toView:(UIView *)view duration:(NSTimeInterval)interval {
    [self toText:success icon:@"success" toView:view duration:interval];
}

+ (void)toSuccess:(NSString *)success duration:(NSTimeInterval)interval {
    [self toSuccess:success toView:nil duration:interval];
}

+ (void)toSuccess:(NSString *)success toView:(UIView *)view {
    [self toSuccess:success toView:view duration:DefaultDuration];
}

+ (void)toSuccess:(NSString *)success {
    [self toSuccess:success toView:nil];
}

+ (void)toError:(NSString *)error toView:(UIView *)view duration:(NSTimeInterval)interval {
    [self toText:error icon:@"error" toView:view duration:interval];
}

+ (void)toError:(NSString *)error duration:(NSTimeInterval)interval {
    [self toError:error toView:nil duration:interval];
}

+ (void)toError:(NSString *)error toView:(UIView *)view {
    [self toError:error toView:view duration:DefaultLongDuration];
}

+ (void)toError:(NSString *)error {
    [self toError:error toView:nil];
}

+ (void)toText:(NSString *)text toView:(UIView *)view duration:(NSTimeInterval)interval {
    [self toText:text icon:nil toView:view duration:interval];
}

+ (void)toText:(NSString *)text duration:(NSTimeInterval)interval {
    [self toText:text toView:nil duration:interval];
}

+ (void)toText:(NSString *)text toView:(UIView *)view {
    [self toText:text toView:view duration:DefaultDuration];
}

+ (void)toText:(NSString *)text {
    [self toText:text toView:nil];
}

#pragma mark - hide
+ (void)hideHUDForView:(UIView *)view {
    if (view == nil) view = [self window];
    [self hideHUDForView:view animated:YES];
}

+ (void)hideHUD {
    [self hideHUDForView:nil];
}
@end
