//
//  HousingModel.h
//  MiYo
//
//  Created by 项小盆友 on 16/4/3.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "BaseModel.h"

@interface HousingModel : BaseModel
@property (copy, nonatomic) NSString *id;
@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *descirption;
@property (copy, nonatomic) NSString<Optional> *address;
@property (copy, nonatomic) NSString<Optional> *position;
@property (strong, nonatomic) NSNumber *size;
@property (copy, nonatomic) NSString *specification;
@property (strong, nonatomic) NSNumber *price;
@property (strong, nonatomic) NSNumber *pricetype;
@property (strong, nonatomic) NSNumber *renovation;
@property (copy, nonatomic) NSString *time;
@property (strong, nonatomic) NSNumber *clickcount;
@property (copy, nonatomic) NSString *image;
@property (strong, nonatomic) NSNumber *wifi;
@property (strong, nonatomic) NSNumber *heater;
@property (strong, nonatomic) NSNumber *television;
@property (strong, nonatomic) NSNumber *airconditioner;  //空调
@property (strong, nonatomic) NSNumber *refrigerator; //冰箱
@property (strong, nonatomic) NSNumber *washingmachine; //洗衣机
@property (strong, nonatomic) NSNumber *elevator;      //电梯
@property (strong, nonatomic) NSNumber *accesscontrol; //门禁
@property (strong, nonatomic) NSNumber *parkingspace;  //停车位
@property (strong, nonatomic) NSNumber *smoking;
@property (strong, nonatomic) NSNumber *bathtub; //浴缸
@property (strong, nonatomic) NSNumber *keepingpets; //宠物
@property (strong, nonatomic) NSNumber *paty;       //聚会

+ (void)fetchHousingDetailWith:(NSString *)housingId handler:(RequestResultHandler)handler;

@end
