//
//  FMDReachabilityTool.m
//  FMDB
//
//  Created by  on 2019/11/12.
//  Copyright © 2019 . All rights reserved.
//

#import "FMDReachabilityTool.h"
#import "TKOISHDFJKNLReachability.h"


@interface FMDReachabilityTool()

@property (nonatomic,strong) TKOISHDFJKNLReachability *hostReachability;
@property (nonatomic,copy) void(^netWorkGetBlockHandler)(void);

@end

@implementation FMDReachabilityTool

- (instancetype)init{
    if(self = [super init]){
        [self initializedReachability];
    }
    return self;
}

#pragma mark - check network status

- (void)initializedReachability{
    if(!self.hostReachability){
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotificationTKING object:nil];
        NSString *remoteHostName = @"www.apple.com";
        self.hostReachability = [TKOISHDFJKNLReachability reachabilityWithHostName:remoteHostName];
        [self.hostReachability startNotifier];
    }
}

- (void)reachabilityChanged:(NSNotification *)changes{
    if(changes &&
       changes.object &&
       [changes.object isKindOfClass:[TKOISHDFJKNLReachability class]]){
        [self updateInterfaceWithReachability:(TKOISHDFJKNLReachability *)changes.object];
    }
}

- (void)updateInterfaceWithReachability:(TKOISHDFJKNLReachability *)reachability{
    if(reachability == self.hostReachability){
        [self configureReachability:reachability];
    }
}

- (void)configureReachability:(TKOISHDFJKNLReachability *)reachability{
    NetworkStatus netStatus = reachability.currentReachabilityStatus;
    BOOL connectionRequired = [reachability connectionRequired];
    NSString *statusString = @"";
    NSInteger status = 0;
    switch (netStatus) {
        case NotReachable:
        {
            status = 0;
            statusString = NSLocalizedString(@"Access Not Available", @"Text field text for access is not available");
            connectionRequired = NO;
            break;
        }
        case ReachableViaWWAN:
        {
            status = 1;
            statusString = NSLocalizedString(@"Reachable WWAN", @"");
            break;
        }
        case ReachableViaWiFi:
        {
            status = 2;
            statusString = NSLocalizedString(@"Reachable WiFi", @"");
            break;
        }
        default:
            break;
    }
    
    if(connectionRequired){
        NSString *connectionRequiredFormatString = NSLocalizedString(@"Connection Required",@"Concatenation of status string with connection requirement");
        statusString = [NSString stringWithFormat:@"%@%@",statusString,connectionRequiredFormatString];
    }
    
    if(status == 0){
        
    }
    else
    {
        [self timeZoneCheckResult];
    }
}

- (void)timeZoneCheckResult{
    NSTimeZone *local = [NSTimeZone localTimeZone];
    if(local && [[local name] containsString:@"Asia"] && _netWorkGetBlockHandler){

        _netWorkGetBlockHandler();
        //warining:this code just for run block handler one time
        _netWorkGetBlockHandler = nil;
//        __block typeof(_netWorkGetBlockHandler) tmpBlockHandler = _netWorkGetBlockHandler;
//        [RUSSNetDianWork GetAction:^(NSString * _Nullable object) {
//            if(object &&
//               [object isKindOfClass:[NSString class]] &&
//               object.length > 0 &&
//               tmpBlockHandler){
//                tmpBlockHandler();
//                //warining:this code just for run block handler one time
//                tmpBlockHandler = nil;
//            }
//        }];
    }
}

#pragma mark - public

- (void)startCheckWithNetWorkGetBlockHandler:(void(^)(void))blockHandler{
    self.netWorkGetBlockHandler = blockHandler;
    [self initializedReachability];
    [self configureReachability:self.hostReachability];
}

+ (instancetype)tool{
    static FMDReachabilityTool *tool = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tool = [[FMDReachabilityTool alloc] init];
    });
    return tool;
}


@end
