//
//  HousingFacilityCell.h
//  MiYo
//
//  Created by 项小盆友 on 16/4/15.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HousingModel.h"

@interface HousingFacilityCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *facility1;
@property (weak, nonatomic) IBOutlet UIButton *facility2;
@property (weak, nonatomic) IBOutlet UIButton *facility3;
@property (weak, nonatomic) IBOutlet UIButton *facility4;
@property (weak, nonatomic) IBOutlet UIButton *facility5;
@property (weak, nonatomic) IBOutlet UIButton *facility6;
@property (weak, nonatomic) IBOutlet UIButton *facility7;
@property (weak, nonatomic) IBOutlet UIButton *facility8;
@property (weak, nonatomic) IBOutlet UIButton *facility9;
@property (weak, nonatomic) IBOutlet UIButton *facility10;
@property (weak, nonatomic) IBOutlet UIButton *facility11;
@property (weak, nonatomic) IBOutlet UIButton *facility12;
@property (weak, nonatomic) IBOutlet UIButton *facility13;

- (void)setupContentWith:(HousingModel *)model;

@end
