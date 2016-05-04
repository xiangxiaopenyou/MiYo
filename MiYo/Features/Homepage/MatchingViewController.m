//
//  MatchingViewController.m
//  MiYo
//
//  Created by 项小盆友 on 16/4/30.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "MatchingViewController.h"
#import "RBColorTool.h"
#import "Util.h"
#import "MBProgressHUD+Add.h"
#import "UserModel.h"
#import "IndexReulstModel.h"
#import "MatchResultViewController.h"

@interface MatchingViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *matchButton;
@property (weak, nonatomic) IBOutlet UIImageView *matchImageView;
@property (weak, nonatomic) IBOutlet UITableView *sexTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UIView *backgroundView;
@property (strong, nonatomic) NSTimer *timer;
@property (assign, nonatomic) NSInteger timerInt;

@property (assign, nonatomic) BOOL isOpen;

@property (assign, nonatomic) NSInteger sex;
@end

@implementation MatchingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"匹配";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"setting"] style:UIBarButtonItemStylePlain target:self action:@selector(settingClick)];
    _isOpen = NO;
    _sex = 0;
    [_matchButton setBackgroundImage:[RBColorTool imageWithColor:[Util turnToRGBColor:@"12c1e8"]] forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)showSettingView {
    _isOpen = YES;
    _backgroundView.hidden = NO;
    _tableViewHeightConstraint.constant = 120;
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    }];
}
- (void)hideSettingView {
    _isOpen = NO;
    _backgroundView.hidden = YES;
    _tableViewHeightConstraint.constant = 0;
    [UIView animateWithDuration:0.6 animations:^{
        [self.view layoutIfNeeded];
    }];
}
- (void)beginMatching {
    [UserModel matchUsersWith:_model.id sex:_sex index:0 handler:^(IndexReulstModel *object, NSString *msg) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (!msg) {
            NSArray *tempArray = [object.result copy];
            if (tempArray.count > 0) {
                MatchResultViewController *resultViewController = [[UIStoryboard storyboardWithName:@"Homepage" bundle:nil] instantiateViewControllerWithIdentifier:@"MatchResultView"];
                resultViewController.indexModel = object;
                resultViewController.housingModel = _model;
                [self.navigationController pushViewController:resultViewController animated:YES];
            } else {
                [MBProgressHUD showError:@"暂无匹配结果" toView:self.view];
            }
        } else {
            [MBProgressHUD showError:@"匹配错误" toView:self.view];
        }
    }];
}

#pragma mark - UITableView Delegate DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
    textLabel.textAlignment = NSTextAlignmentCenter;
    textLabel.font = kSystemFont(15);
    switch (indexPath.row) {
        case 0: {
            textLabel.text = @"不限";
        }
            break;
        case 1: {
            textLabel.text = @"仅限男";
        }
            break;
        case 2: {
            textLabel.text = @"仅限女";
        }
            break;
            
        default:
            break;
    }
    if (indexPath.row == _sex) {
        textLabel.textColor = [Util turnToRGBColor:@"12c1e8"];
        cell.backgroundColor = [UIColor whiteColor];
    } else {
        textLabel.textColor = [UIColor whiteColor];
        cell.backgroundColor = [Util turnToRGBColor:@"12c1e8"];
    }
    [cell.contentView addSubview:textLabel];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    _sex = indexPath.row;
    [tableView reloadData];
    [self hideSettingView];
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)matchClick:(id)sender {
//    _timerInt = 0;
//    _timer = [NSTimer scheduledTimerWithTimeInterval:0.39 target:self selector:@selector(matchingSelector) userInfo:nil repeats:YES];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self beginMatching];
    
}
//- (void)matchingSelector {
//    CGFloat rotation = _timerInt * 0.25 * M_PI;
//    [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
//        _matchImageView.transform = CGAffineTransformMakeRotation(rotation);
//    } completion:nil];
//    _timerInt += 1;
//}
- (void)settingClick {
    if (_isOpen) {
        [self hideSettingView];
    } else {
        
        [self showSettingView];
    }
}

@end
