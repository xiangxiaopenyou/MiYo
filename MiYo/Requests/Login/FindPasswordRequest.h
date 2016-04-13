//
//  FindPasswordRequest.h
//  MiYo
//
//  Created by 项小盆友 on 16/4/13.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "BaseRequest.h"

@interface FindPasswordRequest : BaseRequest
@property (copy, nonatomic) NSString *account;
@property (copy, nonatomic) NSString *password;

@end
