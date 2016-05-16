//
//  FetchRecommendedHousingRequest.m
//  MiYo
//
//  Created by 项小盆友 on 16/4/29.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "FetchRecommendedHousingRequest.h"
#import "Util.h"

@implementation FetchRecommendedHousingRequest
- (void)request:(ParamsBlock)paramsBlock result:(RequestResultHandler)resultHandler {
    if (!paramsBlock(self)) {
        return;
    }
    NSMutableDictionary *param = [@{@"index" : @(_index),
                            @"count" : @(20)} mutableCopy];
    if (![Util isEmpty:_city]) {
        [param setObject:_city forKey:@"city"];
    }
    [[RequestManager shareInstance] POST:@"getHeadPage.aspx" parameters:param success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
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
