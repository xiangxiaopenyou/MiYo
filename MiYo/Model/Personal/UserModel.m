//
//  UserModel.m
//  MiYo
//
//  Created by 项小盆友 on 16/5/3.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "UserModel.h"
#import "MatchRequest.h"
#import "IndexReulstModel.h"
#import "FetchUserCardRequest.h"

@implementation UserModel

+ (void)matchUsersWith:(NSString *)houseId sex:(NSInteger)sex index:(NSInteger)index handler:(RequestResultHandler)handler {
    [[MatchRequest new] request:^BOOL(MatchRequest *request) {
        request.houseId = houseId;
        request.sex = sex;
        request.index = index;
        return YES;
    } result:^(id object, NSString *msg) {
        if (msg) {
            !handler ?: handler(nil, msg);
        } else {
            IndexReulstModel *tempModel = [[IndexReulstModel alloc] initWithResultDictionary:object modelKey:@"data" modelClass:[UserModel new]];
            !handler ?: handler(tempModel, nil);
        }
    }];
}
+ (void)fetchUserIDCardWith:(NSString *)userId handler:(RequestResultHandler)handler {
    [[FetchUserCardRequest new] request:^BOOL(FetchUserCardRequest *request) {
        request.userId = userId;
        return YES;
    } result:^(id object, NSString *msg) {
        if (msg) {
            !handler ?: handler(nil, msg);
        } else {
            UserModel *tempModel = [[UserModel alloc] initWithDictionary:object error:nil];
            !handler ?: handler(tempModel, nil);
        }
    }];
}

@end
