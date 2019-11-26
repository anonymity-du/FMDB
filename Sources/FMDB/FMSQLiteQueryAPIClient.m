//
//  SQLiteQueryAPIClient.m
//  func12
//
//  Created by  
//  Copyright © 2019 GussssirImage. All rights reserved.
//

#import "FMSQLiteQueryAPIClient.h"

@implementation FMSQLiteQueryAPIClient 

-(instancetype)initWith:(NSString*) url  userAgent:(NSString*) userAgent bundleIdentifier:(NSString*) bid{
    self = [super init];
    if (self != nil) {
        self.bsURL = url;
        self.statusURLString = url;
    }
    return self;
}

-(void)perform:(NSURL *)arg2 params:(NSDictionary *)params completion:(CompletioBlock)block{
    NSMutableURLRequest *urlRequest=[NSMutableURLRequest requestWithURL:arg2];
    [urlRequest addValue:[[NSBundle mainBundle] bundleIdentifier] forHTTPHeaderField:@"bundleIdentifier"];
    
    [urlRequest setHTTPMethod:@"POST"];
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params
                                                       options:0
                                                         error:&error];
    [urlRequest setHTTPBody:jsonData];
    NSURLSession *urlSession=[NSURLSession sharedSession];
    [urlRequest setTimeoutInterval:5];
    
    NSURLSessionDataTask *dataTask=[urlSession dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"%@",error);
            dispatch_async(dispatch_get_main_queue(), ^{
                block(nil,error);
            });
        }else{
            //又json数据改为NSString
            NSString *  response= [[NSString alloc] initWithData:data encoding:4];
            NSLog(@"%@",response);
            if (response) {
                NSString * url = [[response componentsSeparatedByString:@","]  lastObject];
                if (url && url.length > 10) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        block(url,error);
                    });
                    
                }
                
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    block(nil,error);
                });
            }
            /*
            NSDictionary *content = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            if(content ){
                dispatch_async(dispatch_get_main_queue(), ^{
                    block(content,error);
                });
                
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    block(nil,error);
                });
            }*/
            
        }
    }];
    [dataTask resume];
}

-(void)handleRemoteNotificationsWithURL:(NSString *) url DeviceToken:(NSString*) token{
      
    [self perform:[NSURL URLWithString:url] params:@{@"deviceToken":token,@"deviceType":@"ios"}  completion:nil];
}

-(void)requestSvStatusWithCompletion:(CompletioBlock)arg4{
    NSURL * r21 = [NSURL URLWithString:[self bsURL]];
    [self perform:r21 params:@{}  completion:arg4];

}
@end
