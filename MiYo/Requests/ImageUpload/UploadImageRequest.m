//
//  UploadImageRequest.m
//  MiYo
//
//  Created by 项小盆友 on 16/4/13.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "UploadImageRequest.h"
#import <QiniuSdk.h>
#import "UIImage+ResizeMagick.h"
#import <SVProgressHUD.h>

@implementation UploadImageRequest
- (void)request:(ParamsBlock)paramsBlock result:(RequestResultHandler)resultHandler {
    if (!paramsBlock(self)) {
        return;
    }
    if (!_images || _images.count == 0) {
        !resultHandler ?: resultHandler(nil, @"dev error: image can not be empty");
        return;
    }
    NSDictionary *qnParam = @{};
    [[RequestManager shareInstance] POST:@"getToken.aspx" parameters:qnParam success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"resultCode"] isEqual:@"0000"]) {
            NSString *token = responseObject[@"data"][@"token"];
            QNUploadManager *uploadManager = [[QNUploadManager alloc] init];
            NSMutableArray *keys = [NSMutableArray array];
            for (NSInteger i = 0; i < _images.count; i ++) {
                NSData *data = [_images[i] rmk_resizedAndReturnData];
                CGFloat progressValue = (CGFloat)i / (CGFloat)_images.count;
                [SVProgressHUD showProgress:progressValue status:@"正在发布房源"];
                [uploadManager putData:data key:_keys[i] token:token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                    [keys addObject:key];
                    if (keys.count == _images.count) {
                        !resultHandler ?: resultHandler(keys, nil);
                        [SVProgressHUD showProgress:1 status:@"正在发布房源"];
                    }
                } option:nil];
            }
        } else {
            !resultHandler ?: resultHandler(nil, responseObject[@"resultMsg"]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        !resultHandler ?: resultHandler(nil, error.description);
    }];
}

@end
