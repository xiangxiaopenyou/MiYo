//
//  GetCodeRequest.m
//  MiYo
//
//  Created by 项小盆友 on 16/3/21.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "GetCodeRequest.h"

@implementation GetCodeRequest
- (void)request:(ParamsBlock)paramsBlock result:(RequestResultHandler)resultHandler {
    if (!paramsBlock(self)) {
        return;
    }
    NSDictionary *param = @{@"phone" : _phoneNumber};
    [[RequestManager shareInstance] POST:@"sendVCodeAPI.aspx" parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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
