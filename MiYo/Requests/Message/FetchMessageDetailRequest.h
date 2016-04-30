//
//  FetchMessageDetailRequest.h
//  MiYo
//
//  Created by 项小盆友 on 16/4/25.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "BaseRequest.h"

@interface FetchMessageDetailRequest : BaseRequest
@property (copy, nonatomic) NSString *messageId;

@end
