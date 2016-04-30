//
//  HousingAddressAndPriceViewController.m
//  MiYo
//
//  Created by 项小盆友 on 16/4/14.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "HousingAddressAndPriceViewController.h"
#import "HousingPictureAndContentViewController.h"
#import "HousingAddressChooseViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "XLBlockAlertView.h"
#import "XLBlockActionSheet.h"
#import "MBProgressHUD+Add.h"
#import "Util.h"
#import <AMapSearchKit/AMapSearchKit.h>

@interface HousingAddressAndPriceViewController ()
@property (weak, nonatomic) IBOutlet UITextField *priceTextField;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *payStyleLabel;
@property (assign, nonatomic) NSInteger payStyle;
@property (strong, nonatomic) AMapPOI *mapPoint;
@property (copy, nonatomic) NSArray *payStyleArray;

@end

@implementation HousingAddressAndPriceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"价格和地址";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"下一步" style:UIBarButtonItemStylePlain target:self action:@selector(nextStep)];
    _payStyleArray = @[@"面议", @"押一付一", @"押一付二", @"押一付三", @"半年付", @"年付"];
    _payStyle = 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)payStyleButtonClick:(id)sender {
    [[[XLBlockActionSheet alloc] initWithTitle:nil clickedBlock:^(NSInteger buttonIndex) {
        if (buttonIndex == 0) {
            _payStyle = 0;
            _payStyleLabel.text = @"面议";
        } else if (buttonIndex > 1) {
            _payStyle = buttonIndex - 1;
            _payStyleLabel.text = _payStyleArray[buttonIndex - 1];
        }
    } cancelButtonTitle:@"取消" destructiveButtonTitle:@"面议" otherButtonTitles:@"押一付一", @"押一付二", @"押一付三", @"半年付", @"年付", nil] showInView:self.view];
}
- (IBAction)addressButtonClick:(id)sender {
    HousingAddressChooseViewController *addressChooseViewController = [[UIStoryboard storyboardWithName:@"Personal" bundle:nil] instantiateViewControllerWithIdentifier:@"AddressChooseView"];
    [addressChooseViewController addressChosen:^(AMapPOI *point) {
        _mapPoint = point;
        _addressLabel.text = point.name;
    }];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:addressChooseViewController];
    [self presentViewController:navigationController animated:YES completion:nil];
}
- (void)nextStep {
    if ([Util isEmpty:_priceTextField.text]) {
        [MBProgressHUD showError:@"请先设置房源价格" toView:self.view];
        return;
    }
    if (!_mapPoint) {
        [MBProgressHUD showError:@"请设置房源地址" toView:self.view];
        return;
    }
    NSString *addressString;
    if ([_mapPoint.province isEqual:_mapPoint.city]) {
        addressString = [NSString stringWithFormat:@"%@%@%@", _mapPoint.province, _mapPoint.district, _mapPoint.address];
    } else {
        addressString = [NSString stringWithFormat:@"%@%@%@%@", _mapPoint.province, _mapPoint.city, _mapPoint.district, _mapPoint.address];
    }
    NSLog(@"%@", addressString);
    
    NSDictionary *tempDictionary = @{@"price" : _priceTextField.text,
                                     @"pricetype" : @(_payStyle),
                                     @"address" : addressString,
                                     @"addressname" : _mapPoint.name,
                                     @"address_x" : @(_mapPoint.location.longitude),
                                     @"address_y" : @(_mapPoint.location.latitude)};
    [_informationDictionary addEntriesFromDictionary:tempDictionary];
    HousingPictureAndContentViewController *viewController = [[UIStoryboard storyboardWithName:@"Personal" bundle:nil] instantiateViewControllerWithIdentifier:@"HousingPictureView"];
    viewController.informationDictionary = _informationDictionary;
    [self.navigationController pushViewController:viewController animated:YES];
}

@end
