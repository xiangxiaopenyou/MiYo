//
//  HousingSituationCell.m
//  MiYo
//
//  Created by 项小盆友 on 16/4/15.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "HousingSituationCell.h"
#import "Util.h"

@implementation HousingSituationCell

- (void)setupContentWith:(HousingModel *)model {
    _housingStyle.text = [NSString stringWithFormat:@"房型：%@", model.specification_s];
    _housingArea.text = [NSString stringWithFormat:@"面积：%@㎡", model.size];
    NSString *decorationString = @"";
    switch ([model.renovation integerValue]) {
        case 1:
            decorationString = @"简单装修";
            break;
        case 2:
            decorationString = @"中等装修";
            break;
        case 3:
            decorationString = @"精装修";
            break;
        case 4:
            decorationString = @"豪华装修";
            break;
        default:
            break;
    }
    _housingDecoration.text = [NSString stringWithFormat:@"装修：%@", decorationString];
    NSString *orientationString = @"";
    switch ([model.orientation integerValue]) {
        case 1:
            orientationString = @"东";
            break;
        case 2:
            orientationString = @"南";
            break;
        case 3:
            orientationString = @"西";
            break;
        case 4:
            orientationString = @"北";
            break;
            
        default:
            break;
    }
    _housingOrientation.text = [NSString stringWithFormat:@"朝向：%@", orientationString];
    _time.text = [NSString stringWithFormat:@"发布时间：%@", [model.time substringWithRange:NSMakeRange(0, 10)]];
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
