//
//  IndexReulstModel.h
//  MiYo
//
//  Created by 项小盆友 on 16/4/18.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BaseModel;
@interface IndexReulstModel : NSObject
@property (strong, nonatomic) id result;
@property (assign, nonatomic) BOOL haveMore;
@property (assign, nonatomic) NSInteger index;

- (instancetype)initWithResultDictionary:(NSDictionary *)dic modelKey:(NSString *)key modelClass:(BaseModel *)modelClass;

@end
