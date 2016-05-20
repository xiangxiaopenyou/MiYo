//
//  HousingResultCell.h
//  MiYo
//
//  Created by 项小盆友 on 16/5/19.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HousingModel.h"

@interface HousingResultCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *housingImageView;
@property (weak, nonatomic) IBOutlet UIImageView *portraitImageView;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;

- (void)setupContentWith:(HousingModel *)model;

@end
