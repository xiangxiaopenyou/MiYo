//
//  FixHousingStyleViewController.m
//  MiYo
//
//  Created by 项小盆友 on 16/4/10.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "FixHousingStyleViewController.h"
#import "HousingFacilitiesViewController.h"
#import "MBProgressHUD+Add.h"
#import "Util.h"

@interface FixHousingStyleViewController ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *areaTextField;
@property (weak, nonatomic) IBOutlet UIButton *decorationButton1;
@property (weak, nonatomic) IBOutlet UIButton *decorationButton2;
@property (weak, nonatomic) IBOutlet UIButton *decorationButton3;
@property (weak, nonatomic) IBOutlet UIButton *decorationButton4;
@property (weak, nonatomic) IBOutlet UIButton *orientationButton1;
@property (weak, nonatomic) IBOutlet UIButton *orientationButton2;
@property (weak, nonatomic) IBOutlet UIButton *orientationButton3;
@property (weak, nonatomic) IBOutlet UIButton *orientationButton4;
@property (weak, nonatomic) IBOutlet UITextField *roomNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *livingRoomNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *toiletNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *balconyNumberTextField;

@property (copy, nonatomic) NSString *areaString;
@property (assign, nonatomic) NSInteger decorationType;
@property (assign, nonatomic) NSInteger orientationType;
@property (assign, nonatomic) NSInteger roomNumber;
@property (assign, nonatomic) NSInteger livingRoomNumber;
@property (assign, nonatomic) NSInteger toiletNumber;
@property (assign, nonatomic) NSInteger balconyNumber;

@end

