//
//  UploadImageRequest.h
//  MiYo
//
//  Created by 项小盆友 on 16/4/13.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "BaseRequest.h"

@interface UploadImageRequest : BaseRequest
@property (copy, nonatomic) NSArray *images;
@property (copy, nonatomic) NSArray *keys;

@end
