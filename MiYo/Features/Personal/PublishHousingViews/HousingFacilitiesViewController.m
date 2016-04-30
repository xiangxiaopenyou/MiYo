//
//  HousingFacilitiesViewController.m
//  MiYo
//
//  Created by 项小盆友 on 16/4/13.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "HousingFacilitiesViewController.h"
#import "HousingAddressAndPriceViewController.h"

@interface HousingFacilitiesViewController ()
@property (assign, nonatomic) NSInteger wifi;
@property (assign, nonatomic) NSInteger washingMachine;
@property (assign, nonatomic) NSInteger television;
@property (assign, nonatomic) NSInteger refrigerator; //冰箱
@property (assign, nonatomic) NSInteger heater;
@property (assign, nonatomic) NSInteger airConditioner;
@property (assign, nonatomic) NSInteger accessControl;
@property (assign, nonatomic) NSInteger elevator;
@property (assign, nonatomic) NSInteger parkingSpace;
@property (assign, nonatomic) NSInteger bathtub;
@property (assign, nonatomic) NSInteger keepingPets;
@property (assign, nonatomic) NSInteger smoking;
@property (assign, nonatomic) NSInteger party;

@end

@implementation HousingFacilitiesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"设施";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"下一步" style:UIBarButtonItemStylePlain target:self action:@selector(nextStep)];
    _wifi = 0;
    _washingMachine = 0;
    _television = 0;
    _refrigerator = 0;
    _heater = 0;
    _airConditioner = 0;
    _accessControl = 0;
    _elevator = 0;
    _parkingSpace = 0;
    _bathtub = 0;
    _keepingPets = 0;
    _smoking = 0;
    _party = 0;
    
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
- (IBAction)facilityButtonClick:(id)sender {
    UIButton *button = (UIButton *)sender;
    switch (button.tag) {
        case 1:{
            if (button.selected) {
                button.selected = NO;
                _wifi = 0;
            } else {
                button.selected = YES;
                _wifi = 1;
            }
        }
            break;
        case 2:{
            if (button.selected) {
                button.selected = NO;
                _washingMachine = 0;
            } else {
                button.selected = YES;
                _washingMachine = 1;
            }
        }
            break;
        case 3:{
            if (button.selected) {
                button.selected = NO;
                _television = 0;
            } else {
                button.selected = YES;
                _television = 1;
            }
        }
            break;
        case 4:{
            if (button.selected) {
                button.selected = NO;
                _refrigerator = 0;
            } else {
                button.selected = YES;
                _refrigerator = 1;
            }
        }
            break;
        case 5:{
            if (button.selected) {
                button.selected = NO;
                _heater = 0;
            } else {
                button.selected = YES;
                _heater = 1;
            }
        }
            break;
        case 6:{
            if (button.selected) {
                button.selected = NO;
                _airConditioner = 0;
            } else {
                button.selected = YES;
                _airConditioner = 1;
            }
        }
            break;
        case 7:{
            if (button.selected) {
                button.selected = NO;
                _accessControl = 0;
            } else {
                button.selected = YES;
                _accessControl = 1;
            }
        }
            break;
        case 8:{
            if (button.selected) {
                button.selected = NO;
                _elevator = 0;
            } else {
                button.selected = YES;
                _elevator = 1;
            }
        }
            break;
        case 9:{
            if (button.selected) {
                button.selected = NO;
                _parkingSpace = 0;
            } else {
                button.selected = YES;
                _parkingSpace = 1;
            }
        }
            break;
        case 10:{
            if (button.selected) {
                button.selected = NO;
                _bathtub = 0;
            } else {
                button.selected = YES;
                _bathtub = 1;
            }
        }
            break;
        case 11:{
            if (button.selected) {
                button.selected = NO;
                _keepingPets = 0;
            } else {
                button.selected = YES;
                _keepingPets = 1;
            }
        }
            break;
        case 12:{
            if (button.selected) {
                button.selected = NO;
                _smoking = 0;
            } else {
                button.selected = YES;
                _smoking = 1;
            }
        }
            break;
        case 13:{
            if (button.selected) {
                button.selected = NO;
                _party = 0;
            } else {
                button.selected = YES;
                _party = 1;
            }
        }
            break;
        default:
            break;
    }
    
}
- (void)nextStep {
    HousingAddressAndPriceViewController *viewController = [[UIStoryboard storyboardWithName:@"Personal" bundle:nil] instantiateViewControllerWithIdentifier:@"AddressAndPriceView"];
    NSDictionary *tempDictionary = @{@"wifi" : @(_wifi),
                                     @"washingmachine" : @(_washingMachine),
                                     @"television" : @(_television),
                                     @"refrigerator" : @(_refrigerator),
                                     @"heater" : @(_heater),
                                     @"airconditioner" :@(_airConditioner),
                                     @"accesscontrol" : @(_accessControl),
                                     @"elevator" : @(_elevator),
                                     @"parkingspace" : @(_parkingSpace),
                                     @"bathtub" : @(_bathtub),
                                     @"keepingpets" : @(_keepingPets),
                                     @"smoking" : @(_smoking),
                                     @"paty" : @(_party)};
    //[_informationDictionary setDictionary:tempDictionary];
    [_informationDictionary addEntriesFromDictionary:tempDictionary];
    viewController.informationDictionary = [NSMutableDictionary dictionaryWithDictionary:_informationDictionary];
    
    [self.navigationController pushViewController:viewController animated:YES];
}

@end
