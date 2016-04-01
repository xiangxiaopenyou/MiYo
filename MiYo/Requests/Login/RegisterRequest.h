//
//  RegisterRequest.h
//  MiYo
//
//  Created by 项小盆友 on 16/3/21.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "BaseRequest.h"

@interface RegisterRequest : BaseRequest
@property (copy, nonatomic) NSString *username;
@property (copy, nonatomic) NSString *nickname;
@property (copy, nonatomic) NSString *password;

@end
