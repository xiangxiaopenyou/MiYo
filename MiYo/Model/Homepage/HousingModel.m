//
//  HousingModel.m
//  MiYo
//
//  Created by 项小盆友 on 16/4/3.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "HousingModel.h"
#import "FetchHousingDetailRequest.h"
#import "FetchRecommendedHousingRequest.h"
#import "IndexReulstModel.h"
#import "HousingDeleteRequest.h"
#import "SearchHousingRequest.h"
#import "SendHousingRequest.h"

@implementation HousingModel
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"description" : @"descirption"}];
}
+ (void)fetchHousingDetailWith:(NSString *)housingId handler:(RequestResultHandler)handler {
    [[FetchHousingDetailRequest new] request:^BOOL(FetchHousingDetailRequest *request) {
        request.housingId = housingId;
        return YES;
    } result:^(id object, NSString *msg) {
        if (msg) {
            !handler ?: handler(nil, msg);
        } else {
            HousingModel *model = [[HousingModel alloc] initWithDictionary:object error:nil];
            !handler ?: handler(model, nil);
        }
    }];
}
+ (void)fetchRecommendedHousingWith:(NSInteger)index city:(NSString *)city handler:(RequestResultHandler)handler {
    [[FetchRecommendedHousingRequest new] request:^BOOL(FetchRecommendedHousingRequest *request) {
        request.index = index;
        request.city = city;
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
+ (void)deleteHousingWith:(NSString *)housingId handler:(RequestResultHandler)handler {
    [[HousingDeleteRequest new] request:^BOOL(HousingDeleteRequest *request) {
        request.housingId = housingId;
        return YES;
    } result:^(id object, NSString *msg) {
        if (msg) {
            !handler ?: handler(nil, msg);
        } else {
            !handler ?: handler(object, nil);
        }
    }];
}
+ (void)searchHousingWith:(NSDictionary *)dictionary handler:(RequestResultHandler)handler {
    [[SearchHousingRequest new] request:^BOOL(SearchHousingRequest *request) {
        request.param = dictionary;
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
+ (void)sendHousingWith:(NSDictionary *)dictionary handler:(RequestResultHandler)handler {
    [[SendHousingRequest new] request:^BOOL(SendHousingRequest *request) {
        request.param = dictionary;
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
