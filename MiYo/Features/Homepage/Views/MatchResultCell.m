//
//  MatchResultCell.m
//  MiYo
//
//  Created by 项小盆友 on 16/5/3.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "MatchResultCell.h"
#import <UIImageView+AFNetworking.h>
#import "Util.h"

@implementation MatchResultCell

- (void)setupContentWith:(UserModel *)model {
    [_portraitImageView setImageWithURL:[NSURL URLWithString:[Util urlZoomPhoto:model.headphoto]] placeholderImage:[UIImage imageNamed:@"default_portrait"]];
    if ([model.sex integerValue] == 0) {
        _sexImage.hidden = YES;
    } else {
        _sexImage.hidden = NO;
        if ([model.sex integerValue] == 1) {
            _sexImage.image = [UIImage imageNamed:@"icon_male"];
        } else {
            _sexImage.image = [UIImage imageNamed:@"icon_female"];
        }
    }
    _nicknameLabel.text = [NSString stringWithFormat:@"%@", model.nickname];
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
