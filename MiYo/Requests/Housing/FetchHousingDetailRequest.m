//
//  FetchHousingDetailRequest.m
//  MiYo
//
//  Created by 项小盆友 on 16/4/15.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "FetchHousingDetailRequest.h"

@implementation FetchHousingDetailRequest
- (void)request:(ParamsBlock)paramsBlock result:(RequestResultHandler)resultHandler {
    if (!paramsBlock(self)) {
        return;
    }
    NSDictionary *param = @{@"houseid" : self.housingId};
    [[RequestManager shareInstance] POST:@"getHouseInfoAPI.aspx" parameters:param success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
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
