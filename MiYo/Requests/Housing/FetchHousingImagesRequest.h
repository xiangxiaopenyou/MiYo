//
//  FetchHousingImagesRequest.h
//  MiYo
//
//  Created by 项小盆友 on 16/4/29.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "BaseRequest.h"

@interface FetchHousingImagesRequest : BaseRequest
@property (copy, nonatomic) NSString *houseId;
@end
