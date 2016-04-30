//
//  HousingSituationCell.h
//  MiYo
//
//  Created by 项小盆友 on 16/4/15.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HousingModel.h"

@interface HousingSituationCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *housingStyle;
@property (weak, nonatomic) IBOutlet UILabel *housingDecoration;
@property (weak, nonatomic) IBOutlet UILabel *housingArea;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *housingOrientation;

- (void)setupContentWith:(HousingModel *)model;

@end
