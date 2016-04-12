//
//  LoginModel.m
//  MiYo
//
//  Created by 项小盆友 on 16/3/20.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "LoginModel.h"
#import "LoginRequest.h"
#import "RegisterRequest.h"

@implementation LoginModel

+ (void)loginWith:(NSString *)username password:(NSString *)password handler:(RequestResultHandler)handler {
    [[LoginRequest new] request:^BOOL(LoginRequest *request) {
        request.username = username;
        request.password = password;
        return YES;
    } result:^(id object, NSString *msg) {
        if (msg) {
            !handler ?: handler(nil, msg);
        } else {
            !handler ?: handler(object, nil);
        }
    }];
}
+ (void)registerWith:(NSString *)username nickname:(NSString *)nickname password:(NSString *)password handler:(RequestResultHandler)handler {
    [[RegisterRequest new] request:^BOOL(RegisterRequest *request) {
        request.username = username;
        request.password = password;
        request.nickname = nickname;
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
