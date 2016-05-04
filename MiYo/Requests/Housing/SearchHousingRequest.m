//
//  SearchHousingRequest.m
//  MiYo
//
//  Created by 项小盆友 on 16/5/2.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "SearchHousingRequest.h"

@implementation SearchHousingRequest
- (void)request:(ParamsBlock)paramsBlock result:(RequestResultHandler)resultHandler {
    if (!paramsBlock(self)) {
        return;
    }
    [[RequestManager shareInstance] POST:@"getHousesAPI.aspx" parameters:_param success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
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
