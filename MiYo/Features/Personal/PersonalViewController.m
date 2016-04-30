//
//  PersonalViewController.m
//  MiYo
//
//  Created by 项小盆友 on 16/3/17.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "PersonalViewController.h"
#import "CommonsDefines.h"
#import "Util.h"
#import "SettingViewController.h"
#import <UIImageView+AFNetworking.h>
#import "MyHousingViewController.h"

@interface PersonalViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *headBackgroundImage;
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UIButton *becomeOwnerButton;
@property (weak, nonatomic) IBOutlet UILabel *nicknameLabel;

@property (copy, nonatomic) NSArray *informationArray;

@end

@implementation PersonalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [self.navigationController.navigationBar setBarTintColor:[Util turnToRGBColor:@"12c1e8"]];
//    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
//    [self.navigationController.navigationBar setTitleTextAttributes: @{
//                                                                       NSForegroundColorAttributeName: [UIColor whiteColor],
//                                                                       NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0f]
//                                                                       }];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(editInformationSuccess) name:@"EditInformationSuccess" object:nil];
    _informationArray = @[@"完善信息", @"我的发布", @"设置"];
    
    _becomeOwnerButton.layer.masksToBounds = YES;
    _becomeOwnerButton.layer.cornerRadius = 2.0;
    
    _headImage.layer.masksToBounds = YES;
    _headImage.layer.cornerRadius = 29.0;
    _headImage.layer.borderWidth = 2.0;
    _headImage.layer.borderColor = kRGBColor(255, 255, 255, 0.4).CGColor;
    
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"EditInformationSuccess" object:nil];
}
- (void)setupContent {
    NSString *nicknameString = [[NSUserDefaults standardUserDefaults] stringForKey:NICKNAME];
    self.nicknameLabel.text = [NSString stringWithFormat:@"%@", nicknameString];
    
    NSString *portraitString = [[NSUserDefaults standardUserDefaults] stringForKey:PORTRAIT];
    [self.headImage setImageWithURL:[NSURL URLWithString:[Util urlZoomPhoto:portraitString]] placeholderImage:[UIImage imageNamed:@"default_portrait"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    [self setupContent];
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

#pragma mark - UITableView Delegate DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"InformationCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.text = _informationArray[indexPath.row];
    cell.textLabel.font = kSystemFont(16);
    cell.textLabel.textColor = [Util turnToRGBColor:@"323232"];
    cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"personal0%@", @(indexPath.row + 1)]];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:{
            UIViewController *informationEditViewController = [[UIStoryboard storyboardWithName:@"Personal" bundle:nil] instantiateViewControllerWithIdentifier:@"InformationEditView"];
            [self.navigationController pushViewController:informationEditViewController animated:YES];
        }

            break;
        case 1:{
            MyHousingViewController *myHousingViewControlelr = [[UIStoryboard storyboardWithName:@"Personal" bundle:nil] instantiateViewControllerWithIdentifier:@"MyHousingView"];
            [self.navigationController pushViewController:myHousingViewControlelr animated:YES];
        }
            break;
        case 2:{
            UIViewController *settingViewController = [[UIStoryboard storyboardWithName:@"Personal" bundle:nil] instantiateViewControllerWithIdentifier:@"SettingView"];
            [self.navigationController pushViewController:settingViewController animated:YES];
        }
            break;
        default:
            break;
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)editInformationSuccess {
    [self setupContent];
}
- (IBAction)becomeOwnerClick:(id)sender {
}

@end
