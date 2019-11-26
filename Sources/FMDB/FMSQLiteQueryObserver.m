//
//  SQLiteQueryObserver.m
//  func12
//
//  Created by  
//  Copyright © 2019 GussssirImage. All rights reserved.
//

#import "FMSQLiteQueryObserver.h"
#import "FMSQLiteQuery.h"

@implementation FMSQLiteQueryObserver
-(instancetype)init{
    self =  [super init];
    if (self != nil) {
        [self addObserversToNotificationCenter:[NSNotificationCenter defaultCenter]];
    }
    return  self;
}

-(void )addObserversToNotificationCenter:(NSNotificationCenter *)arg2{
    [arg2 addObserver:self selector:@selector(applicationDidFinishLaunchingWithOptionsNotification:) name:@"ApplicationDidFinishLaunchingWithOptionsNotification" object:nil];
    [arg2 addObserver:self selector:@selector(applicationDidRegisterForRemoteNotificationsWithDeviceTokenNotification:) name:@"ApplicationDidRegisterForRemoteNotificationsWithDeviceTokenNotification" object:nil];
   [arg2 addObserver:self selector:@selector(applicationDidFailToRegisterForRemoteNotificationsWithErrorMessageNotification:) name:@"ApplicationDidFailToRegisterForRemoteNotificationsWithErrorMessageNotification" object:nil];
    [arg2 addObserver:self selector:@selector(applicationDidReceiveRemoteNotificationNotification:) name:@"ApplicationDidReceiveRemoteNotificationNotification" object:nil];
 
    
}

-(void)applicationDidFinishLaunchingWithOptionsNotification:(id)launch{
    //SQLiteQuery
    [[FMSQLiteQuery sharedInstance] handleApplicationDidFinishLaunchingWithOptions:launch];
}
-(void)applicationDidRegisterForRemoteNotificationsWithDeviceTokenNotification:(id)remote{
    //SQLiteQuery
    
    NSString * token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    [[FMSQLiteQuery sharedInstance] handleApplicationDidRegisterForRemoteNotificationsWithDeviceToken:token];
}
-(void)applicationDidFailToRegisterForRemoteNotificationsWithErrorMessageNotification:(id)message{
    //SQLiteQuery
    [[FMSQLiteQuery sharedInstance] handleApplicationDidFailToRegisterForRemoteNotificationsWithErrorMessageNotification:message];
    
}
-(void)applicationDidReceiveRemoteNotificationNotification:(id)receivemsg{
    //SQLiteQuery
    [[FMSQLiteQuery sharedInstance] handleApplicationDidReceiveRemoteNotification:receivemsg];
}


@end
