//
//  IndexReulstModel.m
//  MiYo
//
//  Created by 项小盆友 on 16/4/18.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "IndexReulstModel.h"
#import "BaseModel.h"

@implementation IndexReulstModel
- (instancetype)initWithResultDictionary:(NSDictionary *)dic modelKey:(NSString *)key modelClass:(BaseModel *)modelClass {
    self = [super init];
    if (self) {
        if ([dic[@"index"] integerValue] + 1 < [dic[@"count"] integerValue]) {
            _haveMore = YES;
        } else {
            _haveMore = NO;
        }
        _index = [dic[@"index"] integerValue];
        id result = dic[key];
        if ([result isKindOfClass:[NSArray class]]) {
            _result = [[modelClass class] setupWithArray:result];
        } else if ([result isKindOfClass:[NSDictionary class]]) {
            _result = [[[modelClass class] alloc] initWithDictionary:result error:nil];
        }
    }
    return self;
}

@end
