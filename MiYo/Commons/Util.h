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
+ (BOOL)isEmpty:(id)sender;
+ (BOOL)validatePhone:(NSString *)phone;
+ (UIColor *)turnToRGBColor:(NSString *)hexColor;
+ (NSString *)urlPhoto:(NSString*)key;
+ (NSString *)urlZoomPhoto:(NSString*)key;

@end
