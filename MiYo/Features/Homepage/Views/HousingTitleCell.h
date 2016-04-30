//
//  HousingTitleCell.h
//  MiYo
//
//  Created by 项小盆友 on 16/4/15.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HousingModel.h"

@interface HousingTitleCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

- (void)setupContentWith:(HousingModel *)model;
- (CGFloat)heightOfCell:(HousingModel *)model;

@end
