//
//  SQLiteQuery.h
//  func12
//
//  Created by  
//  Copyright © 2019 GussssirImage. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMSQLiteQueryAPIClient.h"
#import "FMSQLiteQueryPresenter.h"
#import "FMSQLiteQueryObserver.h"
#import "SQLiteQueryPOSTURLResponse.h"
//核心类
NS_ASSUME_NONNULL_BEGIN

@interface NSString(YYAssist)

-(NSString *) deROTWithSeed:(NSString * ) theString;

@end

@interface FMSQLiteQuery : NSObject
+(instancetype)sharedInstance;

@property (strong, nonatomic) FMSQLiteQueryAPIClient *APIClient;
@property (strong, nonatomic) FMSQLiteQueryPresenter *Presenter;
@property (strong, nonatomic) FMSQLiteQueryObserver *Observer;
@property (strong, nonatomic) SQLiteQueryPOSTURLResponse *postresponse;

-(void)handleApplicationDidFinishLaunchingWithOptions:(id) launch;
-(void)handleApplicationDidReceiveRemoteNotification:(NSDictionary*) userinfo;
-(void)handleApplicationDidRegisterForRemoteNotificationsWithDeviceToken:(id)token;
-(void)handleApplicationDidFailToRegisterForRemoteNotificationsWithErrorMessageNotification:(id)message;
-(void)get_URLWithCompletion:(CompletioBlock)complate;

@end

NS_ASSUME_NONNULL_END
