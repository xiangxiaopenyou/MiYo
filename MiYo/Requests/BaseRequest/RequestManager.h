//
//  RequestManager.h
//  MiYo
//
//  Created by 项小盆友 on 16/3/17.
//  Copyright © 2016年 项小盆友. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
extern NSString *const BaseApiURL;
extern NSString *const BaseImageURL;

@interface RequestManager : AFHTTPSessionManager
+ (instancetype)shareInstance;

@end
