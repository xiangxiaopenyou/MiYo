//
//  SystemMessageCell.h
//  MiYo
//
//  Created by 项小盆友 on 16/4/9.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageModel.h"

@interface SystemMessageCell : UITableViewCell
@property (strong, nonatomic) UILabel *timeLabel;
@property (strong, nonatomic) UILabel *tipLabel;

- (void)setupContentWithModel:(MessageModel *)model;

@end
