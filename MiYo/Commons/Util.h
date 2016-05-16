//
//  Util.h
//  fitplus
//
//  Created by xlp on 15/7/6.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Util : NSObject
+ (BOOL)isLogin;
+ (BOOL)isEmpty:(id)sender;
+ (BOOL)validatePhone:(NSString *)phone;
+ (UIColor *)turnToRGBColor:(NSString *)hexColor;
+ (NSString *)urlPhoto:(NSString*)key;
+ (NSString *)urlZoomPhoto:(NSString*)key;

+ (NSString*)getDateString:(NSDate *)date;
+ (NSString *)compareDate:(NSDate *)date;
+ (NSDate *)getTimeDate:(NSString *)timeString;
+ (NSString *)toJSONDataSting:(id)theData;
+ (NSArray *)toArray:(NSString *)jsonString;

@end
