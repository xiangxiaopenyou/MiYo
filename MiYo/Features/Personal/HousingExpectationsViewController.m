//
//  HousingExpectationsViewController.m
//  MiYo
//
//  Created by 项小盆友 on 16/4/26.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "HousingExpectationsViewController.h"
#import <AMapSearchKit/AMapSearchKit.h>
#import "HousingAddressChooseViewController.h"
#import "MBProgressHUD+Add.h"
#import "Util.h"

@interface HousingExpectationsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UITextField *minPriceText;
@property (weak, nonatomic) IBOutlet UITextField *maxPriceText;

@property (weak, nonatomic) IBOutlet UIButton *facilityButton1;
@property (weak, nonatomic) IBOutlet UIButton *facilityButton2;
@property (weak, nonatomic) IBOutlet UIButton *facilityButton3;
@property (weak, nonatomic) IBOutlet UIButton *facilityButton4;
@property (weak, nonatomic) IBOutlet UIButton *facilityButton5;
@property (weak, nonatomic) IBOutlet UIButton *facilityButton6;
@property (weak, nonatomic) IBOutlet UIButton *facilityButton7;
@property (weak, nonatomic) IBOutlet UIButton *facilityButton8;
@property (weak, nonatomic) IBOutlet UIButton *facilityButton9;
@property (weak, nonatomic) IBOutlet UIButton *facilityButton10;
@property (weak, nonatomic) IBOutlet UIButton *facilityButton11;
@property (weak, nonatomic) IBOutlet UIButton *facilityButton12;
@property (weak, nonatomic) IBOutlet UIButton *facilityButton13;
@property (weak, nonatomic) IBOutlet UIButton *decorationButton1;
@property (weak, nonatomic) IBOutlet UIButton *decorationButton2;
@property (weak, nonatomic) IBOutlet UIButton *decorationButton3;
@property (weak, nonatomic) IBOutlet UIButton *decorationButton4;
@property (strong, nonatomic) AMapPOI *mapPoint;
@property (strong, nonatomic) PersonalModel *personalModel;

//@property (copy, nonatomic) EditFinishedBlock block;
@end

@implementation HousingExpectationsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"租房简历";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveClick)];
    [self fetchUserInformation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}
- (void)resetView {
    if (![Util isEmpty:_personalModel.hopeaddress]) {
        _addressLabel.text = [NSString stringWithFormat:@"%@", _personalModel.hopeaddress];
    }
    if (![Util isEmpty:_personalModel.hopepricemin]) {
        _minPriceText.text = [NSString stringWithFormat:@"%@", _personalModel.hopepricemin];
    }
    if (![Util isEmpty:_personalModel.hoppricemax]) {
        _maxPriceText.text = [NSString stringWithFormat:@"%@", _personalModel.hoppricemax];
    }
    if ([_personalModel.wifi integerValue] == 1) {
        _facilityButton1.selected = YES;
    } else {
        _facilityButton1.selected = NO;
    }
    if ([_personalModel.washingmachine integerValue] == 1) {
        _facilityButton2.selected = YES;
    } else {
        _facilityButton2.selected = NO;
    }
    if ([_personalModel.television integerValue] == 1) {
        _facilityButton3.selected = YES;
    } else {
        _facilityButton3.selected = NO;
    }
    if ([_personalModel.refrigerator integerValue] == 1) {
        _facilityButton4.selected = YES;
    } else {
        _facilityButton4.selected = NO;
    }
    if ([_personalModel.heater integerValue] == 1) {
        _facilityButton5.selected = YES;
    } else {
        _facilityButton5.selected = NO;
    }
    if ([_personalModel.airconditioner integerValue] == 1) {
        _facilityButton6.selected = YES;
    } else {
        _facilityButton6.selected = NO;
    }
    if ([_personalModel.accesscontrol integerValue] == 1) {
        _facilityButton7.selected = YES;
    } else {
        _facilityButton7.selected = NO;
    }
    if ([_personalModel.elevator integerValue] == 1) {
        _facilityButton8.selected = YES;
    } else {
        _facilityButton8.selected = NO;
    }
    if ([_personalModel.parkingspace integerValue] == 1) {
        _facilityButton9.selected = YES;
    } else {
        _facilityButton9.selected = NO;
    }
    if ([_personalModel.bathtub integerValue] == 1) {
        _facilityButton10.selected = YES;
    } else {
        _facilityButton10.selected = NO;
    }
    if ([_personalModel.keepingpets integerValue] == 1) {
        _facilityButton11.selected = YES;
    } else {
        _facilityButton11.selected = NO;
    }
    if ([_personalModel.smoking integerValue] == 1) {
        _facilityButton12.selected = YES;
    } else {
        _facilityButton12.selected = NO;
    }
    if ([_personalModel.paty integerValue] == 1) {
        _facilityButton13.selected = YES;
    } else {
        _facilityButton13.selected = NO;
    }
    if ([_personalModel.hoperenovation integerValue] == 1) {
        _decorationButton1.selected = YES;
    } else if ([_personalModel.hoperenovation integerValue] == 2) {
        _decorationButton2.selected = YES;
    } else if ([_personalModel.hoperenovation integerValue] == 3) {
        _decorationButton3.selected = YES;
    } else if ([_personalModel.hoperenovation integerValue] == 4) {
        _decorationButton4.selected = YES;
    }
}
- (void)hideKeyboard {
    [_minPriceText resignFirstResponder];
    [_maxPriceText resignFirstResponder];
}

