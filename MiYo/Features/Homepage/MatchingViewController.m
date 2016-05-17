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
@property (weak, nonatomic) IBOutlet UITableView *sexTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UIView *backgroundView;
@property (weak, nonatomic) IBOutlet UIView *waveContentView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (strong, nonatomic) UIView *waveView;
@property (strong, nonatomic) UIImage *shadowImage;

@property (strong, nonatomic) NSTimer *timer;
@property (assign, nonatomic) NSInteger timerInt;

@property (assign, nonatomic) BOOL isOpen;
@property (assign, nonatomic) BOOL isMatching;

@property (assign, nonatomic) NSInteger sex;
@end

@implementation MatchingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _shadowImage = self.navigationController.navigationBar.shadowImage;
    self.navigationItem.title = @"";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"setting"] style:UIBarButtonItemStylePlain target:self action:@selector(settingClick)];
    _isOpen = NO;
    _sex = 0;
    [_matchButton setBackgroundImage:[RBColorTool imageWithColor:[Util turnToRGBColor:@"12c1e8"]] forState:UIControlStateNormal];
    [_backgroundView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundViewPress)]];
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[RBColorTool imageWithColor:[Util turnToRGBColor:@"12c1e8"]]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.shadowImage = _shadowImage;
    [_waveView removeFromSuperview];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self setWaveView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)setWaveView {
    CGFloat widthOfWaveContentView = CGRectGetWidth(self.waveContentView.frame);
    CGFloat heightOfWaveContentView = CGRectGetHeight(self.waveContentView.frame);
    _waveView = [[UIView alloc] initWithFrame:CGRectMake(- widthOfWaveContentView / 2, heightOfWaveContentView - widthOfWaveContentView * 1.3, widthOfWaveContentView * 2, widthOfWaveContentView * 2.6)];
    _waveView.layer.backgroundColor = [UIColor clearColor].CGColor;
    [_waveContentView addSubview:_waveView];
}

- (void)showSettingView {
    _isOpen = YES;
    _tableViewHeightConstraint.constant = 120;
    [UIView animateWithDuration:0.2 animations:^{
        [self.view layoutIfNeeded];
    }];
}
- (void)hideSettingView {
    _isOpen = NO;
    _tableViewHeightConstraint.constant = 0;
    [UIView animateWithDuration:0.2 animations:^{
        [self.view layoutIfNeeded];
    }];
}
- (void)beginMatching {
    //CAShapeLayer
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.frame = _waveView.layer.bounds;
    shapeLayer.path = [UIBezierPath bezierPathWithOvalInRect:shapeLayer.bounds].CGPath;
    shapeLayer.fillColor = [Util turnToRGBColor:@"12c1e8"].CGColor;
    shapeLayer.opacity = 0;
    
    //CAReplicatorLayer
    CAReplicatorLayer *replicatorLayer = [CAReplicatorLayer layer];
    replicatorLayer.frame = _waveView.bounds;
    replicatorLayer.instanceCount = 10;  //创建副本数量
    replicatorLayer.instanceDelay = 0.25;
    [replicatorLayer addSublayer:shapeLayer];
    [_waveView.layer addSublayer:replicatorLayer];
    
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.fromValue = @(0.8);
    opacityAnimation.toValue = @(0.0);
    
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    scaleAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DScale(CATransform3DIdentity, 0.2, 0.2, 0.0)];
    scaleAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DScale(CATransform3DIdentity, 1.0, 1.0, 0.0)];
    
    CAAnimationGroup *groupAnimation = [CAAnimationGroup animation];
    groupAnimation.animations = @[opacityAnimation, scaleAnimation];
    groupAnimation.duration = 2.5;
    groupAnimation.autoreverses = NO;
    groupAnimation.repeatCount = HUGE;
    [shapeLayer addAnimation:groupAnimation forKey:@"groupAnimation"];
    
    [self performSelector:@selector(matchingSelector) withObject:nil afterDelay:2.5];
    

}
- (void)matchingSelector {
    [UserModel matchUsersWith:_model.id sex:_sex index:0 handler:^(IndexReulstModel *object, NSString *msg) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        _isMatching = NO;
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
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    if (!_isMatching) {
        [self beginMatching];
        _isMatching = YES;
    }
    
    
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
- (void)backgroundViewPress {
    if (_isOpen) {
        [self hideSettingView];
    }
    
}

@end
