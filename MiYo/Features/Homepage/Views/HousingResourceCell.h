//
//  HousingResourceCell.h
//  MiYo
//
//  Created by 项小盆友 on 16/4/1.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HousingModel.h"

@interface HousingResourceCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *hosingSourseImage;
@property (weak, nonatomic) IBOutlet UIView *hosingSourceBackgroundView;
@property (weak, nonatomic) IBOutlet UIImageView *ownerHeadImage;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *placeLabel;

- (void)setupDataWith:(HousingModel *)model;

@end
