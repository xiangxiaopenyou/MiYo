//
//  FetchMessageListRequest.m
//  MiYo
//
//  Created by 项小盆友 on 16/4/18.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "FetchMessageListRequest.h"

@implementation FetchMessageListRequest
- (void)request:(ParamsBlock)paramsBlock result:(RequestResultHandler)resultHandler {
    if (!paramsBlock(self)) {
        return;
    }
    NSString *userId = [[NSUserDefaults standardUserDefaults] stringForKey:USERID];
    NSDictionary *param = @{@"userid" : userId,
                            @"index" : @(self.limit)};
    [[RequestManager shareInstance] POST:@"getMsgListAPI.Aspx" parameters:param success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
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
