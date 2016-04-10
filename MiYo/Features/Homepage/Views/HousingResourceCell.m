//
//  HousingResourceCell.m
//  MiYo
//
//  Created by 项小盆友 on 16/4/1.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "HousingResourceCell.h"

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
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