@implementation FixHousingStyleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"房型";
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"下一步" style:UIBarButtonItemStylePlain target:self action:@selector(nextStep)];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    _decorationType = 1;
    _orientationType = 1;
    _roomNumber = 0;
    _livingRoomNumber = 0;
    _toiletNumber = 0;
    _balconyNumber = 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIScrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [_areaTextField resignFirstResponder];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)nextStep {
    if ([Util isEmpty:_areaTextField.text]) {
        [MBProgressHUD showError:@"先填写您的房源面积" toView:self.view];
        return;
    }
    if ([_areaTextField.text floatValue] == 0) {
        [MBProgressHUD showError:@"房源面积不能为0" toView:self.view];
        return;
    }
    if (_roomNumber == 0 && _livingRoomNumber ==0 && _toiletNumber == 0 && _balconyNumber ==0) {
        [MBProgressHUD showError:@"房源厅室数量不能都为空噢~" toView:self.view];
        return;
    }
    _areaString = _areaTextField.text;
    NSString *housingStyleString = @"";
    if (_roomNumber > 0) {
        housingStyleString = [NSString stringWithFormat:@"%@室", @(_roomNumber)];
    }
    if (_livingRoomNumber > 0) {
        housingStyleString = [NSString stringWithFormat:@"%@%@厅", housingStyleString, @(_livingRoomNumber)];
    }
    if (_toiletNumber > 0) {
        housingStyleString = [NSString stringWithFormat:@"%@%@卫", housingStyleString, @(_toiletNumber)];
    }
    if (_balconyNumber > 0) {
        housingStyleString = [NSString stringWithFormat:@"%@%@阳台", housingStyleString, @(_balconyNumber)];
    }
    NSInteger housingStyle = 0;
    if (_roomNumber < 4) {
        housingStyle = _roomNumber;
    } else {
        housingStyle = 4;
    }
    NSDictionary *dictionary = @{@"housingtype" : @(_housingType),
                                 @"size" : _areaString,
                                 @"decoration" : @(_decorationType),
                                 @"orientation" : @(_orientationType),
                                 @"specification" : @(housingStyle),
                                 @"specification" : housingStyleString};
    HousingFacilitiesViewController *viewController = [[UIStoryboard storyboardWithName:@"Personal" bundle:nil] instantiateViewControllerWithIdentifier:@"HousingFacilitiesView"];
    viewController.informationDictionary = [NSMutableDictionary dictionaryWithDictionary:dictionary];
    [self.navigationController pushViewController:viewController animated:YES];
}
- (IBAction)minusClick:(id)sender {
    UIButton *button = (UIButton *)sender;
    switch (button.tag) {
        case 10:{
            if (_roomNumber > 0) {
                _roomNumber -= 1;
                _roomNumberTextField.text = [NSString stringWithFormat:@"%@", @(_roomNumber)];
            }
        }
            break;
        case 11:{
            if (_livingRoomNumber > 0) {
                _livingRoomNumber -= 1;
                _livingRoomNumberTextField.text = [NSString stringWithFormat:@"%@", @(_livingRoomNumber)];
            }
        }
            
            break;
        case 12:{
            if (_toiletNumber > 0) {
                _toiletNumber -= 1;
                _toiletNumberTextField.text = [NSString stringWithFormat:@"%@", @(_toiletNumber)];
            }
        }
            
            break;
        case 13:{
            if (_balconyNumber > 0) {
                _balconyNumber -= 1;
                _balconyNumberTextField.text = [NSString stringWithFormat:@"%@", @(_balconyNumber)];
            }
        }
            
            break;
            
        default:
            break;
    }
    
}
- (IBAction)plusClick:(id)sender {
    UIButton *button = (UIButton *)sender;
    switch (button.tag) {
        case 20:{
            _roomNumber += 1;
            _roomNumberTextField.text = [NSString stringWithFormat:@"%@", @(_roomNumber)];
        }
            
            break;
        case 21:{
            _livingRoomNumber += 1;
            _livingRoomNumberTextField.text = [NSString stringWithFormat:@"%@", @(_livingRoomNumber)];
        }
            
            break;
        case 22:{
            _toiletNumber += 1;
            _toiletNumberTextField.text = [NSString stringWithFormat:@"%@", @(_toiletNumber)];
        }
            
            break;
        case 23:{
            _balconyNumber += 1;
            _balconyNumberTextField.text = [NSString stringWithFormat:@"%@", @(_balconyNumber)];
        }
            
            break;
            
        default:
            break;
    }
}
- (IBAction)decorationButtonClick:(id)sender {
    UIButton *button = (UIButton *)sender;
    switch (button.tag) {
        case 11: {
            if (!button.selected) {
                _decorationButton1.selected = YES;
                _decorationButton2.selected = NO;
                _decorationButton3.selected = NO;
                _decorationButton4.selected = NO;
                _decorationType = 1;
            }
        }
            break;
        case 12: {
            if (!button.selected) {
                _decorationButton1.selected = NO;
                _decorationButton2.selected = YES;
                _decorationButton3.selected = NO;
                _decorationButton4.selected = NO;
                _decorationType = 2;
            }
        }
            break;
        case 13: {
            if (!button.selected) {
                _decorationButton1.selected = NO;
                _decorationButton2.selected = NO;
                _decorationButton3.selected = YES;
                _decorationButton4.selected = NO;
                _decorationType = 3;
            }
        }
            break;
        case 14: {
            if (!button.selected) {
                _decorationButton1.selected = NO;
                _decorationButton2.selected = NO;
                _decorationButton3.selected = NO;
                _decorationButton4.selected = YES;
                _decorationType = 4;
            }
        }
            break;
            
        default:
            break;
    }
}
- (IBAction)orientationButtonClick:(id)sender {
    UIButton *button = (UIButton *)sender;
    switch (button.tag) {
        case 21: {
            if (!button.selected) {
                _orientationButton1.selected = YES;
                _orientationButton2.selected = NO;
                _orientationButton3.selected = NO;
                _orientationButton4.selected = NO;
                _orientationType = 1;
            }
        }
            break;
        case 22: {
            if (!button.selected) {
                _orientationButton1.selected = NO;
                _orientationButton2.selected = YES;
                _orientationButton3.selected = NO;
                _orientationButton4.selected = NO;
                _orientationType = 2;
            }
        }
            break;
        case 23: {
            if (!button.selected) {
                _orientationButton1.selected = NO;
                _orientationButton2.selected = NO;
                _orientationButton3.selected = YES;
                _orientationButton4.selected = NO;
                _orientationType = 3;
            }
        }
            break;
        case 24: {
            if (!button.selected) {
                _orientationButton1.selected = NO;
                _orientationButton2.selected = NO;
                _orientationButton3.selected = NO;
                _orientationButton4.selected = YES;
                _orientationType = 4;
            }
        }
            break;
            
        default:
            break;
    }

}

@end
