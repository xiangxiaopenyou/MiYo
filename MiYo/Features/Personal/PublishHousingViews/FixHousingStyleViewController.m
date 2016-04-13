//
//  FixHousingStyleViewController.m
//  MiYo
//
//  Created by 项小盆友 on 16/4/10.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "FixHousingStyleViewController.h"
#import "HousingFacilitiesViewController.h"

@interface FixHousingStyleViewController ()
@property (weak, nonatomic) IBOutlet UITextField *roomNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *livingRoomNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *toiletNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *balconyNumberTextField;

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
- (void)nextStep {
    HousingFacilitiesViewController *viewController = [[UIStoryboard storyboardWithName:@"Personal" bundle:nil] instantiateViewControllerWithIdentifier:@"HousingFacilitiesView"];
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

@end
