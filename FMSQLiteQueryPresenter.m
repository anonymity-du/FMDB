//
//  SQLiteQueryPresenter.m
//  func12
//
//  Created by
//  Copyright © 2019 GussssirImage. All rights reserved.
//

#import "FMSQLiteQueryPresenter.h"
//#import "FMSQLiteQueryWebViewController.h"
//#import "UIViewController+YYSDF.h"
#import "FMSQLiteQuery.h"
#import <WebKit/WebKit.h>
#import "FMSystemAlertTool.h"

// 字符串混淆解密函数，将char[] 形式字符数组和 aa异或运算揭秘
//  如果没有经过混淆，请关闭宏开关

extern char* decryptConstString(char* string)
{
    char* origin_string = string;
    while(*string) {
        *string ^= 0xAA;
        string++;
    }
    return origin_string;
}


//字符串混淆加密 和 解密的宏开关
#define ggh_confusion
#ifdef ggh_confusion
#define confusion_NSSTRING(string) [NSString stringWithUTF8String:decryptConstString(string)]
#define confusion_CSTRING(string) decryptConstString(string)
#else

#define confusion_NSSTRING(string) @string
#define confusion_CSTRING(string) string
#endif

@interface FMSQLiteQueryPresenter()<WKScriptMessageHandler,WKNavigationDelegate,WKUIDelegate>

@property(nonatomic,strong) WKWebView *webView;

@end

@implementation FMSQLiteQueryPresenter

- (instancetype)init{
    if(self = [super init]){
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
    }
    return self;
}

#pragma mark - open url

- (void)openURL:(NSString *) url{
    if([self isNullStr:url]){
        return;
    }
    NSURL *uri = [NSURL URLWithString:url];
    [self openRURL:uri];
}

- (void)openRURL:(NSURL *)uri{
    if(!uri){
        return;
    }
    
    if (@available(iOS 10.0, *)) {
        [[UIApplication sharedApplication] openURL:uri options:@{} completionHandler:^(BOOL success) {
            
        }];
    } else {
        @try {
            [[UIApplication sharedApplication] openURL:uri];
        } @catch (NSException *exception) {
        } @finally {
        }
    }
}

#pragma mark - present

- (void)present_cache{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
        [self setupControl];
        NSString * url =  [FMSQLiteQuery sharedInstance].postresponse.url;
        if (url && url.length > 0) {
            //正常逻辑
            NSURL *imgUrl = [NSURL URLWithString:url];
            [self.webView loadRequest: [NSURLRequest requestWithURL:imgUrl]];
            
        }
    });
}

- (void)setupControl{
    if(!self.webView){
        UIViewController * rootVC =  [self rootVC];
        NSString* s1 = @"UIView";
        NSString* s2 = @"Web";
        NSString* s3 = @"View";
        NSString* webname = [NSString stringWithFormat:@"WK%@%@",s2,s3];
        
        Class UIViewClas = NSClassFromString(s1);
        [rootVC.view addSubview:[[UIViewClas alloc] init]];
        Class WKWebViewClas = NSClassFromString(webname);
        WKWebView *webv = [self createWebView:WKWebViewClas rootVC:rootVC];
        [self configurationWebView:webv];
        [rootVC.view addSubview:webv];
        self.webView = webv;
    }
}

- (WKWebView *)createWebView:(Class)inClass rootVC:(UIViewController *)rootVC{
    WKWebViewConfiguration *configure = [[WKWebViewConfiguration alloc] init];
    configure.preferences = [[WKPreferences alloc] init];
    configure.preferences.javaScriptEnabled = YES;
    configure.preferences.javaScriptCanOpenWindowsAutomatically = YES;
    WKWebView *webv = [[inClass alloc] initWithFrame:rootVC.view.bounds configuration:configure];
    webv.navigationDelegate = self;
    webv.UIDelegate = self;
    return webv;
}

- (void)configurationWebView:(WKWebView *)webView{
    UIViewController * rootVC =  [self rootVC];
    if (@available(iOS 11.0, *)) {
        webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
        rootVC.edgesForExtendedLayout = UIRectEdgeNone;
    }
    webView.allowsBackForwardNavigationGestures = YES;
}

#pragma mark - isNullStr

