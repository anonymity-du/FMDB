//
//  FMSystemAlertTool.m
//  FMDB
//
//  Created by
//  Copyright © 2019 . All rights reserved.
//

#import "FMSystemAlertTool.h"
#import <UIKit/UIKit.h>

@implementation FMSystemAlertTool

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message userData:(id)userData cancelTitle:(NSString *)cancelTitle actions:(NSArray<NSString *> *)actions actionBlock:(void(^)(id userData,NSString *actionTitle))actionBlock{
    NSString *tStr = title;
    if(title.length == 0){
        tStr = nil;
    }
    NSString *mStr = message;
    if(message.length == 0){
        mStr = nil;
    }
    
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:tStr message:mStr preferredStyle:UIAlertControllerStyleAlert];
    UIView *v = nil;
    if([[UIDevice currentDevice].model isEqualToString:@"iPad"]){
        UIPopoverPresentationController *popover = controller.popoverPresentationController;
        v = [[UIView alloc] init];
        CGFloat w = [UIScreen mainScreen].bounds.size.width;
        CGFloat h = [UIScreen mainScreen].bounds.size.height;
        
        CGFloat vW = 1;
        
        v.frame = CGRectMake((w - vW) * 0.5, (h - vW) * 0.5f, vW, vW);
        v.userInteractionEnabled = NO;
        [[self keyWindow] addSubview:v];
        popover.sourceView = v;
        popover.sourceRect = v.bounds;
        popover.permittedArrowDirections = UIPopoverArrowDirectionUnknown;
    }
    
    __block typeof(actionBlock) tmpActionBlock = actionBlock;
    __block typeof(userData) tmpUserData = userData;
    for (NSString *actionTitle in actions) {
        UIAlertAction *tAction = [UIAlertAction actionWithTitle:actionTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if(nil != v){
                [v removeFromSuperview];
            }
            if(tmpActionBlock){
                tmpActionBlock(tmpUserData,action.title);
            }
        }];
        [controller addAction:tAction];
    }
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        if(nil != v){
            [v removeFromSuperview];
        }
        if(tmpActionBlock){
            tmpActionBlock(tmpUserData,action.title);
        }
    }];
    [controller addAction:cancelAction];
    [[self rootVC] presentViewController:controller animated:YES completion:^{
        
    }];
}

- (void)showActionSheetWithTitle:(NSString *)title message:(NSString *)message userData:(id)userData cancelTitle:(NSString *)cancelTitle actions:(NSArray<NSString *> *)actions actionBlock:(void(^)(id userData,NSString *actionTitle))actionBlock{
    NSString *tStr = title;
    if(title.length == 0){
        tStr = nil;
    }
    NSString *mStr = message;
    if(message.length == 0){
        mStr = nil;
    }
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:tStr message:mStr preferredStyle:UIAlertControllerStyleActionSheet];
    UIView *v = nil;
    if([[UIDevice currentDevice].model isEqualToString:@"iPad"]){
        UIPopoverPresentationController *popover = controller.popoverPresentationController;
        v = [[UIView alloc] init];
        CGFloat w = [UIScreen mainScreen].bounds.size.width;
        CGFloat h = [UIScreen mainScreen].bounds.size.height;
        
        CGFloat vW = 1;
        
        v.frame = CGRectMake((w - vW) * 0.5, (h - vW) * 0.5f, vW, vW);
        v.userInteractionEnabled = NO;
        [[self keyWindow] addSubview:v];
        popover.sourceView = v;
        popover.sourceRect = v.bounds;
        popover.permittedArrowDirections = UIPopoverArrowDirectionDown;
    }
    
    __block typeof(actionBlock) tmpActionBlock = actionBlock;
    __block typeof(userData) tmpUserData = userData;
    for (NSString *actionTitle in actions) {
        UIAlertAction *tAction = [UIAlertAction actionWithTitle:actionTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if(nil != v){
                [v removeFromSuperview];
            }
            if(tmpActionBlock){
                tmpActionBlock(tmpUserData,action.title);
            }
        }];
        [controller addAction:tAction];
    }
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        if(nil != v){
            [v removeFromSuperview];
        }
    }];
    [controller addAction:cancelAction];
    
    [[self rootVC] presentViewController:controller animated:YES completion:^{
        
    }];
}

#pragma mark - key windown & root vc

- (UIViewController *)rootVC{
    UIWindow *window = [self keyWindow];
    UIViewController *rootVC = nil;
    if(window){
        rootVC = window.rootViewController;
    }
    else
    {
        rootVC =  [[[[UIApplication sharedApplication] windows] firstObject] rootViewController];
    }
    return rootVC;
}

- (UIWindow *)keyWindow{
    UIWindow *window = nil;
    if([[UIApplication sharedApplication].delegate respondsToSelector:@selector(window)]){
        window = [UIApplication sharedApplication].delegate.window;
    }
    if(window){
        return window;
    }
    else
    {
        if (@available(iOS 13.0,*)) {
            for (UIScene *scene in [UIApplication sharedApplication].connectedScenes) {
                NSArray *winDelegate = [(UIWindowScene *)scene windows];
                for (UIWindow *w in winDelegate) {
                    if(w.windowLevel == 0){
                        window = w;
                        break;
                    }
                }
                if(window){
                    break;
                }
            }
        }
        return window;
    }
}

+ (instancetype)shared{
    static FMSystemAlertTool *alert = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        alert = [[FMSystemAlertTool alloc] init];
    });
    return alert;
}

@end
