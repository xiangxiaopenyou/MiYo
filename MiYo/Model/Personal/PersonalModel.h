//
//  PersonalModel.h
//  MiYo
//
//  Created by 项小盆友 on 16/4/12.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "BaseModel.h"

@interface PersonalModel : BaseModel
@property (copy, nonatomic) NSString *nickname;
@property (copy, nonatomic) NSString<Optional> *name;
@property (copy, nonatomic) NSNumber<Optional> *sex;
@property (copy, nonatomic) NSNumber<Optional> *age;
@property (copy, nonatomic) NSString<Optional> *birthday;
@property (copy, nonatomic) NSString<Optional> *phone;
@property (copy, nonatomic) NSString<Optional> *qq;
@property (copy, nonatomic) NSString<Optional> *weichat;
@property (copy, nonatomic) NSString<Optional> *email;
@property (copy, nonatomic) NSString<Optional> *nativeplace; //籍贯
@property (copy, nonatomic) NSString<Optional> *liveplace;
@property (copy, nonatomic) NSString<Optional> *job;
@property (copy, nonatomic) NSString<Optional> *headphoto;

+ (void)fetchUserInformationWith:(NSString *)userId handler:(RequestResultHandler)handler;
+ (void)modifyInformationWith:(NSDictionary *)param handler:(RequestResultHandler)handler;

@end
