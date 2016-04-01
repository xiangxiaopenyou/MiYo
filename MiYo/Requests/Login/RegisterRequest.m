//
//  RegisterRequest.m
//  MiYo
//
//  Created by 项小盆友 on 16/3/21.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "RegisterRequest.h"

@implementation RegisterRequest
- (void)request:(ParamsBlock)paramsBlock result:(RequestResultHandler)resultHandler {
    if (!paramsBlock(self)) {
        return;
    }
    NSDictionary *param = @{@"account" : _username,
                            @"nickname" : _nickname,
                            @"password" : _password};
    [[RequestManager shareInstance] POST:@"registerAPI.aspx" parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"resultCode"] isEqual:@"0000"]) {
            !resultHandler ?: resultHandler(responseObject[@"resultMsg"], nil);
        } else {
            !resultHandler ?: resultHandler(nil, responseObject[@"resultMsg"]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        !resultHandler ?: resultHandler(nil, error.description);
    }];
}

@end
