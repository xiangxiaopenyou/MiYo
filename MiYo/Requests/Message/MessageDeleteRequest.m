//
//  MessageDeleteRequest.m
//  MiYo
//
//  Created by 项小盆友 on 16/4/25.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "MessageDeleteRequest.h"

@implementation MessageDeleteRequest
- (void)request:(ParamsBlock)paramsBlock result:(RequestResultHandler)resultHandler {
    if (!(paramsBlock(self))) {
        return;
    }
    NSDictionary *param = @{@"msgid" : _messageId};
    [[RequestManager shareInstance] POST:@"deleteMsg.aspx" parameters:param success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
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
