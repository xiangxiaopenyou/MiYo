//
//  Util.m
//  fitplus
//
//  Created by xlp on 15/7/6.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "Util.h"
#import "RequestManager.h"
#import "CommonsDefines.h"

@implementation Util
/**
 *  是否已登录
 */
+ (BOOL)isLogin {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:USERID] && [[NSUserDefaults standardUserDefaults] objectForKey:NICKNAME]) {
        return YES;
    } else {
        return NO;
    }
}

/*
 空值判断
 */
+ (BOOL)isEmpty:(id)sender {
    if (sender == nil || [sender isEqual:@""] || sender == [NSNull null] || [sender isEqual:[NSNull null]]) {
        return YES;
    }
    return NO;
}
+ (BOOL)validatePhone:(NSString *)phone {
    NSString *phoneRegex = @"1[3|5|7|8|][0-9]{9}";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    return [phoneTest evaluateWithObject:phone];
}
+ (UIColor *)turnToRGBColor:(NSString *)hexColor {
    unsigned int red,green,blue;
    NSRange range;
    range.length = 2;
    
    range.location = 0;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&red];
    
    range.location = 2;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&green];
    
    range.location = 4;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&blue];
    
    return [UIColor colorWithRed:(float)(red/255.0f) green:(float)(green / 255.0f) blue:(float)(blue / 255.0f) alpha:1.0f];
}
+ (NSString *)urlPhoto:(NSString*)key {
    if ([self isEmpty:key]) {
        return [NSString stringWithFormat:@"%@%@", BaseImageURL,@"1.png?imageView/5/w/320/h/480"];
    } else {
        NSArray *urlComps = [key componentsSeparatedByString:@"://"];
        if([urlComps count] && ( [[urlComps objectAtIndex:0] isEqualToString:@"http"]||[[urlComps objectAtIndex:0] isEqualToString:@"https"] )) {
            return key;
        }
        return [NSString stringWithFormat:@"%@%@", BaseImageURL, key];
    }
}

+ (NSString *)urlZoomPhoto:(NSString*)key {
    if ([self isEmpty:key]) {
        return [NSString stringWithFormat:@"%@%@", BaseImageURL, @"1.png?imageView/5/w/160/h/160"];
    } else {
        NSArray *urlComps = [key componentsSeparatedByString:@"://"];
        if([urlComps count] && ([[urlComps objectAtIndex:0] isEqualToString:@"http"]||[[urlComps objectAtIndex:0] isEqualToString:@"https"])) {
            return [NSString stringWithFormat:@"%@?imageView/5/w/160/h/160", key];
        }
        return [NSString stringWithFormat:@"%@%@?imageView/5/w/160/h/160",BaseImageURL,key];
    }
}

+ (NSString *)compareDate:(NSDate *)date {
    
    NSTimeInterval secondsPerDay = 24 * 60 * 60;
    NSDate *today = [[NSDate alloc] init];
    NSDate *tomorrow, *yesterday, *aftertomorrow;
    
    tomorrow = [today dateByAddingTimeInterval: secondsPerDay];
    yesterday = [today dateByAddingTimeInterval: -secondsPerDay];
    aftertomorrow = [tomorrow dateByAddingTimeInterval:secondsPerDay];
    
    // 10 first characters of description is the calendar date:
    NSString * todayString = [[today description] substringToIndex:10];
    NSString * yesterdayString = [[yesterday description] substringToIndex:10];
    NSString * tomorrowString = [[tomorrow description] substringToIndex:10];
    NSString *afterTomorrowString = [[aftertomorrow description] substringToIndex:10];
    NSString *dateS = [self getDateString:date];
    NSString * dateString = [dateS substringToIndex:10];
    
    if ([dateString isEqualToString:todayString])
    {
        return @"今天";
    } else if ([dateString isEqualToString:yesterdayString])
    {
        return @"昨天";
    }else if ([dateString isEqualToString:tomorrowString])
    {
        return @"明天";
    }
    else if([dateString isEqualToString:afterTomorrowString])
    {
        return @"后天";
    }
    else{
        return dateString;
    }
}
+ (NSString*)getDateString:(NSDate *)date {
    NSLog(@"date %@",date);
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:SS"];
    NSString *dateString = [formatter stringFromDate:date];
    NSLog(@"datestring %@",dateString);
    return dateString;
}
+ (NSDate *)getTimeDate:(NSString *)timeString {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:SS"];
    NSDate *date  = [dateFormatter dateFromString:timeString];
    return date;
}

+ (NSString *)toJSONDataSting:(id)theData{
    
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:theData
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    
    if ([jsonData length] > 0 && error == nil){
        NSString *jsonString = [[NSString alloc] initWithData:jsonData
                                                     encoding:NSUTF8StringEncoding];
        return jsonString;
    }else{
        return nil;
    }
}
+ (NSArray *)toArray:(NSString *)jsonString {
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSArray *array = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error];
    return array;
}


@end
