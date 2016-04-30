//
//  MessageModel.h
//  MiYo
//
//  Created by 项小盆友 on 16/4/18.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "BaseModel.h"

@interface MessageModel : BaseModel
@property (copy, nonatomic) NSString *id;
@property (strong, nonatomic) NSNumber *type;
@property (strong, nonatomic) NSNumber *state;
@property (copy, nonatomic) NSString *time;
@property (copy, nonatomic) NSString<Optional> *senduserid;
@property (copy, nonatomic) NSString<Optional> *nickname;
@property (copy, nonatomic) NSString<Optional> *receiveuserid;
@property (copy, nonatomic) NSString<Optional> *content;
@property (copy, nonatomic) NSString<Optional> *houseid;
@property (copy, nonatomic) NSString<Optional> *headphoto;

+ (void)fetchMessageListWith:(NSInteger)limit handler:(RequestResultHandler)handler;
+ (void)fetchUnreadQualityWith:(RequestResultHandler)handler;
+ (void)deleteMessageWith:(NSString *)messageId handler:(RequestResultHandler)handler;
@end
