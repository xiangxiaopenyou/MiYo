//
//  ChooseHousingTypeViewController.m
//  MiYo
//
//  Created by 项小盆友 on 16/4/10.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "ChooseHousingTypeViewController.h"
#import "FixHousingStyleViewController.h"

@interface ChooseHousingTypeViewController ()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation ChooseHousingTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"发布房源";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView Delegate DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 65;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"HousingTypeCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"housing_type%@", @(indexPath.row + 1)]];
    if (indexPath.row == 0) {
        cell.textLabel.text = @"整租";
        cell.detailTextLabel.text = @"出租您的整套房子";
    } else {
        cell.textLabel.text = @"合租";
        cell.detailTextLabel.text = @"出租您的单间房子";
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    FixHousingStyleViewController *viewController = [[UIStoryboard storyboardWithName:@"Personal" bundle:nil] instantiateViewControllerWithIdentifier:@"FixHousingStyleView"];
    [self.navigationController pushViewController:viewController animated:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
