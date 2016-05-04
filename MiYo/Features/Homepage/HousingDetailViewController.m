//
//  HousingDetailViewController.m
//  MiYo
//
//  Created by 项小盆友 on 16/4/3.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "HousingDetailViewController.h"
#import <UIImageView+AFNetworking.h>
#import "Util.h"
#import "HousingTitleCell.h"
#import "HousingSituationCell.h"
#import "HousingFacilityCell.h"
#import <MapKit/MapKit.h>
#import "FetchHousingImagesRequest.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"
#import "HousingCollectRequest.h"
#import "HousingCancelCollectRequest.h"
#import "MatchingViewController.h"
#import "UserCardViewController.h"


@interface HousingDetailViewController ()<UITableViewDelegate, UITableViewDataSource, MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *mainImageView;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *viewNumberLabel;
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UIButton *zhengzuButton;
@property (weak, nonatomic) IBOutlet UIButton *hezuButton;
@property (strong, nonatomic) HousingModel *housingModel;
@property (strong, nonatomic) UIButton *collectButton;
@property (copy, nonatomic) NSArray *imageArray;

@end

@implementation HousingDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"房源";
    if (self.simpleModel) {
        [self setupHeaderView];
    }
    [self fetchHousingDetail];
    //[self fetchHousingImages];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}
- (void)setupHeaderView {
    _viewNumberLabel.text = [NSString stringWithFormat:@"%@", self.simpleModel.clickcount];
//    [_mainImageView setImageWithURL:[NSURL URLWithString:[Util urlPhoto:self.simpleModel.image]] placeholderImage:[UIImage imageNamed:@"default_housing_image"]];
    _priceLabel.text = [NSString stringWithFormat:@"￥%@/月", self.simpleModel.price];
    _imageArray = [Util toArray:self.simpleModel.image];
    if (_imageArray.count > 0) {
        [_mainImageView setImageWithURL:[NSURL URLWithString:[Util urlPhoto:_imageArray[0]]] placeholderImage:[UIImage imageNamed:@"default_housing_image"]];
    } else {
        _mainImageView.image = [UIImage imageNamed:@"default_housing_image"];
    }
    
}
- (void)showLocation {
    self.mapView.showsUserLocation = YES;
//    [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake([_housingModel.address_y floatValue], [_housingModel.address_x floatValue])];
    MKCoordinateSpan span = MKCoordinateSpanMake(0.01, 0.01);
    [self.mapView setRegion:MKCoordinateRegionMake(CLLocationCoordinate2DMake([_housingModel.address_y floatValue], [_housingModel.address_x floatValue]), span)];
    self.mapView.delegate = self;
    _addressLabel.text = [NSString stringWithFormat:@"%@", _housingModel.address];
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    annotation.coordinate = CLLocationCoordinate2DMake([_housingModel.address_y floatValue], [_housingModel.address_x floatValue]);
    annotation.title = _housingModel.addressname;
    [self.mapView addAnnotation:annotation];

    
}
- (void)addCollectButton {
    self.collectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.collectButton.frame = CGRectMake(0, 0, 30, 30);
    [self.collectButton setImage:[UIImage imageNamed:@"collected"] forState:UIControlStateSelected];
    [self.collectButton setImage:[UIImage imageNamed:@"colloct"] forState:UIControlStateNormal];
    if ([_housingModel.iscollect integerValue] == 1) {
        self.collectButton.selected = YES;
    } else {
        self.collectButton.selected = NO;
    }
    [self.collectButton addTarget:self action:@selector(collectButtonClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.collectButton];
}
- (void)fetchHousingDetail {
    [HousingModel fetchHousingDetailWith:self.housingId handler:^(id object, NSString *msg) {
        if (!msg) {
            _housingModel = [object copy];
            _zhengzuButton.enabled = YES;
            if ([_housingModel.isflatshare integerValue] == 1) {
                _hezuButton.enabled = NO;
            } else {
                _hezuButton.enabled = YES;
            }
            [_mainTableView reloadData];
            [self addCollectButton];
            [self showLocation];
            if (!_simpleModel) {
                _viewNumberLabel.text = [NSString stringWithFormat:@"%@", _housingModel.clickcount];
                _imageArray = [Util toArray:_housingModel.image];
                if (_imageArray.count > 0) {
                    [_mainImageView setImageWithURL:[NSURL URLWithString:[Util urlPhoto:_imageArray[0]]] placeholderImage:[UIImage imageNamed:@"default_housing_image"]];
                } else {
                    _mainImageView.image = [UIImage imageNamed:@"default_housing_image"];
                }
                _priceLabel.text = [NSString stringWithFormat:@"￥%@/月", _housingModel.price];
            }
            if (_imageArray.count > 0) {
                _mainImageView.userInteractionEnabled = YES;
                [_mainImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageRecognizer:)]];
            }
        }
    }];
}
//- (void)fetchHousingImages {
//    [[FetchHousingImagesRequest new] request:^BOOL(FetchHousingImagesRequest *request) {
//        request.houseId = _housingId;
//        return YES;
//    } result:^(id object, NSString *msg) {
//        if (!msg) {
//            _imageArray = [object copy];
//            if (_imageArray.count > 0) {
//                _mainImageView.userInteractionEnabled = YES;
//                [_mainImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageRecognizer:)]];
//            }
//        }
//    }];
//}


