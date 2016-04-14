//
//  HousingAddressAndPriceViewController.m
//  MiYo
//
//  Created by 项小盆友 on 16/4/14.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "HousingAddressAndPriceViewController.h"
#import "HousingPictureAndContentViewController.h"

@interface HousingAddressAndPriceViewController ()
@property (weak, nonatomic) IBOutlet UITextField *priceTextField;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@end

@implementation HousingAddressAndPriceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"价格和地址";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"下一步" style:UIBarButtonItemStylePlain target:self action:@selector(nextStep)];
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
- (IBAction)addressButtonClick:(id)sender {
}
- (void)nextStep {
    HousingPictureAndContentViewController *viewController = [[UIStoryboard storyboardWithName:@"Personal" bundle:nil] instantiateViewControllerWithIdentifier:@"HousingPictureView"];
    [self.navigationController pushViewController:viewController animated:YES];
}

@end
