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

@interface PersonalViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *headBackgroundImage;
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UIButton *becomeOwnerButton;

@property (copy, nonatomic) NSArray *informationArray;

@end

@implementation PersonalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController.navigationBar setBarTintColor:[Util turnToRGBColor:@"12c1e8"]];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTitleTextAttributes: @{
                                                                       NSForegroundColorAttributeName: [UIColor whiteColor],
                                                                       NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0f]
                                                                       }];
    _informationArray = @[@"完善信息", @"我的收藏", @"我的发布"];
    _becomeOwnerButton.layer.masksToBounds = YES;
    _becomeOwnerButton.layer.cornerRadius = 2.0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = YES;
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
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)becomeOwnerClick:(id)sender {
}

@end
