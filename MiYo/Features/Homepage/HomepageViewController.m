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
#import <MJRefresh.h>
#import "IndexReulstModel.h"
#import "HousingDetailViewController.h"
#import "MBProgressHUD+Add.h"
#import "FetchBannerContentRequest.h"
#import <UIImageView+AFNetworking.h>
#import "Util.h"
#import <CoreLocation/CoreLocation.h>
#import "XLBlockAlertView.h"

@interface HomepageViewController ()<UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *topScrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (strong, nonatomic) NSTimer *timer;
@property (strong, nonatomic) NSMutableArray *recommendedArray;
@property (assign, nonatomic) NSInteger index;
@property (copy, nonatomic) NSArray *bannerArray;

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *location;
@property (copy, nonatomic) NSString *cityString;
@property (assign, nonatomic) BOOL isFirstAppear;

@end

@implementation HomepageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(needLogin) name:@"HomepageHaveNotLogin" object:nil];
    _locationManager = [[CLLocationManager alloc] init];
    if ([[UIDevice currentDevice].systemVersion doubleValue] >= 8.0) {
        [_locationManager requestWhenInUseAuthorization];
    }
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    _locationManager.distanceFilter = 10;
    _locationManager.delegate = self;
    [_locationManager startUpdatingLocation];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    _topScrollView.delegate = self;
    _index = 0;
    [_mainTableView setMj_footer:[MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self fetchRecommendedHousing];
    }]];
    _mainTableView.mj_footer.hidden = YES;
    
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"HaveNotLogin" object:nil];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    if (_isFirstAppear) {
        [self fetchRecommendedHousing];
    }
    _isFirstAppear = YES;
    
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}
- (void)viewDidAppear:(BOOL)animated {
    if (_bannerArray.count == 0) {
        [self fetchBannerContent];
    }
    
}
- (void)addTimer {
    _timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(nextPage) userInfo:nil repeats:YES];
}
- (void)nextPage {
    NSInteger page = (NSInteger)_pageControl.currentPage;
    if (page == _bannerArray.count - 1) {
        page = 0;
    } else {
        page ++;
    }
    CGFloat x = page * CGRectGetWidth(_topScrollView.frame);
    [_topScrollView setContentOffset:CGPointMake(x, 0) animated:YES];
    
}
- (void)fetchRecommendedHousing {
    [HousingModel fetchRecommendedHousingWith:_index city:_cityString handler:^(IndexReulstModel *object, NSString *msg) {
        [_mainTableView.mj_footer endRefreshing];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (!msg) {
            if (_index == 0) {
                _recommendedArray = [object.result mutableCopy];
            } else {
                NSMutableArray *tempArray = [_recommendedArray mutableCopy];
                [tempArray addObjectsFromArray:object.result];
                _recommendedArray = tempArray;
            }
            [_mainTableView reloadData];
            BOOL haveMore = object.haveMore;
            if (haveMore) {
                _index = object.index + 1;
                _mainTableView.mj_footer.hidden = NO;
            } else {
                [_mainTableView.mj_footer endRefreshingWithNoMoreData];
                _mainTableView.mj_footer.hidden = YES;
            }
        }
    }];
}
- (void)fetchBannerContent {
    [[FetchBannerContentRequest new] request:^BOOL(id request) {
        return YES;
    } result:^(id object, NSString *msg) {
        if (!msg) {
            _bannerArray = [object copy];
            _pageControl.numberOfPages = _bannerArray.count;
            _pageControl.currentPage = 0;
            if (_topScrollView.subviews.count == 0) {
                for (NSInteger i = 0; i < _bannerArray.count; i ++) {
                    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(_topScrollView.frame) * i, 0, CGRectGetWidth(_topScrollView.frame), CGRectGetHeight(_topScrollView.frame))];
                    [imageView setImageWithURL:[NSURL URLWithString:[Util urlPhoto:_bannerArray[i][@"url"]]] placeholderImage:[UIImage imageNamed:@"default_housing_image"]];
                    imageView.contentMode = UIViewContentModeScaleAspectFill;
                    imageView.clipsToBounds = YES;
                    [_topScrollView addSubview:imageView];
                    
                }
                _topScrollView.contentSize = CGSizeMake(CGRectGetWidth(_topScrollView.frame) * _bannerArray.count, 0);
                if (_bannerArray.count > 1) {
                    [self addTimer];
                }
            }
            
        } else {
            
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - CLLocationManager Delegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    _location = [locations lastObject];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:_location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (!error && [placemarks count] > 0) {
            CLPlacemark *placemark = [placemarks objectAtIndex:0];
            NSDictionary *information = placemark.addressDictionary;
            _cityString = @"";
            if (![Util isEmpty:information[@"State"]]) {
                _cityString = [NSString stringWithFormat:@"%@%@", _cityString, information[@"State"]];
            }
            if (![Util isEmpty:information[@"City"]]) {
                _cityString = [NSString stringWithFormat:@"%@%@", _cityString, information[@"City"]];
            }
        } else {
            _cityString = nil;
        }
        [self fetchRecommendedHousing];
    }];

    [_locationManager stopUpdatingLocation];
}
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:{
            if([_locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]){
                [_locationManager requestWhenInUseAuthorization];
            }
        }
            break;
            
        case kCLAuthorizationStatusDenied:{
            [[[XLBlockAlertView alloc] initWithTitle:@"提示" message:@"请在设置-隐私-定位服务中开启定位功能！" block:^(NSInteger buttonIndex) {
            } cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
            [self fetchRecommendedHousing];
        }
            break;
            
        case kCLAuthorizationStatusRestricted:{
            [[[XLBlockAlertView alloc] initWithTitle:@"提示" message:@"定位服务无法使用！" block:^(NSInteger buttonIndex) {
            } cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
            [self fetchRecommendedHousing];
        }
            
        default:
            [self fetchRecommendedHousing];
            break;
            
    }
}

#pragma mark - UIScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == _topScrollView) {
        CGFloat pageWidth = CGRectGetWidth(scrollView.frame);
        //_pageControl.currentPage = floor(scrollView.contentOffset.x / CGRectGetWidth(scrollView.frame));
        NSInteger page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
        _pageControl.currentPage = page;
    }
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (scrollView == _topScrollView) {
        [_timer invalidate];
    }
    
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (scrollView == _topScrollView) {
        [self addTimer];
    }
    
}
#pragma mark - UITableView Delegate DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _recommendedArray.count;
}
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 150;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"HousingSourceCell";
    HousingResourceCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[HousingResourceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    HousingModel *model = _recommendedArray[indexPath.row];
    [cell setupDataWith:model];
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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (![Util isLogin]) {
        [self needLogin];
    } else {
        HousingModel *temp = _recommendedArray[indexPath.row];
        HousingDetailViewController *detailViewController = [[UIStoryboard storyboardWithName:@"Homepage" bundle:nil] instantiateViewControllerWithIdentifier:@"HousingDetailView"];
        detailViewController.simpleModel = temp;
        detailViewController.housingId = temp.id;
        [self.navigationController pushViewController:detailViewController animated:YES];
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
//- (IBAction)login:(id)sender {
//    LoginViewController *loginView = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateViewControllerWithIdentifier:@"LoginView"];
//    loginView.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:loginView animated:YES];
//}
- (void)needLogin {
    LoginViewController *loginView = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateViewControllerWithIdentifier:@"LoginView"];
    loginView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:loginView animated:YES];
}

@end
