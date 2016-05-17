//
//  RequestManager.m
//  MiYo
//
//  Created by 项小盆友 on 16/3/17.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "RequestManager.h"
#import <AFURLResponseSerialization.h>
//NSString *const BaseApiURL = @"http://120.26.233.80/API/";
NSString *const BaseApiURL = @"http://120.26.233.80:8088/API";
//NSString *const BaseImageURL = @"http://7xsnrf.com1.z0.glb.clouddn.com/";
NSString *const BaseImageURL = @"http://o79izl3a1.bkt.clouddn.com/";

@implementation RequestManager
+ (instancetype)shareInstance {
    static RequestManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[RequestManager alloc] initWithBaseURL:[NSURL URLWithString:BaseApiURL]];
        AFJSONResponseSerializer *serializer = [AFJSONResponseSerializer serializer];
        NSMutableSet *types = [[serializer acceptableContentTypes] mutableCopy];
        [types addObjectsFromArray:@[@"text/plain", @"text/html"]];
        serializer.acceptableContentTypes = types;
        instance.responseSerializer = serializer;
        [NSURLSessionConfiguration defaultSessionConfiguration].HTTPMaximumConnectionsPerHost = 1;
    });
    return instance;
}

@end
