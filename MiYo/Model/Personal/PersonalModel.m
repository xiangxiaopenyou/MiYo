//
//  PersonalModel.m
//  MiYo
//
//  Created by 项小盆友 on 16/4/12.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "PersonalModel.h"
#import "FetchUserInformationRequest.h"
#import "ModifyInformationRequest.h"

@implementation PersonalModel
+ (void)fetchUserInformationWith:(NSString *)userId handler:(RequestResultHandler)handler {
    [[FetchUserInformationRequest new] request:^BOOL(FetchUserInformationRequest *request) {
        request.userId = userId;
        return YES;
    } result:^(id object, NSString *msg) {
        if (msg) {
            !handler ?: handler(nil, msg);
        } else {
            PersonalModel *model = [[PersonalModel alloc] initWithDictionary:object error:nil];
            !handler ?: handler(model, nil);
        }
    }];
}
+ (void)modifyInformationWith:(NSDictionary *)param handler:(RequestResultHandler)handler {
    [[ModifyInformationRequest new] request:^BOOL(ModifyInformationRequest *request) {
        request.param = param;
        return YES;
    } result:^(id object, NSString *msg) {
        if (msg) {
            !handler ?: handler(object, nil);
        } else {
            !handler ?: handler(nil, msg);
        }
    }];
}

@end
