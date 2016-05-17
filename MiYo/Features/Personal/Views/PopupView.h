//
//  PopupView.h
//  MiYo
//
//  Created by 项小盆友 on 16/5/16.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^ClickTypeBlock) (NSInteger index);

@interface PopupView : UIView
- (void)show;
- (void)hide;
- (void)clickType:(ClickTypeBlock)block;

@end
