//
//  MyHousingCell.m
//  MiYo
//
//  Created by 项小盆友 on 16/4/15.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "MyHousingCell.h"
#import "Util.h"
#import <UIImageView+AFNetworking.h>

@implementation MyHousingCell
- (void)setupContentWith:(HousingModel *)model {
    _timeLabel.text = [NSString stringWithFormat:@"%@", [model.time substringWithRange:NSMakeRange(0, 10)]];
    _titleLabel.text = [NSString stringWithFormat:@"%@", model.title];
    _addressLabel.text = [NSString stringWithFormat:@"%@", model.addressname];
    if ([model.isflatshare integerValue] == 1) {
        _housingTypeLabel.text = @"整租";
    } else if ([model.isflatshare integerValue] == 2) {
        _housingTypeLabel.text = @"合租";
    } else {
        _housingTypeLabel.text = @"整租&合租";
    }
    _housingPriceLabel.text = [NSString stringWithFormat:@"￥%@/月", model.price];
    NSArray *imageArray = [Util toArray:model.image];
    if (imageArray.count > 0) {
        [_housingImageView setImageWithURL:[NSURL URLWithString:[Util urlPhoto:imageArray[0]]] placeholderImage:[UIImage imageNamed:@"default_housing_image"]];
    } else {
        _housingImageView.image = [UIImage imageNamed:@"default_housing_image"];
    }
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
