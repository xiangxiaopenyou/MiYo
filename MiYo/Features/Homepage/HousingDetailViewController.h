//
//  HousingDetailViewController.h
//  MiYo
//
//  Created by 项小盆友 on 16/4/3.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HousingModel.h"

@interface HousingDetailViewController : UIViewController
@property (copy, nonatomic) NSString *housingId;
@property (strong, nonatomic) HousingModel *simpleModel;

@end