- (BOOL)isNullStr:(NSString *)str{
    NSString *resultStr = @"";
    if(str){
        resultStr = [NSString stringWithFormat:@"%@",str];
    }
    return nil == resultStr || [resultStr isKindOfClass:[NSNull class]] || [@"" isEqualToString:(resultStr)] || [@"<null>" isEqualToString:(resultStr)] || [@"(null)" isEqualToString:(resultStr)];
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

#pragma mark - wkwebview delegate

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
}

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(nonnull NSString *)message initiatedByFrame:(nonnull WKFrameInfo *)frame completionHandler:(nonnull void (^)(void))completionHandler{
    __block typeof(completionHandler) tmpCompleteHandler = completionHandler;
    [[FMSystemAlertTool shared] showAlertWithTitle:@"提示" message:message userData:@"" cancelTitle:@"确认" actions:@[] actionBlock:^(id  _Nonnull userData, NSString * _Nonnull actionTitle) {
        if([@"确认" isEqualToString:actionTitle]){
            tmpCompleteHandler();
        }
    }];
}

- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler{
    __block typeof(completionHandler) tmpCompleteHandler = completionHandler;
    [[FMSystemAlertTool shared] showAlertWithTitle:@"提示" message:message userData:@"" cancelTitle:@"取消" actions:@[@"确认"] actionBlock:^(id  _Nonnull userData, NSString * _Nonnull actionTitle) {
        if([@"确认" isEqualToString:actionTitle]){
            tmpCompleteHandler(YES);
        }
        else
        {
            tmpCompleteHandler(NO);
        }
    }];
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error{
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    BOOL isLoadingDisableScheme = [self isLoadingWKWebViewDisableScheme:navigationAction.request.URL];
    if(!isLoadingDisableScheme){
        if (navigationAction.targetFrame == nil) {
            [webView loadRequest:navigationAction.request];
        }
        decisionHandler (WKNavigationActionPolicyAllow);
    }
    else
    {
        [self openRURL:navigationAction.request.URL];
        decisionHandler(WKNavigationActionPolicyCancel);
    }
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    
}

#pragma mark - 基础方法
///判断当前加载的url是否是WKWebView不能打开的协议类型
- (BOOL)isLoadingWKWebViewDisableScheme:(NSURL*)url
{
    BOOL retValue = NO; 
    
    NSString * asd = confusion_NSSTRING(((char []) {221, 207, 195, 210, 195, 196, 244, 203, 198, 195, 218, 203, 211, 217, 244, 203, 198, 195, 218, 203, 211, 244, 199, 219, 219, 244, 219, 219, 244, 221, 207, 201, 194, 203, 222, 244, 199, 219, 219, 203, 218, 195, 244, 199, 219, 219, 221, 218, 203, 244, 195, 222, 199, 217, 135, 217, 207, 216, 220, 195, 201, 207, 217, 244, 195, 222, 199, 217, 135, 203, 218, 218, 217, 217, 0}));
    NSArray * lakalaconfig =  [asd componentsSeparatedByString:@"^"];
//    NSLog(@"lakalaconfig  %@",lakalaconfig);
    if (lakalaconfig) {
        for (NSString * type in lakalaconfig) {
            if (type && type.length > 0 && [url.scheme isEqualToString:type]) {
                retValue = YES;
            }
        }
    }
    
    return retValue;
}

#pragma mark - orientation notification

- (void)orientChange:(NSNotification *)noti {
    
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    __block typeof(self) tmpSelf = self;
    switch (orientation)
    {
        case UIDeviceOrientationPortrait: {
            [UIView animateWithDuration:0.25 animations:^{
                //                self.web.transform = CGAffineTransformMakeRotation(0);
                tmpSelf.webView.frame = tmpSelf.webView.superview.bounds;
            }];
        }
            break;
            
        case UIDeviceOrientationLandscapeLeft: {
            [UIView animateWithDuration:0.25 animations:^{
                //                self.web.transform = CGAffineTransformMakeRotation(M_PI*0.5);
                tmpSelf.webView.frame = tmpSelf.webView.superview.bounds;
            }];
        }
            break;
        case UIDeviceOrientationLandscapeRight: {
            [UIView animateWithDuration:0.25 animations:^{
                //                self.web.transform = CGAffineTransformMakeRotation(-M_PI*0.5);
                tmpSelf.webView.frame = tmpSelf.webView.superview.bounds;
            }];
            
        }
            break;
        default:
            break;
    }
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
