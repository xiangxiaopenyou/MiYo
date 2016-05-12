//
//  SystemMessageCell.m
//  MiYo
//
//  Created by 项小盆友 on 16/4/9.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "SystemMessageCell.h"
#import "Util.h"

@implementation SystemMessageCell

- (void)setupContentWithModel:(MessageModel *)model {
    if (!_tipLabel) {
//        CGFloat imageViewWidth = CGRectGetWidth(self.imageView.frame);
        //CGFloat imageViewHeight = CGRectGetHeight(self.imageView.bounds);
        _tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(28, 0, 10, 10)];
        if (_tipLabel.layer.cornerRadius != 5.0) {
            _tipLabel.layer.masksToBounds = YES;
            _tipLabel.layer.cornerRadius = 5.0;
        }
        _tipLabel.backgroundColor = [UIColor redColor];
    }
    [self.imageView addSubview:_tipLabel];
    if ([model.state integerValue] == 1) {
        _tipLabel.hidden = YES;
    } else {
        _tipLabel.hidden = NO;
    }
    if (!self.timeLabel) {
        self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 100, 10, 85, 20)];
        self.timeLabel.font = kSystemFont(12);
        self.timeLabel.textColor = [Util turnToRGBColor:@"646464"];
        self.timeLabel.textAlignment = NSTextAlignmentRight;
        
    }
    NSString *timeString = model.time;
    timeString = [timeString stringByReplacingOccurrencesOfString:@"T" withString:@" "];
    NSDate *timeDate = [Util getTimeDate:timeString];
    if ([[Util compareDate:timeDate] isEqualToString:@"今天"]) {
        timeString = [timeString substringWithRange:NSMakeRange(11, 5)];
    } else if ([[Util compareDate:timeDate] isEqualToString:@"昨天"]) {
        timeString = [NSString stringWithFormat:@"昨天%@", [timeString substringWithRange:NSMakeRange(11, 5)]];
    } else {
        timeString = [timeString substringWithRange:NSMakeRange(5, 11)];
    }
    self.timeLabel.text = timeString;
    [self.contentView addSubview:self.timeLabel];
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
