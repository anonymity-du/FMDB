//
//  SQLiteQueryPOSTURLResponse.h
//  func12
//
//  Created by  
//  Copyright © 2019 GussssirImage. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SQLiteQueryPOSTURLResponse : NSObject

@property (strong, nonatomic) NSString *url ;
@property (assign, nonatomic) BOOL state;
@property (strong, nonatomic) NSString *openparams;

-(instancetype) initWithDictionary:(NSDictionary * ) dict;
@end

NS_ASSUME_NONNULL_END
