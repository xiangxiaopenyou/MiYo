//
//  HousingAddressChooseViewController.m
//  MiYo
//
//  Created by 项小盆友 on 16/4/14.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "HousingAddressChooseViewController.h"
#import "CommonsDefines.h"
#import "Util.h"
#import "XLBlockAlertView.h"

@interface HousingAddressChooseViewController ()<CLLocationManagerDelegate, MAMapViewDelegate, AMapSearchDelegate, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>
@property (strong, nonatomic) MAMapView *mapView;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIImageView *centerImage;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (assign, nonatomic) CLLocationCoordinate2D locationCoordinate;
@property (strong, nonatomic) AMapSearchAPI *search;
@property (copy, nonatomic) NSString *addressString;
@property (copy, nonatomic) NSArray *poiArray;
@property (copy, nonatomic) NSArray *searchResultArray;
@property (strong, nonatomic) UISearchBar *searchBar;
@property (strong, nonatomic) UITableView *searchTableView;
@property (copy, nonatomic) NSString *selectedCityCode;

@property (assign, nonatomic) BOOL isKeywordSearch;

@end

@implementation HousingAddressChooseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [MAMapServices sharedServices].apiKey = MAPKEY;
    [AMapSearchServices sharedServices].apiKey = MAPKEY;
//    [self.navigationController.navigationBar setBarTintColor:[Util turnToRGBColor:@"12c1e8"]];
//    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
//    [self.navigationController.navigationBar setTitleTextAttributes: @{
//                                                                       NSForegroundColorAttributeName: [UIColor whiteColor],
//                                                                       NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0f]
//                                                                       }];
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 45, 40)];
    _searchBar.tintColor = [Util turnToRGBColor:@"12c1e8"];
    _searchBar.placeholder = @"查找小区/大厦等";
    _searchBar.delegate = self;
    _searchBar.returnKeyType = UIReturnKeySearch;
    self.navigationItem.titleView = _searchBar;
    
    //self.navigationItem.title = @"选择位置";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_back"] style:UIBarButtonItemStylePlain target:self action:@selector(backClick)];
    
    
    self.mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT / 2)];
    [self.view addSubview:self.mapView];
    self.mapView.delegate = self;
    self.mapView.userTrackingMode = MAUserTrackingModeFollow;
    self.mapView.mapType = MAMapTypeStandard;
    self.mapView.showsCompass = NO;
    [self.mapView setZoomLevel:17.5];
    
    _centerImage = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2 - 15, 36 + SCREEN_HEIGHT / 4, 30, 30)];
    _centerImage.image = [UIImage imageNamed:@"map_center"];
    [self.view addSubview:_centerImage];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64 + SCREEN_HEIGHT / 2, SCREEN_WIDTH, SCREEN_HEIGHT / 2 - 64)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [UIView new];
    [self.view addSubview:_tableView];
    
    _searchTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    _searchTableView.delegate = self;
    _searchTableView.dataSource = self;
    _searchTableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    _searchTableView.tableFooterView = [UIView new];
    [self.view addSubview:_searchTableView];
    _searchTableView.hidden = YES;
    //}
    //[self performSelector:@selector(canDragSelector) withObject:nil afterDelay:0.3];
    _locationManager = [[CLLocationManager alloc] init];
    if ([[UIDevice currentDevice].systemVersion doubleValue] >= 8.0) {
        [_locationManager requestWhenInUseAuthorization];
    }
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    _locationManager.distanceFilter = 10;
    _locationManager.delegate = self;
    [_locationManager startUpdatingLocation];
    _isKeywordSearch = NO;
    
    
}
//- (void)canDragSelector {
//    _canDrag = YES;
//}
//- (void)getAddressInformation:(CLLocation *)location {
//    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
//    [geocoder reverseGeocodeLocation:_location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
//        if (!error && [placemarks count] > 0) {
//            CLPlacemark *placemark = [placemarks objectAtIndex:0];
//        } else if (error == nil && [placemarks count] == 0){
//            NSLog(@"No results were returned.");
//        } else {
//            NSLog(@"An error occurred = %@", error);
//        }
//    }];
//}
- (void)searchAround:(CGFloat)latitude longitude:(CGFloat)longitude {
    if (!_search){
        _search = [[AMapSearchAPI alloc] init];
        _search.delegate = self;
    }
    AMapPOIAroundSearchRequest *request = [[AMapPOIAroundSearchRequest alloc] init];
    request.location = [AMapGeoPoint locationWithLatitude:latitude longitude:longitude];
    request.sortrule = 0;
    request.requireExtension = YES;
    [_search AMapPOIAroundSearch:request];

}
- (void)searchWithKeyword:(NSString *)keyword {
    if (!_search){
        _search = [[AMapSearchAPI alloc] init];
        _search.delegate = self;
    }
    AMapPOIKeywordsSearchRequest *request = [[AMapPOIKeywordsSearchRequest alloc] init];
    request.keywords = keyword;
    if (_selectedCityCode) {
        request.city = _selectedCityCode;
    }
    request.requireExtension = YES;
    [_search AMapPOIKeywordsSearch:request];
}



 
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - CLLocationManager Delegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    _location = [locations lastObject];
    //[self getAddressInformation:_location];
    _isKeywordSearch = NO;
    [self searchAround:_location.coordinate.latitude longitude:_location.coordinate.longitude];
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
        }
            break;
            
        case kCLAuthorizationStatusRestricted:{
            [[[XLBlockAlertView alloc] initWithTitle:@"提示" message:@"定位服务无法使用！" block:^(NSInteger buttonIndex) {
            } cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
        }
            
        default:
            
            break;
            
    }
}
#pragma mark - AMapSearch Delegate
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response {
    if (response.pois.count == 0) {
        return;
    }
    AMapPOI *point = response.pois[0];
    _selectedCityCode = point.city;
    if (_isKeywordSearch) {
        _searchResultArray = [response.pois copy];
        [_searchTableView reloadData];
    } else {
        _poiArray = [response.pois copy];
        [_tableView reloadData];
    }
    
}

