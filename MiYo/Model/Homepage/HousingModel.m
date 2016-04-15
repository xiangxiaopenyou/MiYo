//
//  HousingModel.m
//  MiYo
//
//  Created by 项小盆友 on 16/4/3.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "HousingModel.h"
#import "FetchHousingDetailRequest.h"

@implementation HousingModel
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

@end
