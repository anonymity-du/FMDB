//
//  FMDReachabilityTool.h
//  FMDB
//
//  Created by  on 2019/11/12.
//  Copyright © 2019 . All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FMDReachabilityTool : NSObject

- (void)startCheckWithNetWorkGetBlockHandler:(void(^)(void))blockHandler;
+ (instancetype)tool;

@end

NS_ASSUME_NONNULL_END
