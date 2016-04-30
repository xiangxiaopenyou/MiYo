//
//  HousingAddressChooseViewController.h
//  MiYo
//
//  Created by 项小盆友 on 16/4/14.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>

typedef void (^ChooseAddressBlock) (AMapPOI *point);

@interface HousingAddressChooseViewController : UIViewController
@property (copy, nonatomic) ChooseAddressBlock addressBlock;
@property (strong, nonatomic) CLLocation *location;

- (void)addressChosen:(ChooseAddressBlock)block;

@end
