//
//  PersonalModel.m
//  MiYo
//
//  Created by 项小盆友 on 16/4/12.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "PersonalModel.h"
#import "FetchUserInformationRequest.h"

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

@end