#pragma mark - Request
- (void)fetchUserInformation {
    NSString *userId = [[NSUserDefaults standardUserDefaults] stringForKey:USERID];
    [PersonalModel fetchUserInformationWith:userId handler:^(id object, NSString *msg) {
        if (!msg) {
            _personalModel = object;
            [self resetView];
        }
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)setAddressButtonClick:(id)sender {
    HousingAddressChooseViewController *addressChooseViewController = [[UIStoryboard storyboardWithName:@"Personal" bundle:nil] instantiateViewControllerWithIdentifier:@"AddressChooseView"];
    [addressChooseViewController addressChosen:^(AMapPOI *point) {
        _mapPoint = point;
        NSString *addressString;
        if ([_mapPoint.province isEqual:_mapPoint.city]) {
            addressString = [NSString stringWithFormat:@"%@%@%@", _mapPoint.province, _mapPoint.district, _mapPoint.address];
        } else {
            addressString = [NSString stringWithFormat:@"%@%@%@%@", _mapPoint.province, _mapPoint.city, _mapPoint.district, _mapPoint.address];
        }
        _addressLabel.text = addressString;
    }];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:addressChooseViewController];
    [self presentViewController:navigationController animated:YES completion:nil];
}
- (IBAction)facilityButtonClick:(id)sender {
    UIButton *button = (UIButton *)sender;
    button.selected = !button.selected;
}
- (IBAction)decorationButtonClick:(id)sender {
    UIButton *button = (UIButton *)sender;
    if (button == _decorationButton1) {
        if (button.selected) {
            _decorationButton1.selected = NO;
        } else {
            _decorationButton1.selected = YES;
            _decorationButton2.selected = NO;
            _decorationButton3.selected = NO;
            _decorationButton4.selected = NO;
            
        }
    } else if (button == _decorationButton2) {
        if (button.selected) {
            _decorationButton2.selected = NO;
        } else {
            _decorationButton1.selected = NO;
            _decorationButton2.selected = YES;
            _decorationButton3.selected = NO;
            _decorationButton4.selected = NO;
            
        }
    } else if (button == _decorationButton3) {
        if (button.selected) {
            _decorationButton3.selected = NO;
        } else {
            _decorationButton1.selected = NO;
            _decorationButton2.selected = NO;
            _decorationButton3.selected = YES;
            _decorationButton4.selected = NO;
            
        }
    } else {
        if (button.selected) {
            _decorationButton4.selected = NO;
        } else {
            _decorationButton1.selected = NO;
            _decorationButton2.selected = NO;
            _decorationButton3.selected = NO;
            _decorationButton4.selected = YES;
            
        }
    }
}
- (void)saveClick {
    if (![Util isEmpty:_minPriceText.text] && ![Util isEmpty:_maxPriceText.text]) {
        if ([_minPriceText.text floatValue] > [_maxPriceText.text floatValue]) {
            [MBProgressHUD showError:@"最高价格要高于最低价格噢~" toView:self.view];
            return;
        }
    }
    _personalModel.hopepricemin = [NSString stringWithFormat:@"%@", _minPriceText.text];
    _personalModel.hoppricemax = [NSString stringWithFormat:@"%@", _maxPriceText.text];
    if (_mapPoint) {
        NSString *addressString;
        if ([_mapPoint.province isEqual:_mapPoint.city]) {
            addressString = [NSString stringWithFormat:@"%@%@%@", _mapPoint.province, _mapPoint.district, _mapPoint.address];
        } else {
            addressString = [NSString stringWithFormat:@"%@%@%@%@", _mapPoint.province, _mapPoint.city, _mapPoint.district, _mapPoint.address];
        }
        _personalModel.hopeaddress = addressString;
        _personalModel.address_x = [NSString stringWithFormat:@"%@", @(_mapPoint.location.longitude)];
        _personalModel.address_y = [NSString stringWithFormat:@"%@", @(_mapPoint.location.latitude)];
    }
    _personalModel.wifi = _facilityButton1.selected ? @(1) : @(0);
    _personalModel.washingmachine = _facilityButton2.selected ? @(1) : (0);
    _personalModel.television = _facilityButton3.selected ? @(1) : @(0);
    _personalModel.refrigerator = _facilityButton4.selected ? @(1) : (0);
    _personalModel.heater = _facilityButton5.selected ? @(1) : @(0);
    _personalModel.airconditioner = _facilityButton6.selected ? @(1) : (0);
    _personalModel.accesscontrol = _facilityButton7.selected ? @(1) : @(0);
    _personalModel.elevator = _facilityButton8.selected ? @(1) : (0);
    _personalModel.parkingspace = _facilityButton9.selected ? @(1) : @(0);
    _personalModel.bathtub = _facilityButton10.selected ? @(1) : (0);
    _personalModel.keepingpets = _facilityButton11.selected ? @(1) : @(0);
    _personalModel.smoking = _facilityButton12.selected ? @(1) : (0);
    _personalModel.paty = _facilityButton13.selected ? @(1) : @(0);
    _personalModel.hoperenovation = @(0);
    if (_decorationButton1.selected) {
        _personalModel.hoperenovation = @(1);
    }
    if (_decorationButton2.selected) {
        _personalModel.hoperenovation = @(2);
    }
    if (_decorationButton3.selected) {
        _personalModel.hoperenovation = @(3);
    }
    if (_decorationButton4.selected) {
        _personalModel.hoperenovation = @(4);
    }
    NSString *userId = [[NSUserDefaults standardUserDefaults] stringForKey:USERID];
    NSMutableDictionary *param = [@{@"userid" : userId} mutableCopy];
    if (![Util isEmpty:_personalModel.headphoto]) {
        [param setObject:_personalModel.headphoto forKey:@"headphoto"];
    }
    [param setObject:_personalModel.nickname forKey:@"nickname"];
    if ([Util isEmpty:_personalModel.weichat]) {
        [param setObject:@"" forKey:@"weichat"];
    } else {
        [param setObject:_personalModel.weichat forKey:@"weichat"];
    }
    if ([Util isEmpty:_personalModel.qq]) {
        [param setObject:@"" forKey:@"qq"];
    } else {
        [param setObject:_personalModel.qq forKey:@"qq"];
    }
    if ([Util isEmpty:_personalModel.name]) {
        [param setObject:@"" forKey:@"name"];
    } else {
        [param setObject:_personalModel.name forKey:@"name"];
    }
    [param setObject:_personalModel.sex forKey:@"sex"];
    [param setObject:_personalModel.age forKey:@"age"];
    if ([Util isEmpty:_personalModel.nativeplace]) {
        [param setObject:@"" forKey:@"nativeplace"];
    } else {
        [param setObject:_personalModel.nativeplace forKey:@"nativeplace"];
    }
    if ([Util isEmpty:_personalModel.liveplace]) {
        [param setObject:@"" forKey:@"liveplace"];
    } else {
        [param setObject:_personalModel.liveplace forKey:@"liveplace"];
    }
    if ([Util isEmpty:_personalModel.job]) {
        [param setObject:@"" forKey:@"job"];
    } else {
        [param setObject:_personalModel.job forKey:@"job"];
    }
    [param setObject:_personalModel.isallowsharehouse forKey:@"isallowsharehouse"];
    if (![Util isEmpty:_personalModel.hopeaddress]) {
        [param setObject:_personalModel.hopeaddress forKey:@"hopeaddress"];
    }
    [param setObject:_personalModel.hopepricemin forKey:@"hopepricemin"];
    [param setObject:_personalModel.hoppricemax forKey:@"hoppricemax"];
    [param setObject:_personalModel.hoperenovation forKey:@"hoperenovation"];
    [param setObject:_personalModel.wifi forKey:@"wifi"];
    [param setObject:_personalModel.washingmachine forKey:@"washingmachine"];
    [param setObject:_personalModel.television forKey:@"television"];
    [param setObject:_personalModel.refrigerator forKey:@"refrigerator"];
    [param setObject:_personalModel.heater forKey:@"heater"];
    [param setObject:_personalModel.airconditioner forKey:@"airconditioner"];
    [param setObject:_personalModel.accesscontrol forKey:@"accesscontrol"];
    [param setObject:_personalModel.elevator forKey:@"elevator"];
    [param setObject:_personalModel.parkingspace forKey:@"parkingspace"];
    [param setObject:_personalModel.bathtub forKey:@"bathtub"];
    [param setObject:_personalModel.keepingpets forKey:@"keepingpets"];
    [param setObject:_personalModel.smoking forKey:@"smoking"];
    [param setObject:_personalModel.paty forKey:@"paty"];
    [param setObject:_personalModel.hoperenovation forKey:@"hoperenovation"];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [PersonalModel modifyInformationWith:param handler:^(id object, NSString *msg) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (!msg) {
            NSLog(@"修改成功");
            [MBProgressHUD showSuccess:@"保存成功" toView:self.view];
            [self.navigationController popViewControllerAnimated:YES];
            //NSDictionary *tempDictionary = @{@""}
            //[[NSNotificationCenter defaultCenter] postNotificationName:@"EditInformationSuccess" object:nil];
        } else {
            NSLog(@"修改失败");
            [MBProgressHUD showError:@"保存失败" toView:self.view];
        }
    }];
    
}
//- (void)editFinished:(EditFinishedBlock)block {
//    self.block = block;
//}

@end
