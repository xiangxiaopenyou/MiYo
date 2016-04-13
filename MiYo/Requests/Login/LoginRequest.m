//
//  LoginRequest.m
//  MiYo
//
//  Created by 项小盆友 on 16/3/18.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "LoginRequest.h"

@implementation LoginRequest
- (void)request:(ParamsBlock)paramsBlock result:(RequestResultHandler)resultHandler {
    if (!paramsBlock(self)) {
        return;
    }
    NSDictionary *param = @{@"account" : _username, @"password" : _password};
    [[RequestManager shareInstance] POST:@"loginAPI.aspx" parameters:param success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"resultCode"] isEqual:@"0000"]) {
            !resultHandler ?: resultHandler(responseObject[@"data"], nil);
        } else {
            !resultHandler ?: resultHandler(nil, responseObject[@"resultMsg"]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        !resultHandler ?: resultHandler(nil, error.description);
    }];
    
}

@end
