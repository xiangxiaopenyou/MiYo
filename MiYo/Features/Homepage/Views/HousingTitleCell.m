//
//  HousingTitleCell.m
//  MiYo
//
//  Created by 项小盆友 on 16/4/15.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "HousingTitleCell.h"

@implementation HousingTitleCell
- (void)setupContentWith:(HousingModel *)model {
    self.titleLabel.text = [NSString stringWithFormat:@"%@", model.title];
    self.descriptionLabel.text = [NSString stringWithFormat:@"%@", model.descirption];
}
- (CGFloat)heightOfCell:(HousingModel *)model {
    CGFloat height = 96;
    CGSize descriptionSize = [model.descirption boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 84, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:kSystemFont(13), NSFontAttributeName, nil] context:nil].size;
    height += descriptionSize.height;
    return height;
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