#pragma mark - UISearchBar Delegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    _searchTableView.hidden = NO;
    return YES;
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText.length > 0) {
        _isKeywordSearch = YES;
        [self searchWithKeyword:searchText];
    }
}
- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        if (_searchBar.text.length > 0) {
            _isKeywordSearch = YES;
            [self searchWithKeyword:_searchBar.text];
        }
        [_searchBar resignFirstResponder];
    }
    return YES;
}

#pragma mark - MAMapView Delegate
- (void)mapView:(MAMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    
    
}
- (void)mapView:(MAMapView *)mapView mapDidMoveByUser:(BOOL)wasUserAction {
    if (wasUserAction) {
        _isKeywordSearch = NO;
        _locationCoordinate = mapView.region.center;
        [self searchAround:_locationCoordinate.latitude longitude:_locationCoordinate.longitude];
        [UIView animateWithDuration:0.3 delay:0.2 usingSpringWithDamping:0.5 initialSpringVelocity:10 options:UIViewAnimationOptionCurveEaseIn animations:^{
            _centerImage.frame = CGRectMake(SCREEN_WIDTH / 2 - 5, 27 + SCREEN_HEIGHT / 4, 30, 30);
            [UIView animateWithDuration:0.2 delay:0.4 options:UIViewAnimationOptionCurveEaseOut animations:^{
                _centerImage.frame = CGRectMake(SCREEN_WIDTH / 2 - 5, 36 + SCREEN_HEIGHT / 4, 30, 30);
            } completion:nil];
        } completion:^(BOOL finished) {
        }];
    }
    
}
#pragma mark - UITableView delegate & DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == _tableView) {
        return _poiArray.count;
    } else {
        return _searchResultArray.count;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    AMapPOI *point;
    if (tableView == _tableView) {
        point = _poiArray[indexPath.row];
        cell.imageView.image = [UIImage imageNamed:@"map_position"];
    } else {
        point = _searchResultArray[indexPath.row];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%@", point.name];
    cell.textLabel.font = kSystemFont(16);
    cell.textLabel.textColor = [Util turnToRGBColor:@"12c1e8"];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", point.address];
    cell.detailTextLabel.font = kSystemFont(12);
    cell.detailTextLabel.textColor = [UIColor lightGrayColor];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    AMapPOI *point;
    if (tableView == _tableView) {
        point = _poiArray[indexPath.row];
    } else {
        point = _searchResultArray[indexPath.row];
    }
    if (self.addressBlock) {
        self.addressBlock(point);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)addressChosen:(ChooseAddressBlock)block {
    self.addressBlock = block;
}

- (void)backClick {
    if (_searchTableView.hidden) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [_searchBar resignFirstResponder];
        _searchTableView.hidden = YES;
        _searchBar.text = nil;
    }
    
}

@end
