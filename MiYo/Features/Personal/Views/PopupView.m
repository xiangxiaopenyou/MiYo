//
//  PopupView.m
//  MiYo
//
//  Created by 项小盆友 on 16/5/16.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "PopupView.h"
#import "Util.h"

@interface PopupView()

@property (strong, nonatomic) UIView *contentView;
@property (strong, nonatomic) UIButton *housingButton;
@property (strong, nonatomic) UIButton *noHousingButton;
@property (strong, nonatomic) UIButton *closeButton;

@property (copy, nonatomic) ClickTypeBlock block;

@end

@implementation PopupView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
        self.alpha = 0;
        if (!_contentView) {
            _contentView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.frame) / 2 - 120, CGRectGetHeight(self.frame) / 2 - 60, 240, 120)];
            _contentView.layer.masksToBounds = YES;
            _contentView.layer.cornerRadius = 4.0;
            _contentView.backgroundColor = [UIColor whiteColor];
            if (!_housingButton) {
                _housingButton = [UIButton buttonWithType:UIButtonTypeCustom];
                _housingButton.frame = CGRectMake(30, 50, 80, 40);
                [_housingButton setTitle:@"有房招租" forState:UIControlStateNormal];
                [_housingButton setTitleColor:[Util turnToRGBColor:@"12c1e8"] forState:UIControlStateNormal];
                _housingButton.titleLabel.font = [UIFont systemFontOfSize:16];
                [_housingButton addTarget:self action:@selector(typeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
                [_contentView addSubview:_housingButton];
                _housingButton.layer.masksToBounds = YES;
                _housingButton.layer.cornerRadius = 3.0;
                _housingButton.layer.borderWidth = 1.0;
                _housingButton.layer.borderColor = [Util turnToRGBColor:@"12c1e8"].CGColor;
            }
            
            if (!_noHousingButton) {
                _noHousingButton = [UIButton buttonWithType:UIButtonTypeCustom];
                _noHousingButton.frame = CGRectMake(130, 50, 80, 40);
                [_noHousingButton setTitle:@"无房求租" forState:UIControlStateNormal];
                [_noHousingButton setTitleColor:[Util turnToRGBColor:@"12c1e8"] forState:UIControlStateNormal];
                _noHousingButton.titleLabel.font = [UIFont systemFontOfSize:16];
                [_noHousingButton addTarget:self action:@selector(typeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
                [_contentView addSubview:_noHousingButton];
                _noHousingButton.layer.masksToBounds = YES;
                _noHousingButton.layer.cornerRadius = 3.0;
                _noHousingButton.layer.borderWidth = 1.0;
                _noHousingButton.layer.borderColor = [Util turnToRGBColor:@"12c1e8"].CGColor;
            }
            if (!_closeButton) {
                _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
                _closeButton.frame = CGRectMake(CGRectGetWidth(_contentView.frame) - 32, 2, 30, 30);
                [_closeButton setImage:[UIImage imageNamed:@"view_close"] forState:UIControlStateNormal];
                [_closeButton addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
                [_contentView addSubview:_closeButton];
            }
            
        }
        _contentView.userInteractionEnabled = YES;
        [_contentView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(contentViewGR)]];
    }
    return self;
}
- (void)show {
    self.alpha = 1.0;
    [self addSubview:_contentView];
    //self.contentView.alpha = 1.0f;
    CAKeyframeAnimation *popAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    popAnimation.duration = 0.4;
    popAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.01f, 0.01f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1f, 1.1f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9f, 0.9f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DIdentity]];
    popAnimation.keyTimes = @[@0.2f, @0.5f, @0.75f, @1.0f];
    popAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [self.contentView.layer addAnimation:popAnimation forKey:nil];
    
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)]];
}
- (void)hide {
    [UIView animateWithDuration:0.4 animations:^{
        self.alpha = 0;
    }];
    CAKeyframeAnimation *hideAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    hideAnimation.duration = 0.4;
    hideAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1f, 1.1f, 1.0f)],
                             [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0f, 1.0f, 1.0f)],
                             [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.00f, 0.00f, 0.00f)]];
    hideAnimation.keyTimes = @[@0.2f, @0.5f, @0.75f];
    hideAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                      [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                      [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [self.contentView.layer addAnimation:hideAnimation forKey:nil];
    self.userInteractionEnabled = NO;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)contentViewGR {
    
}
- (void)clickType:(ClickTypeBlock)block {
    self.block = block;
}
- (void)typeButtonClick:(id)sender {
    UIButton *button = (UIButton *)sender;
    if (button == _housingButton) {
        if (self.block) {
            self.block(1);
        }
    } else {
        if (self.block) {
            self.block(2);
        }
    }
    [self hide];
}

@end
