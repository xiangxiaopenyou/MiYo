//
//  FetchUserInformationRequest.m
//  MiYo
//
//  Created by 项小盆友 on 16/4/12.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "FetchUserInformationRequest.h"

@implementation FetchUserInformationRequest
- (void)request:(ParamsBlock)paramsBlock result:(RequestResultHandler)resultHandler {
    if (!paramsBlock(self)) {
        return;
    }
    NSDictionary *param = @{@"userid" : _userId};
    [[RequestManager shareInstance] POST:@"getUserInfo.aspx" parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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
