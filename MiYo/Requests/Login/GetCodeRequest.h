//
//  GetCodeRequest.h
//  MiYo
//
//  Created by 项小盆友 on 16/3/21.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "BaseRequest.h"

@interface GetCodeRequest : BaseRequest
@property (copy, nonatomic) NSString *phoneNumber;

@end
