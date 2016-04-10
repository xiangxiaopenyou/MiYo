//
//  HomepageViewController.m
//  MiYo
//
//  Created by 项小盆友 on 16/3/17.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "HomepageViewController.h"
#import "LoginRequest.h"
#import "LoginViewController.h"
#import "CommonsDefines.h"
#import "HousingResourceCell.h"
#import "HousingModel.h"
#import "Util.h"

@interface HomepageViewController ()<UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *topScrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (strong, nonatomic) NSTimer *timer;

@end

@implementation HomepageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController.navigationBar setBarTintColor:[Util turnToRGBColor:@"12c1e8"]];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTitleTextAttributes: @{
                                                                       NSForegroundColorAttributeName: [UIColor whiteColor],
                                                                       NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0f]
                                                                       }];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(needLogin) name:@"HaveNotLogin" object:nil];
    _topScrollView.delegate = self;
    _pageControl.numberOfPages = 5;
    _pageControl.currentPage = 0;
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}
- (void)viewDidAppear:(BOOL)animated {
    for (NSInteger i = 0; i < 5; i ++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(_topScrollView.frame) * i, 0, CGRectGetWidth(_topScrollView.frame), CGRectGetHeight(_topScrollView.frame))];
        if (i % 2 == 0) {
            imageView.backgroundColor = [UIColor redColor];
        } else {
            imageView.backgroundColor = [UIColor greenColor];
        }
        imageView.clipsToBounds = YES;
        [_topScrollView addSubview:imageView];
        
    }
    _topScrollView.contentSize = CGSizeMake(CGRectGetWidth(_topScrollView.frame) * 5, 0);
    [self addTimer];
}
- (void)addTimer {
    _timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(nextPage) userInfo:nil repeats:YES];
}
- (void)nextPage {
    NSInteger page = (NSInteger)_pageControl.currentPage;
    if (page == 4) {
        page = 0;
    } else {
        page ++;
    }
    CGFloat x = page * CGRectGetWidth(_topScrollView.frame);
    _topScrollView.contentOffset = CGPointMake(x, 0);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat pageWidth = CGRectGetWidth(scrollView.frame);
    //_pageControl.currentPage = floor(scrollView.contentOffset.x / CGRectGetWidth(scrollView.frame));
    NSInteger page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    _pageControl.currentPage = page;
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [_timer invalidate];
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self addTimer];
}
#pragma mark - UITableView Delegate DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 130;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"HousingSourceCell";
    HousingResourceCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[HousingResourceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    [cell setupDataWith:[HousingModel new]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 25;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 25)];
    headView.backgroundColor = kRGBColor(250, 250, 250, 1.0);
    UILabel *headLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH, 25)];
    headLabel.text = @"推荐房源";
    headLabel.font = kSystemFont(14);
    headLabel.textColor = kRGBColor(144, 144, 144, 1.0);
    [headView addSubview:headLabel];
    return headView;
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)login:(id)sender {
    LoginViewController *loginView = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateViewControllerWithIdentifier:@"LoginView"];
    loginView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:loginView animated:YES];
}
- (void)needLogin {
    LoginViewController *loginView = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateViewControllerWithIdentifier:@"LoginView"];
    loginView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:loginView animated:YES];
}

@end
