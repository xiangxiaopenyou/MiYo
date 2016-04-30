//
//  PersonalModel.h
//  MiYo
//
//  Created by 项小盆友 on 16/4/12.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "BaseModel.h"

@interface PersonalModel : BaseModel
@property (copy, nonatomic) NSString *id;
@property (copy, nonatomic) NSString *account;
@property (copy, nonatomic) NSString *nickname;
@property (copy, nonatomic) NSString *name;
@property (strong, nonatomic) NSNumber *sex;
@property (strong, nonatomic) NSNumber *age;
@property (copy, nonatomic) NSString *birthday;
@property (copy, nonatomic) NSString<Optional> *phone;
@property (copy, nonatomic) NSString *qq;
@property (copy, nonatomic) NSString *weichat;
@property (copy, nonatomic) NSString<Optional> *email;
@property (copy, nonatomic) NSString *nativeplace; //籍贯
@property (copy, nonatomic) NSString *liveplace;
@property (copy, nonatomic) NSString *job;
@property (copy, nonatomic) NSString<Optional> *headphoto;
@property (copy, nonatomic) NSString<Optional> *weight;
@property (copy, nonatomic) NSString<Optional> *time;
@property (copy, nonatomic) NSString *address_x;
@property (copy, nonatomic) NSString *address_y;
@property (copy, nonatomic) NSString<Optional> *hopeaddress;
@property (copy, nonatomic) NSString *hoppricemax;
@property (copy, nonatomic) NSString *hopepricemin;
@property (strong, nonatomic) NSNumber *hoperenovation;
@property (strong, nonatomic) NSNumber *isallowsharehouse;
@property (strong, nonatomic) NSNumber *wifi;
@property (strong, nonatomic) NSNumber *washingmachine;
@property (strong, nonatomic) NSNumber *heater;
@property (strong, nonatomic) NSNumber *heating;
@property (strong, nonatomic) NSNumber *television;
@property (strong, nonatomic) NSNumber *airconditioner;
@property (strong, nonatomic) NSNumber *refrigerator;
@property (strong, nonatomic) NSNumber *elevator;
@property (strong, nonatomic) NSNumber *parkingspace;
@property (strong, nonatomic) NSNumber *smoking;
@property (strong, nonatomic) NSNumber *bathtub;
@property (strong, nonatomic) NSNumber *keepingpets;
@property (strong, nonatomic) NSNumber *paty;
@property (strong, nonatomic) NSNumber *accesscontrol;

+ (void)fetchUserInformationWith:(NSString *)userId handler:(RequestResultHandler)handler;
+ (void)modifyInformationWith:(NSDictionary *)param handler:(RequestResultHandler)handler;
+ (void)fetchMyHousingWith:(NSInteger)index handler:(RequestResultHandler)handler;
+ (void)fetchMyCollectionWith:(NSInteger)index handler:(RequestResultHandler)handler;

@end
