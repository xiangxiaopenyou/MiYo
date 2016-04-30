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
@property (copy, nonatomic) NSString *userid;
@property (copy, nonatomic) NSString<Optional> *headphoto;
@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString<Optional> *descirption;
@property (copy, nonatomic) NSString<Optional> *address;
@property (copy, nonatomic) NSString<Optional> *addressname;
@property (copy, nonatomic) NSString *address_x;
@property (copy, nonatomic) NSString *address_y;
@property (strong, nonatomic) NSNumber<Optional> *headindex;
@property (strong, nonatomic) NSNumber *isflatshare;
@property (strong, nonatomic) NSNumber<Optional> *orientation;
@property (strong, nonatomic) NSNumber<Optional> *size;
@property (strong, nonatomic) NSNumber *specification;
@property (copy, nonatomic) NSString *specification_s;
@property (strong, nonatomic) NSNumber *price;
@property (strong, nonatomic) NSNumber *pricetype;
@property (strong, nonatomic) NSNumber *renovation;
@property (copy, nonatomic) NSString *time;
@property (strong, nonatomic) NSNumber *clickcount;
@property (copy, nonatomic) NSNumber<Optional> *iscollect;
@property (copy, nonatomic) NSString *image; //主图
@property (copy, nonatomic) NSString<Optional> *ico;
@property (strong, nonatomic) NSNumber<Optional> *wifi;
@property (strong, nonatomic) NSNumber<Optional> *heater;
@property (strong, nonatomic) NSNumber<Optional> *television;
@property (strong, nonatomic) NSNumber<Optional> *airconditioner;  //空调
@property (strong, nonatomic) NSNumber<Optional> *refrigerator; //冰箱
@property (strong, nonatomic) NSNumber<Optional> *washingmachine; //洗衣机
@property (strong, nonatomic) NSNumber<Optional> *elevator;      //电梯
@property (strong, nonatomic) NSNumber<Optional> *accesscontrol; //门禁
@property (strong, nonatomic) NSNumber<Optional> *parkingspace;  //停车位
@property (strong, nonatomic) NSNumber<Optional> *smoking;
@property (strong, nonatomic) NSNumber<Optional> *bathtub; //浴缸
@property (strong, nonatomic) NSNumber<Optional> *keepingpets; //宠物
@property (strong, nonatomic) NSNumber<Optional> *paty;       //聚会

+ (void)fetchHousingDetailWith:(NSString *)housingId handler:(RequestResultHandler)handler;
+ (void)fetchRecommendedHousingWith:(NSInteger)index handler:(RequestResultHandler)handler;
+ (void)deleteHousingWith:(NSString *)housingId handler:(RequestResultHandler)handler;

@end
