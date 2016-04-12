//
//  LoginModel.h
//  MiYo
//
//  Created by 项小盆友 on 16/3/20.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "BaseModel.h"

@interface LoginModel : BaseModel
+ (void)loginWith:(NSString *)username password:(NSString *)password handler:(RequestResultHandler)handler;
+ (void)registerWith:(NSString *)username nickname:(NSString *)nickname password:(NSString *)password handler:(RequestResultHandler)handler;

@end
