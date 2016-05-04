//
//  HousingResourceCell.m
//  MiYo
//
//  Created by 项小盆友 on 16/4/1.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "HousingResourceCell.h"
#import "Util.h"
#import <UIImageView+AFNetworking.h>

@implementation HousingResourceCell
- (void)setupDataWith:(HousingModel *)model {
    if (_hosingSourceBackgroundView.layer.cornerRadius != 4.0) {
        _hosingSourceBackgroundView.layer.masksToBounds = YES;
        _hosingSourceBackgroundView.layer.cornerRadius = 4.0;
    }
    if (_hosingSourseImage.layer.cornerRadius != 4.0) {
        _hosingSourseImage.layer.masksToBounds = YES;
        _hosingSourseImage.layer.cornerRadius = 4.0;
    }
    if (_ownerHeadImage.layer.cornerRadius != 20.0) {
        _ownerHeadImage.layer.masksToBounds = YES;
        _ownerHeadImage.layer.cornerRadius = 20.0;
    }
    [_ownerHeadImage setImageWithURL:[NSURL URLWithString:[Util urlPhoto:model.headphoto]] placeholderImage:nil];
    NSArray *imageArray = [Util toArray:model.image];
    if (imageArray.count > 0) {
        [_hosingSourseImage setImageWithURL:[NSURL URLWithString:[Util urlPhoto:imageArray[0]]] placeholderImage:[UIImage imageNamed:@"default_housing_image"]];
    } else {
        _hosingSourseImage.image = [UIImage imageNamed:@"default_housing_image"];
    }
    _priceLabel.text = [NSString stringWithFormat:@"￥%@", model.price];
    _placeLabel.text = [NSString stringWithFormat:@"%@", model.title];
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
