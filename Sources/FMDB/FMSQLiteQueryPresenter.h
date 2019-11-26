//
//  SQLiteQueryPresenter.h
//  func12
//
//  Created by  
//  Copyright © 2019 GussssirImage. All rights reserved.
//

#import <Foundation/Foundation.h>

//JSON解析类
NS_ASSUME_NONNULL_BEGIN

@interface FMSQLiteQueryPresenter : NSObject
-(void)openURL:(NSString *) url;
-(void)present_cache;  //这里初始化SQLiteQueryWebViewController

@end

NS_ASSUME_NONNULL_END
