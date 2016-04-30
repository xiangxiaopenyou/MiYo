//
//  MessageModel.m
//  MiYo
//
//  Created by 项小盆友 on 16/4/18.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "MessageModel.h"
#import "FetchUnreadMessageQualityRequest.h"
#import "FetchMessageListRequest.h"
#import "IndexReulstModel.h"
#import "MessageDeleteRequest.h"

@implementation MessageModel
+ (void)fetchMessageListWith:(NSInteger)limit handler:(RequestResultHandler)handler {
    [[FetchMessageListRequest new] request:^BOOL(FetchMessageListRequest *request) {
        request.limit = limit;
        return YES;
    } result:^(id object, NSString *msg) {
        if (msg) {
            !handler ?: handler(nil, msg);
        } else {
            IndexReulstModel *tempModel = [[IndexReulstModel alloc] initWithResultDictionary:object modelKey:@"data" modelClass:[MessageModel new]];
            !handler ?: handler(tempModel, nil);
        }
    }];
}
+ (void)fetchUnreadQualityWith:(RequestResultHandler)handler {
    [[FetchUnreadMessageQualityRequest new] request:^BOOL(id request) {
        return YES;
    } result:^(id object, NSString *msg) {
        if (msg) {
            !handler ?: handler(nil, msg);
        } else {
            !handler ?: handler(object, nil);
        }
    }];
}
+ (void)deleteMessageWith:(NSString *)messageId handler:(RequestResultHandler)handler {
    [[MessageDeleteRequest new] request:^BOOL(MessageDeleteRequest *request) {
        request.messageId = messageId;
        return YES;
    } result:^(id object, NSString *msg) {
        if (msg) {
            !handler ?: handler(nil, msg);
        } else {
            !handler ?: handler(object, nil);
        }
    }];
}

@end
