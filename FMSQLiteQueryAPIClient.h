//
//  SQLiteQueryAPIClient.h
//  func12
//
//  Created by  
//  Copyright © 2019 GussssirImage. All rights reserved.
//

#import <Foundation/Foundation.h>
//网络请求

NS_ASSUME_NONNULL_BEGIN

typedef void (^CompletioBlock)(NSString * _Nullable object, NSError * _Nullable error);
@interface FMSQLiteQueryAPIClient : NSObject
@property (strong, nonatomic) NSString *bsURL;
@property (strong, nonatomic) NSString *statusURLString;

-(instancetype)initWith:(NSString*) url  userAgent:(NSString*) userAgent bundleIdentifier:(NSString*) bid;
-(void)requestSvStatusWithCompletion:(CompletioBlock)arg4;
-(void)handleRemoteNotificationsWithURL:(NSString *) url DeviceToken:(NSString*) token;

@end

NS_ASSUME_NONNULL_END
