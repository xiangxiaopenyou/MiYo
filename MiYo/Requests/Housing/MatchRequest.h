//
//  MatchRequest.h
//  MiYo
//
//  Created by 项小盆友 on 16/5/3.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "BaseRequest.h"

@interface MatchRequest : BaseRequest
@property (copy, nonatomic) NSString *houseId;
@property (assign, nonatomic) NSInteger sex;
@property (assign, nonatomic) NSInteger index;

@end
