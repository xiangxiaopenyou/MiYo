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
#import <UIImageView+AFNetworking.h>
#import <SVProgressHUD.h>

@interface MatchingViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *matchButton;
@property (weak, nonatomic) IBOutlet UITableView *sexTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UIView *backgroundView;
@property (weak, nonatomic) IBOutlet UIView *waveContentView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIView *resultView;
@property (weak, nonatomic) IBOutlet UILabel *resultHousingLabel;
@property (weak, nonatomic) IBOutlet UILabel *resultNoHousingLabel;
@property (strong, nonatomic) UIView *waveView;
@property (strong, nonatomic) UIImage *shadowImage;
@property (strong, nonatomic) UIImageView *portraitImageView;

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
    [_backgroundView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundViewPress)]];
    [_waveContentView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundViewPress)]];
    _sexTableView.layer.masksToBounds = YES;
    _sexTableView.layer.cornerRadius = 10.0;
    
    [_resultView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideResultView)]];
    
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
    _tableViewHeightConstraint.constant = 140;
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
    //[self setWaveView];
    
    //CAShapeLayer
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.frame = _waveView.layer.bounds;
    shapeLayer.path = [UIBezierPath bezierPathWithOvalInRect:shapeLayer.bounds].CGPath;
    shapeLayer.fillColor = kRGBColor(0, 150, 180, 1.0).CGColor;
    shapeLayer.opacity = 0;
    
    //CAReplicatorLayer
    CAReplicatorLayer *replicatorLayer = [CAReplicatorLayer layer];
    replicatorLayer.frame = _waveView.bounds;
    replicatorLayer.instanceCount = 10;  //创建副本数量
    replicatorLayer.instanceDelay = 0.25;
    [replicatorLayer addSublayer:shapeLayer];
    [_waveView.layer addSublayer:replicatorLayer];
    
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.fromValue = @(0.9);
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
    
    [self performSelector:@selector(matchingSelector) withObject:nil afterDelay:4];
    
//    if (!_portraitImageView) {
//        _portraitImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2 - 35, 70, 70, 70)];
//        _portraitImageView.layer.masksToBounds = YES;
//        _portraitImageView.layer.cornerRadius = 35.0;
//        NSString *portraitString = [[NSUserDefaults standardUserDefaults] stringForKey:PORTRAIT];
//        [_portraitImageView setImageWithURL:[NSURL URLWithString:[Util urlZoomPhoto:portraitString]] placeholderImage:[UIImage imageNamed:@"default_portrait"]];
//        [self.view addSubview:_portraitImageView];
//    }
//    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(portraitChanged) userInfo:nil repeats:YES];
    //[_timer fire];

}
- (void)matchingSelector {
    if (!_isMatchHousingsAndFriends) {
        [UserModel matchUsersWith:_model.id sex:_sex index:0 handler:^(IndexReulstModel *object, NSString *msg) {
            //[MBProgressHUD hideHUDForView:self.view animated:YES];
            [SVProgressHUD dismiss];
            _isMatching = NO;
//            [_timer invalidate];
//            _timer = nil;
//            [_portraitImageView removeFromSuperview];
//            _portraitImageView = nil;
            if (!msg) {
                NSArray *tempArray = [object.result copy];
                if (tempArray.count > 0) {
                    MatchResultViewController *resultViewController = [[UIStoryboard storyboardWithName:@"Homepage" bundle:nil] instantiateViewControllerWithIdentifier:@"MatchResultView"];
                    resultViewController.indexModel = object;
                    resultViewController.housingModel = _model;
                    [self.navigationController pushViewController:resultViewController animated:YES];
                    //_resultView.hidden = NO;
                    self.navigationItem.rightBarButtonItem.enabled = NO;
                    //[_waveView removeFromSuperview];
                } else {
                    [MBProgressHUD showError:@"暂无匹配结果" toView:self.view];
                    [_waveView removeFromSuperview];
                }
            } else {
                [MBProgressHUD showError:@"匹配错误" toView:self.view];
                [_waveView removeFromSuperview];
            }
        }];

    } else {
    }
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
    cell.backgroundColor = kRGBColor(250, 250, 250, 1.0);
    if (indexPath.row == _sex) {
        textLabel.textColor = [Util turnToRGBColor:@"12c1e8"];
        
    } else {
        textLabel.textColor = [UIColor grayColor];
        //cell.backgroundColor = [Util turnToRGBColor:@"12c1e8"];
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
        //[self beginMatching];
        [SVProgressHUD show];
        [self performSelector:@selector(matchingSelector) withObject:nil afterDelay:2];
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
//- (void)portraitChanged {
//    NSInteger maxX = SCREEN_WIDTH - 89;
//    NSInteger x = (arc4random() % maxX) + 10;
//    NSInteger maxY = SCREEN_HEIGHT - 199;
//    NSInteger y = (arc4random() % maxY) + 70;
//    _portraitImageView.frame = CGRectMake(x, y, 70, 70);
//    
//}
- (IBAction)resultHousingClick:(id)sender {
    _resultView.hidden = YES;
    self.navigationItem.rightBarButtonItem.enabled = YES;
}
- (IBAction)resultNoHousingClick:(id)sender {
    _resultView.hidden = YES;
    self.navigationItem.rightBarButtonItem.enabled = YES;
    
}
- (void)hideResultView {
    _resultView.hidden = YES;
    self.navigationItem.rightBarButtonItem.enabled = YES;
}

@end
