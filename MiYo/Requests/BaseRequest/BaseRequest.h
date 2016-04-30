//
//  BaseRequest.h
//  MiYo
//
//  Created by 项小盆友 on 16/3/17.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RequestManager.h"
#import "CommonsDefines.h"

typedef BOOL(^ParamsBlock)(id request);
typedef void(^RequestResultHandler)(id object, NSString *msg);
@protocol RequestProtocol <NSObject>
@required
- (void)request:(ParamsBlock)paramsBlock result:(RequestResultHandler)resultHandler;

@end

@interface BaseRequest : NSObject <RequestProtocol>
- (void)cacheRequest:(NSString *)request method:(NSString *)method param:(NSDictionary *)param;
- (NSString *)handlerError:(NSError *)error;

@end
