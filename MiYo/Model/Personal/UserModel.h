//
//  UserModel.h
//  MiYo
//
//  Created by 项小盆友 on 16/5/3.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "BaseModel.h"

@interface UserModel : BaseModel
@property (copy, nonatomic) NSString<Optional> *id;
@property (copy, nonatomic) NSString *nickname;
@property (strong, nonatomic) NSNumber *sex;
@property (copy, nonatomic) NSString<Optional> *headphoto;
@property (copy, nonatomic) NSString<Optional> *hopeaddress;
@property (copy, nonatomic) NSString<Optional> *address_x;
@property (copy, nonatomic) NSString<Optional> *address_y;
@property (strong, nonatomic) NSNumber<Optional> *hopepricemin;
@property (strong, nonatomic) NSNumber<Optional> *hopepricemax;
@property (strong, nonatomic) NSNumber<Optional> *isallowsharehouse;
@property (strong, nonatomic) NSNumber<Optional> *hoperenovation;
@property (strong, nonatomic) NSNumber<Optional> *hopetip;
@property (copy, nonatomic) NSString<Optional> *weight;
@property (copy, nonatomic) NSString<Optional> *name;
@property (copy, nonatomic) NSString<Optional> *phone;
@property (copy, nonatomic) NSString<Optional> *qq;
@property (copy, nonatomic) NSString<Optional> *weichat;
@property (strong, nonatomic) NSNumber<Optional> *age;
@property (copy, nonatomic) NSString<Optional> *address;
@property (copy, nonatomic) NSString<Optional> *job;

+ (void)fetchUserIDCardWith:(NSString *)userId handler:(RequestResultHandler)handler;
+ (void)matchUsersWith:(NSString *)houseId sex:(NSInteger)sex index:(NSInteger)index handler:(RequestResultHandler)handler;


@end
