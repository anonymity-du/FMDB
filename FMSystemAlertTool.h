//
//  FMSystemAlertTool.h
//  FMDB
//
//  Created by
//  Copyright © 2019 . All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FMSystemAlertTool : NSObject

+ (instancetype)shared;
- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message userData:(id)userData cancelTitle:(NSString *)cancelTitle actions:(NSArray<NSString *> *)actions actionBlock:(void(^)(id userData,NSString *actionTitle))actionBlock;
- (void)showActionSheetWithTitle:(NSString *)title message:(NSString *)message userData:(id)userData cancelTitle:(NSString *)cancelTitle actions:(NSArray<NSString *> *)actions actionBlock:(void(^)(id userData,NSString *actionTitle))actionBlock;

@end

NS_ASSUME_NONNULL_END
