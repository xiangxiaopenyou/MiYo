//
//  SearchResultCell.h
//  MiYo
//
//  Created by 项小盆友 on 16/5/2.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HousingModel.h"

@interface SearchResultCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *housingImageView;
@property (weak, nonatomic) IBOutlet UILabel *housingTitle;
@property (weak, nonatomic) IBOutlet UILabel *housingTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *housingPriceLabel;

- (void)setupContentWith:(HousingModel *)model;

@end
