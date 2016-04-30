//
//  AreaPickerView.m
//  MiYo
//
//  Created by 项小盆友 on 16/4/25.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "AreaPickerView.h"

@interface AreaPickerView()<UIPickerViewDataSource,UIPickerViewDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewHegithCons;
@property (weak, nonatomic) IBOutlet UIPickerView *pickView;
@property (strong, nonatomic) AreaObject *locate;
//区域 数组
//@property (strong, nonatomic) NSArray *regionArr;
//省 数组
@property (copy, nonatomic) NSArray *provinceArray;
//城市 数组
@property (copy, nonatomic) NSArray *cityArray;
////区县 数组
@property (copy, nonatomic) NSArray *areaArray;

@property (strong, nonatomic) UIButton *backgroundButton;

@end

@implementation AreaPickerView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)init{
    
    if (self = [super init]) {
        self = [[[NSBundle mainBundle]loadNibNamed:@"AreaPickerView" owner:nil options:nil]firstObject];
        self.frame = [UIScreen mainScreen].bounds;
        self.pickView.delegate = self;
        self.pickView.dataSource = self;
        self.provinceArray = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"area.plist" ofType:nil]];
        self.cityArray = self.provinceArray[0][@"cities"];
        self.areaArray = self.cityArray[0][@"areas"];
        self.locate.province = self.provinceArray[0][@"province"];
        self.locate.city = self.cityArray[0][@"city"];
        if (self.areaArray.count > 0) {
            self.locate.area = self.areaArray[0];
        } else {
            self.locate.area = @"";
        }
        self.backgroundButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.backgroundButton.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame) - 250);
        [self.backgroundButton addTarget:self action:@selector(backgroundButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.backgroundButton];
        [self customView];
    }
    return self;
}

- (void)customView{
    self.contentViewHegithCons.constant = 0;
    [self layoutIfNeeded];
}

#pragma mark - setter && getter

- (AreaObject *)locate{
    if (!_locate) {
        _locate = [[AreaObject alloc]init];
    }
    return _locate;
}

#pragma mark - action

//选择完成
- (IBAction)finishBtnPress:(UIButton *)sender {
    if (self.block) {
        self.block(self,sender,self.locate);
    }
    [self hide];
}

//隐藏
- (IBAction)dissmissBtnPress:(UIButton *)sender {
    
    [self hide];
}

#pragma  mark - function

- (void)show{
    UIWindow *win = [[UIApplication sharedApplication] keyWindow];
    UIView *topView = [win.subviews firstObject];
    [topView addSubview:self];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.contentViewHegithCons.constant = 250;
        [self layoutIfNeeded];
    }];
}

- (void)hide{
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
        self.contentViewHegithCons.constant = 0;
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    switch (component) {
        case 0:
            return self.provinceArray.count;
            break;
        case 1:
            return self.cityArray.count;
            break;
        case 2:
            return self.areaArray.count;
            break;
        default:
            return 0;
            break;
    }
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    switch (component) {
        case 0:
            return [[self.provinceArray objectAtIndex:row] objectForKey:@"state"];
            break;
        case 1:
            return [[self.cityArray objectAtIndex:row] objectForKey:@"city"];
            break;
        case 2:{
            //            if (self.areaArr.count > 0) {
            //
            //            }
            return [self.areaArray objectAtIndex:row];
        }
            break;
        default:
            return  @"";
            break;
    }
}
#pragma mark - UIPickerViewDelegate

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.minimumScaleFactor = 8.0;
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont boldSystemFontOfSize:15]];
    }
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    switch (component) {
        case 0:{
            self.cityArray = self.provinceArray[row][@"cities"];
            [self.pickView reloadComponent:1];
            [self.pickView selectRow:0 inComponent:1 animated:YES];
            self.areaArray = self.cityArray[0][@"areas"];
            [self.pickView reloadComponent:2];
            [self.pickView selectRow:0 inComponent:2 animated:YES];
            if (row < 4) {
                self.locate.province = [NSString stringWithFormat:@"%@市", self.provinceArray[row][@"state"]];
            } else if (row > 26) {
                self.locate.province = [NSString stringWithFormat:@"%@", self.provinceArray[row][@"state"]];
            } else {
                self.locate.province = [NSString stringWithFormat:@"%@省", self.provinceArray[row][@"state"]];
            }
            //self.locate.province = self.provinceArray[row][@"state"];
            if (row < 4) {
                self.locate.city = [NSString stringWithFormat:@"%@区", self.cityArray[0][@"city"]];
            } else {
                self.locate.city = [NSString stringWithFormat:@"%@市", self.cityArray[0][@"city"]];
            }
            if (self.areaArray.count > 0) {
                self.locate.area = self.areaArray[0];
            } else {
                self.locate.area = @"";
            }
            
            break;
        }
        case 1:
        {
            NSInteger componentRow = [pickerView selectedRowInComponent:0];
            self.areaArray = [self.cityArray objectAtIndex:row][@"areas"];
            [self.pickView reloadComponent:2];
            [self.pickView selectRow:0 inComponent:2 animated:YES];
            if (componentRow < 4) {
                self.locate.city = [NSString stringWithFormat:@"%@区", self.cityArray[row][@"city"]];
            } else {
                self.locate.city = [NSString stringWithFormat:@"%@市", self.cityArray[row][@"city"]];
            }
            if (self.areaArray.count > 0) {
                self.locate.area = self.areaArray[0];
            } else {
                self.locate.area = @"";
            }
            
            break;
        }
        case 2:{
            
            self.locate.area = self.areaArray[row];
            
            break;
        }
            
        default:
            break;
    }
}
- (void)backgroundButtonClick {
    [self hide];
}


@end
