//
//  HousingFacilityCell.m
//  MiYo
//
//  Created by 项小盆友 on 16/4/15.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "HousingFacilityCell.h"

@implementation HousingFacilityCell
- (void)setupContentWith:(HousingModel *)model {
    _facility1.selected = [model.wifi integerValue] == 1? YES : NO;
    _facility2.selected = [model.washingmachine integerValue] == 1? YES : NO;
    _facility3.selected = [model.television integerValue] == 1? YES : NO;
    _facility4.selected = [model.refrigerator integerValue] == 1? YES : NO;
    _facility5.selected = [model.heater integerValue] == 1? YES : NO;
    _facility6.selected = [model.airconditioner integerValue] == 1? YES : NO;
    _facility7.selected = [model.accesscontrol integerValue] == 1? YES : NO;
    _facility8.selected = [model.elevator integerValue] == 1? YES : NO;
    _facility9.selected = [model.parkingspace integerValue] == 1? YES : NO;
    _facility10.selected = [model.bathtub integerValue] == 1? YES : NO;
    _facility11.selected = [model.keepingpets integerValue] == 1? YES : NO;
    _facility12.selected = [model.smoking integerValue] == 1? YES : NO;
    _facility13.selected = [model.paty integerValue] == 1? YES : NO;
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