#pragma mark - UITableView Delegate DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:{
            return [[HousingTitleCell new] heightOfCell:self.housingModel];
        }
            break;
        case 1:
            return 145;
            break;
        case 2:
            return 310;
            break;
        default:
            return 0;
            break;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:{
            static NSString *cellIdentifier = @"TitleCell";
            HousingTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (!cell) {
                cell = [[HousingTitleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell setupContentWith:self.housingModel];
            return cell;
        }
            break;
        case 1:{
            static NSString *cellIdentifier = @"SituationCell";
            HousingSituationCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (!cell) {
                cell = [[HousingSituationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell setupContentWith:self.housingModel];
            return cell;
        }
            break;
        case 2:{
            static NSString *cellIdentifier = @"FacilityCell";
            HousingFacilityCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (!cell) {
                cell = [[HousingFacilityCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell setupContentWith:self.housingModel];
            return cell;
        }
            break;
            
        default:
            return nil;
            break;
    }
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        if (indexPath.row == 2) {
            [cell setSeparatorInset:UIEdgeInsetsMake(0, SCREEN_WIDTH, 0, 0)];
        } else {
            [cell setSeparatorInset:UIEdgeInsetsMake(0, 35, 0, 35)];
        }
        
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        if (indexPath.row == 2) {
            [cell setLayoutMargins:UIEdgeInsetsMake(0, SCREEN_WIDTH, 0, 0)];
        } else {
            [cell setLayoutMargins:UIEdgeInsetsMake(0, 35, 0, 35)];
        }
    }
}

#pragma mark - MKMapView Delegate
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        MKPinAnnotationView * annotationView = (MKPinAnnotationView *)[_mapView dequeueReusableAnnotationViewWithIdentifier:@"PIN_ANNOTATION"];
        if (annotationView == nil) {
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"PIN_ANNOTATION"];
        }
        annotationView.pinColor = MKPinAnnotationColorRed;
        // 标注地图时 是否以动画的效果形式显示在地图上
        annotationView.animatesDrop = YES;
        // 用于标注点上的一些附加信息
        annotationView.canShowCallout = YES;
        
        return annotationView;
    } else {
        MKAnnotationView *annotationView = [[MKAnnotationView alloc] init];
        annotationView.image = [UIImage imageNamed:@"map_center"];
        annotationView.canShowCallout = YES;
        return annotationView;
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
- (void)collectButtonClick {
    if ([_housingModel.iscollect integerValue] == 1) {
        [[HousingCancelCollectRequest new] request:^BOOL(HousingCancelCollectRequest *request) {
            request.houseingId = _housingId;
            return YES;
        } result:nil];
        self.collectButton.selected = NO;
        _housingModel.iscollect = @(0);
    } else {
        [[HousingCollectRequest new] request:^BOOL(HousingCollectRequest *request) {
            request.housingId = _housingId;
            return YES;
        } result:nil];
        self.collectButton.selected = YES;
        _housingModel.iscollect = @(1);
    }
}
- (IBAction)zhengzuButtonClick:(id)sender {
    if (![Util isEmpty:_housingModel.userid]) {
        UserCardViewController *viewController = [[UIStoryboard storyboardWithName:@"Personal" bundle:nil] instantiateViewControllerWithIdentifier:@"UserCardView"];
        viewController.userId = _housingModel.userid;
        [self.navigationController pushViewController:viewController animated:YES];
    }
}
- (IBAction)hezuButtonClick:(id)sender {
    MatchingViewController *matchingViewController = [[UIStoryboard storyboardWithName:@"Homepage" bundle:nil] instantiateViewControllerWithIdentifier:@"MatchingView"];
    matchingViewController.model = _housingModel;
    [self.navigationController pushViewController:matchingViewController animated:YES];
}
- (void)imageRecognizer:(UITapGestureRecognizer *)gesture {
    NSInteger photoCount = _imageArray.count;
    NSMutableArray *photosArray = [NSMutableArray arrayWithCapacity:photoCount];
    for (NSInteger i = 0; i < _imageArray.count; i ++) {
        NSString *urlString = _imageArray[i];
        MJPhoto *photo = [[MJPhoto alloc] init];
        photo.url = [NSURL URLWithString:[Util urlPhoto:urlString]];
        photo.srcImageView = self.mainImageView;
        [photosArray addObject:photo];
        
    }
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.currentPhotoIndex = 0;
    browser.photos = photosArray;
    [browser show];
}

@end
