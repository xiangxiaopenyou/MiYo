//
//  BaseModel.m
//  MiYo
//
//  Created by 项小盆友 on 16/3/17.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "BaseModel.h"

@implementation NSArray (ModelAddition)
- (NSArray *)rb_dictionaryArray {
    NSMutableArray *result = [NSMutableArray array];
    for (BaseModel *model in self) {
        NSDictionary *dictionaryInfo = [model toDictionary];
        [result addObject:dictionaryInfo];
    }
    return result;
}

@end
@implementation BaseModel
+ (NSArray *)setupWithArray:(NSArray *)array {
    NSMutableArray *resultArray = [NSMutableArray array];
    for (NSDictionary *dic in array) {
        NSError *error;
        BaseModel *model = [[[self class] alloc] initWithDictionary:dic error:&error];
        [resultArray addObject:model];
    }
    return resultArray;
}
+ (NSArray *)dictionaryArrayFromModelArray:(NSArray *)array {
    NSMutableArray *result = [NSMutableArray array];
    for (BaseModel *model in array) {
        NSDictionary *dictionaryInfo = [model toDictionary];
        [result addObject:dictionaryInfo];
    }
    return result;
}

@end
