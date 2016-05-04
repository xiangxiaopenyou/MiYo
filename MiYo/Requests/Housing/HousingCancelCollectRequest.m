//
//  HousingCancelCollectRequest.m
//  MiYo
//
//  Created by 项小盆友 on 16/4/30.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "HousingCancelCollectRequest.h"

@implementation HousingCancelCollectRequest
- (void)request:(ParamsBlock)paramsBlock result:(RequestResultHandler)resultHandler{
    if (!paramsBlock(self)) {
        return;
    }
    NSString *userId = [[NSUserDefaults standardUserDefaults] stringForKey:USERID];
    NSDictionary *param = @{@"houseid" : _houseingId,
                            @"userid" : userId};
    [[RequestManager shareInstance] POST:@"deleteCollectAPI.aspx" parameters:param success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
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
