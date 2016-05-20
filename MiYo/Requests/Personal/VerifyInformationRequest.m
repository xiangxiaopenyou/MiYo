//
//  VerifyInformationRequest.m
//  MiYo
//
//  Created by 项小盆友 on 16/5/20.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "VerifyInformationRequest.h"

@implementation VerifyInformationRequest
- (void)request:(ParamsBlock)paramsBlock result:(RequestResultHandler)resultHandler {
    if (!paramsBlock(self)) {
        return;
    }
    NSString *userId = [[NSUserDefaults standardUserDefaults] stringForKey:USERID];
    NSDictionary *param = @{@"userid" : userId};
    [[RequestManager shareInstance] POST:@"isCompleteInfoAPI.aspx" parameters:param success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        !resultHandler ?: resultHandler(responseObject[@"resultCode"], nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        !resultHandler ?: resultHandler(nil, error.description);
    }];
}

@end
