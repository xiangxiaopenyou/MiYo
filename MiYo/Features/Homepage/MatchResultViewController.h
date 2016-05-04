//
//  MatchResultViewController.h
//  MiYo
//
//  Created by 项小盆友 on 16/5/3.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IndexReulstModel.h"
#import "HousingModel.h"

@interface MatchResultViewController : UIViewController
@property (strong, nonatomic) IndexReulstModel *indexModel;
@property (strong, nonatomic) HousingModel *housingModel;
@property (assign,  nonatomic) NSInteger sex;

@end
