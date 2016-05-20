//
//  MatchNoHousingUsersRequest.m
//  MiYo
//
//  Created by 项小盆友 on 16/5/20.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "MatchNoHousingUsersRequest.h"

@implementation MatchNoHousingUsersRequest
-(void)request:(ParamsBlock)paramsBlock result:(RequestResultHandler)resultHandler {
    if (!paramsBlock(self)) {
        return;
    }
    NSString *userId = [[NSUserDefaults standardUserDefaults] stringForKey:USERID];
    NSDictionary *param = @{@"userid" : userId,
                            @"index" : @(_index),
                            @"sex" : @(_sex)};
    [[RequestManager shareInstance] POST:@"MatchingNoneHouseUserAPI.aspx" parameters:param success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
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
