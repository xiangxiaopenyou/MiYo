//
//  HousingExpectationsViewController.h
//  MiYo
//
//  Created by 项小盆友 on 16/4/26.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PersonalModel.h"
typedef void (^EditFinishedBlock) (PersonalModel *model);

@interface HousingExpectationsViewController : UIViewController
@property (strong, nonatomic) PersonalModel *personalModel;

- (void)editFinished:(EditFinishedBlock)block;

@end
