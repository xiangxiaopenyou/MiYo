//
//  MyHousingCell.h
//  MiYo
//
//  Created by 项小盆友 on 16/4/15.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HousingModel.h"

@interface MyHousingCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *housingTypeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *housingImageView;
@property (weak, nonatomic) IBOutlet UILabel *housingPriceLabel;

- (void)setupContentWith:(HousingModel *)model;

@end
