//
//  SearchResultCell.m
//  MiYo
//
//  Created by 项小盆友 on 16/5/2.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "SearchResultCell.h"
#import "Util.h"
#import <UIImageView+AFNetworking.h>

@implementation SearchResultCell

-(void)setupContentWith:(HousingModel *)model {
    self.housingTitle.text = [NSString stringWithFormat:@"%@", model.title];
    if ([model.isflatshare integerValue] == 1) {
        self.housingTypeLabel.text = @"整租";
    } else if ([model.isflatshare integerValue] == 2) {
        self.housingTypeLabel.text = @"合租";
    } else {
        self.housingTypeLabel.text = @"整租&合租";
    }
    NSString *priceString = [NSString stringWithFormat:@"￥%@/月", model.price];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:priceString];
    [attributedString addAttributes:[NSDictionary dictionaryWithObjectsAndKeys:kSystemFont(15), NSFontAttributeName, [Util turnToRGBColor:@"f47712"], NSForegroundColorAttributeName, nil] range:NSMakeRange(1, [model.price stringValue].length)];
    self.housingPriceLabel.attributedText = attributedString;
    NSArray *imageArray = [Util toArray:model.image];
    if (imageArray.count > 0) {
        [self.housingImageView setImageWithURL:[NSURL URLWithString:[Util urlPhoto:imageArray[0]]] placeholderImage:[UIImage imageNamed:@"default_housing_image"]];
    } else {
        self.housingImageView.image = [UIImage imageNamed:@"default_housing_image"];
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
