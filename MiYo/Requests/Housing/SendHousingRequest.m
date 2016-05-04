//
//  SendHousingRequest.m
//  MiYo
//
//  Created by 项小盆友 on 16/5/3.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "SendHousingRequest.h"

@implementation SendHousingRequest
- (void)request:(ParamsBlock)paramsBlock result:(RequestResultHandler)resultHandler {
    if (!paramsBlock(self)) {
        return;
    }
    [[RequestManager shareInstance] POST:@"releaseHouseAPI.aspx" parameters:_param success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        if ([responseObject[@"resultCode"] isEqual:@"0000"]) {
            !resultHandler ?: resultHandler(@"success", nil);
        } else {
            !resultHandler ?: resultHandler(nil, responseObject[@"resultMsg"]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        !resultHandler ?: resultHandler(nil, error.description);
    }];
}

@end
