//
//  FeedbackRequest.h
//  MiYo
//
//  Created by 项小盆友 on 16/4/30.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "BaseRequest.h"

@interface FeedbackRequest : BaseRequest
@property (copy, nonatomic) NSString *content;
@property (copy, nonatomic) NSString *mobile;

@end
