//
//  HousingResultCell.m
//  MiYo
//
//  Created by 项小盆友 on 16/5/19.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "HousingResultCell.h"
#import "Util.h"
#import <UIImageView+AFNetworking.h>



@implementation HousingResultCell
- (void)setupContentWith:(HousingModel *)model {
    NSArray *imageArray = [Util toArray:model.image];
    if (imageArray.count > 0) {
        [_housingImageView setImageWithURL:[NSURL URLWithString:[Util urlPhoto:imageArray[0]]] placeholderImage:[UIImage imageNamed:@"default_housing_image"]];
    } else {
        _housingImageView.image = [UIImage imageNamed:@"default_housing_image"];
    }
    [_portraitImageView setImageWithURL:[NSURL URLWithString:[Util urlPhoto:model.headphoto]] placeholderImage:[UIImage imageNamed:@"default_portrait"]];
    _priceLabel.text = [NSString stringWithFormat:@"￥%@", model.price];
    if ([model.iscollect integerValue] == 1) {
        _likeButton.selected = YES;
    } else {
        _likeButton.selected = NO;
    }
    _addressLabel.text = [NSString stringWithFormat:@"%@", model.addressname];
    _timeLabel.text = [NSString stringWithFormat:@"%@", [model.time substringWithRange:NSMakeRange(0, 10)]];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)likeClick:(id)sender {
}

@end
