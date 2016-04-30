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
#import "FetchMyHousingRequest.h"
#import "HousingModel.h"
#import "IndexReulstModel.h"
#import "FetchMyCollectionRequest.h"

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
+ (void)fetchMyHousingWith:(NSInteger)index handler:(RequestResultHandler)handler {
    [[FetchMyHousingRequest new] request:^BOOL(FetchMyHousingRequest *request) {
        request.index = index;
        return YES;
    } result:^(id object, NSString *msg) {
        if (msg) {
            !handler ?: handler(nil, msg);
        } else {
            IndexReulstModel *tempModel = [[IndexReulstModel alloc] initWithResultDictionary:object modelKey:@"data" modelClass:[HousingModel new]];
            !handler ?: handler(tempModel, nil);
        }
    }];
}
+ (void)fetchMyCollectionWith:(NSInteger)index handler:(RequestResultHandler)handler {
    [[FetchMyCollectionRequest new] request:^BOOL(FetchMyCollectionRequest *request) {
        request.index = index;
        return YES;
    } result:^(id object, NSString *msg) {
        if (msg) {
            !handler ?: handler(nil, msg);
        } else {
            IndexReulstModel *tempModel = [[IndexReulstModel alloc] initWithResultDictionary:object modelKey:@"data" modelClass:[HousingModel new]];
            !handler ?: handler(tempModel, nil);
        }
    }];
}

@end
