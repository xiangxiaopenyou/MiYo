//
//  MatchingViewController.h
//  MiYo
//
//  Created by 项小盆友 on 16/4/30.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HousingModel.h"

@interface MatchingViewController : UIViewController
@property (strong, nonatomic) HousingModel *model;
@property (assign, nonatomic) BOOL isMatchHousingsAndFriends;

@end
