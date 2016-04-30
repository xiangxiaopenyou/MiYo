//
//  AreaPickerView.h
//  MiYo
//
//  Created by 项小盆友 on 16/4/25.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AreaObject.h"
@class AreaPickerView;
typedef void (^AreaPickerViewBlock)(AreaPickerView *view,UIButton *btn,AreaObject *locate);

@interface AreaPickerView : UIView
@property (copy, nonatomic) AreaPickerViewBlock block;

- (void)show;

@end
