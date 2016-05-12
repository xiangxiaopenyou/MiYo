//
//  SearchViewController.m
//  MiYo
//
//  Created by 项小盆友 on 16/4/18.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "SearchViewController.h"
#import "Util.h"
#import "CommonsDefines.h"
#import "AreaPickerView.h"
#import "AreaObject.h"
#import "MBProgressHUD+Add.h"
#import "HousingModel.h"
#import <MJRefresh.h>
#import "IndexReulstModel.h"
#import "SearchResultCell.h"
#import "HousingDetailViewController.h"

@interface SearchViewController ()<UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (weak, nonatomic) IBOutlet UITableView *sortTableView;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UILabel *sortLabel;
@property (weak, nonatomic) IBOutlet UILabel *areaLabel;
@property (weak, nonatomic) IBOutlet UILabel *selectionLabel;
@property (weak, nonatomic) IBOutlet UIButton *sortButton;
@property (weak, nonatomic) IBOutlet UIButton *areaButton;
@property (weak, nonatomic) IBOutlet UIButton *choiceButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sortViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UIImageView *sortDownIcon;
@property (weak, nonatomic) IBOutlet UIImageView *choiceDownIcon;
@property (weak, nonatomic) IBOutlet UIImageView *areaDownIcon;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *selectionViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UIButton *clearSelectionButton;
@property (weak, nonatomic) IBOutlet UIButton *selectionSubmitButton;
@property (weak, nonatomic) IBOutlet UITextField *minPriceTextField;
@property (weak, nonatomic) IBOutlet UITextField *maxPriceTextField;
@property (weak, nonatomic) IBOutlet UIButton *typeButton1;
@property (weak, nonatomic) IBOutlet UIButton *typeButton2;
@property (weak, nonatomic) IBOutlet UIButton *styleButton1;
@property (weak, nonatomic) IBOutlet UIButton *styleButton2;
@property (weak, nonatomic) IBOutlet UIButton *styleButton3;
@property (weak, nonatomic) IBOutlet UIButton *styleButton4;
@property (strong, nonatomic) UIButton *backgroundButton;
@property (copy, nonatomic) NSArray *sortArray;
@property (assign, nonatomic) NSInteger selectedSortType;
@property (copy, nonatomic) NSString *areaString;
@property (assign, nonatomic) CGFloat minPrice;
@property (assign, nonatomic) CGFloat maxPrice;
@property (assign, nonatomic) NSInteger housingType;
@property (assign, nonatomic) NSInteger housingStyle;
@property (copy, nonatomic) NSString *keyword;

@property (assign, nonatomic) NSInteger index;
@property (strong, nonatomic) NSMutableArray *housingArray;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.sortArray = @[@"时间排序", @"点击率排序", @"价格从低到高", @"价格从高到低"];
    _selectedSortType = 1001;
    _minPrice = 0;
    _maxPrice = 99999999;
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_back"] style:UIBarButtonItemStylePlain target:self action:@selector(backClick)];
    self.navigationItem.titleView = self.searchBar;
    self.navigationItem.title = @"";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(areaPickerShown) name:@"AreaPickerShown" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(areaPickerHiden) name:@"AreaPickerHiden" object:nil];
    self.searchBar.tintColor = [Util turnToRGBColor:@"12c1e8"];
    //self.searchBar.prompt = @"关键字搜索";
    self.searchBar.placeholder = @"关键字搜索";
    _housingStyle = 0;
    _housingType = 0;
    
    [self fixSelectionView];
    
    _index = 0;
    [self housingSearch];
    
    [_mainTableView setMj_footer:[MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self housingSearch];
    }]];
    _mainTableView.tableFooterView = [UIView new];
    _mainTableView.mj_footer.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)fixSelectionView {
    _selectionViewHeightConstraint.constant = 0;
    _clearSelectionButton.layer.borderWidth = 0.5;
    _clearSelectionButton.layer.borderColor = [Util turnToRGBColor:@"b0b0b0"].CGColor;
    _selectionSubmitButton.layer.borderWidth = 0.5;
    _selectionSubmitButton.layer.borderColor = [Util turnToRGBColor:@"12c1e8"].CGColor;
}
- (void)hideSortView {
    _sortButton.selected = NO;
    _sortLabel.textColor = [Util turnToRGBColor:@"323232"];
    _sortViewHeightConstraint.constant = 0;
    [_backgroundButton removeFromSuperview];
    [UIView animateWithDuration:0.2 delay:0 usingSpringWithDamping:0.9 initialSpringVelocity:20.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [self.view layoutIfNeeded];
    } completion:nil];
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        _sortDownIcon.transform = CGAffineTransformMakeRotation(0);
    } completion:nil];
}
- (void)showSortView {
    [self hideSelectionView];
    _sortButton.selected = YES;
    _sortLabel.textColor = [Util turnToRGBColor:@"12c1e8"];
    _sortViewHeightConstraint.constant = 160;
    [UIView animateWithDuration:0.3 delay:0.1 usingSpringWithDamping:0.7 initialSpringVelocity:10.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        _backgroundButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _backgroundButton.frame = CGRectMake(0, 262, SCREEN_WIDTH, SCREEN_HEIGHT - 262);
        _backgroundButton.backgroundColor = [UIColor clearColor];
        [_backgroundButton addTarget:self action:@selector(backgroundButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_backgroundButton];
    }];
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        _sortDownIcon.transform = CGAffineTransformMakeRotation(M_PI);
    } completion:nil];
}
- (void)showSelectionView {
    [self hideSortView];
    _selectionLabel.textColor = [Util turnToRGBColor:@"12c1e8"];
    _choiceButton.selected = YES;
    _selectionViewHeightConstraint.constant = SCREEN_HEIGHT - 102;
    [UIView animateWithDuration:0.2 delay:0.1 usingSpringWithDamping:0.9 initialSpringVelocity:20.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
    }];
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        _choiceDownIcon.transform = CGAffineTransformMakeRotation(M_PI);
    } completion:nil];
    
}
- (void)hideSelectionView {
    [_minPriceTextField resignFirstResponder];
    [_maxPriceTextField resignFirstResponder];
    _choiceButton.selected = NO;
    _selectionLabel.textColor = [Util turnToRGBColor:@"323232"];
    _selectionViewHeightConstraint.constant = 0;
    [UIView animateWithDuration:0.1 delay:0.1 usingSpringWithDamping:0.9 initialSpringVelocity:10.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
    }];
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        _choiceDownIcon.transform = CGAffineTransformMakeRotation(0);
    } completion:nil];
}
/*
 search request
 */
- (void)housingSearch {
    NSMutableDictionary *tempParam = [@{@"index" : @(_index),
                                @"sorttype" : @(_selectedSortType),
                                @"pricemin" : @(_minPrice),
                                @"pricemax" : @(_maxPrice),
                                @"isflatshare" : @(_housingType),
                                @"specification" : @(_housingStyle)} mutableCopy];
    if (![Util isEmpty:_areaString]) {
        [tempParam setObject:_areaString forKey:@"city"];
    }
    if (![Util isEmpty:_keyword]) {
        [tempParam setObject:_keyword forKey:@"search"];
    }
    [HousingModel searchHousingWith:tempParam handler:^(IndexReulstModel *object, NSString *msg) {
        [_mainTableView.mj_footer endRefreshing];
        if (!msg) {
            if (_index == 0) {
                _housingArray = [object.result mutableCopy];
            } else {
                NSMutableArray *tempArray = [_housingArray mutableCopy];
                [tempArray addObjectsFromArray:object.result];
                _housingArray = tempArray;
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
#pragma mark - UITableView Delegate DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return tableView == _mainTableView ? _housingArray.count : 4;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return tableView == _mainTableView ? 100 : 40;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _mainTableView) {
        static NSString *cellIdentifier = @"ResultCell";
        SearchResultCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[SearchResultCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        [cell setupContentWith:_housingArray[indexPath.row]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        cell.textLabel.text = self.sortArray[indexPath.row];
        if (indexPath.row + 1001 == _selectedSortType) {
            cell.textLabel.textColor = [Util turnToRGBColor:@"12c1e8"];
        } else {
            cell.textLabel.textColor = [Util turnToRGBColor:@"323232"];
        }
        cell.textLabel.font = kSystemFont(16);
        cell.backgroundColor = [UIColor clearColor];
        return cell;
    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _sortTableView) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        _selectedSortType = indexPath.row + 1001;
        _sortLabel.text = _sortArray[indexPath.row];
        [self hideSortView];
        [_sortTableView reloadData];
        [self housingSearch];
    } else {
        HousingModel *tempModel = _housingArray[indexPath.row];
        HousingDetailViewController *viewController = [[UIStoryboard storyboardWithName:@"Homepage" bundle:nil] instantiateViewControllerWithIdentifier:@"HousingDetailView"];
        viewController.housingId = tempModel.id;
        viewController.simpleModel = tempModel;
        [self.navigationController pushViewController:viewController animated:YES];
    }
}
#pragma mark - UISearchBar Delegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    _keyword = searchBar.text;
    [self housingSearch];
    //searchBar.showsCancelButton = NO;
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText.length > 0) {
        searchBar.showsCancelButton = YES;
        for (UIView *view in [self.searchBar.subviews[0] subviews]) {
            if ([view isKindOfClass:[UIButton class]]) {
                UIButton *cancelButton = (UIButton *)view;
                [cancelButton setTitle:@"搜索" forState:UIControlStateNormal];
                [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            }
        }
    } else {
        searchBar.showsCancelButton = NO;
        _keyword = nil;
        [self housingSearch];
    }
}
- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        if (searchBar.text.length > 0) {
            _keyword = searchBar.text;
            [self housingSearch];
        }
        [searchBar resignFirstResponder];
    }
    return YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
//- (void)backClick {
//    [self dismissViewControllerAnimated:YES completion:nil];
//}
- (IBAction)sortButtonClick:(id)sender {
    [_searchBar resignFirstResponder];
    if (_sortButton.selected) {
        [self hideSortView];
        
    } else {
        [self showSortView];
        
    }
}
- (IBAction)areaButtonClick:(id)sender {
    [_searchBar resignFirstResponder];
    if (_sortButton.selected) {
        [self hideSortView];
    }
    if (_choiceButton.selected) {
        [self hideSelectionView];
    }
    AreaPickerView *pickerView = [[AreaPickerView alloc] init];
    pickerView.block = ^(AreaPickerView *view, UIButton *button, AreaObject *locate) {
        _areaString = @"";
        if (![Util isEmpty:locate.province]) {
            _areaString = [NSString stringWithFormat:@"%@", locate.province];
        }
        if (![Util isEmpty:locate.city]) {
            _areaString = [NSString stringWithFormat:@"%@%@", _areaString, locate.city];
        }
        if (![Util isEmpty:locate.area]) {
            _areaString = [NSString stringWithFormat:@"%@%@", _areaString, locate.area];
        }
        if (![Util isEmpty:locate.area]) {
            _areaLabel.text = locate.area;
        } else {
            _areaLabel.text = locate.city;
        }
        [self housingSearch];
    };
    [pickerView show];
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        _areaDownIcon.transform = CGAffineTransformMakeRotation(M_PI);
    } completion:nil];
}
- (IBAction)choiceButtonClick:(id)sender {
    [_searchBar resignFirstResponder];
    if (_choiceButton.selected) {
        [self hideSelectionView];
    } else {
        [self showSelectionView];
    }
}
- (void)backgroundButtonClick {
    [self hideSortView];
}
- (IBAction)typeButtonClick:(id)sender {
    UIButton *button = (UIButton *)sender;
    if (button == _typeButton1) {
        if (button.selected) {
            _typeButton1.selected = NO;
        } else {
            _typeButton1.selected = YES;
            _typeButton2.selected = NO;
        }
    } else {
        if (button.selected) {
            _typeButton2.selected = NO;
        } else {
            _typeButton2.selected = YES;
            _typeButton1.selected = NO;
        }
    }
}
- (IBAction)styleButtonClick:(id)sender {
    UIButton *button = (UIButton *)sender;
    if (button == _styleButton1) {
        if (button.selected) {
            _styleButton1.selected = NO;
        } else {
            _styleButton1.selected = YES;
            _styleButton2.selected = NO;
            _styleButton3.selected = NO;
            _styleButton4.selected = NO;
        }
    } else if (button == _styleButton2) {
        if (button.selected) {
            _styleButton2.selected = NO;
        } else {
            _styleButton1.selected = NO;
            _styleButton2.selected = YES;
            _styleButton3.selected = NO;
            _styleButton4.selected = NO;
        }
    } else if (button == _styleButton3) {
        if (button.selected) {
            _styleButton3.selected = NO;
        } else {
            _styleButton1.selected = NO;
            _styleButton2.selected = NO;
            _styleButton3.selected = YES;
            _styleButton4.selected = NO;
        }
    } else if (button == _styleButton4) {
        if (button.selected) {
            _styleButton4.selected = NO;
        } else {
            _styleButton1.selected = NO;
            _styleButton2.selected = NO;
            _styleButton3.selected = NO;
            _styleButton4.selected = YES;
        }
    }
}
- (IBAction)clear:(id)sender {
    _minPrice = 0;
    _maxPrice = 99999999;
    _minPriceTextField.text = nil;
    _maxPriceTextField.text = nil;
    _typeButton1.selected = NO;
    _typeButton2.selected = NO;
    _styleButton1.selected = NO;
    _styleButton2.selected = NO;
    _styleButton3.selected = NO;
    _styleButton4.selected = NO;
    _housingStyle = 0;
    _housingType = 0;
}
- (IBAction)submitSelectionClick:(id)sender {
    if ([_minPriceTextField.text floatValue] > [_maxPriceTextField.text floatValue]) {
        [MBProgressHUD showError:@"最高价格要高于最低价格噢~" toView:self.view];
        return;
    }
    if (![Util isEmpty:_minPriceTextField.text]) {
        _minPrice = [_minPriceTextField.text floatValue];
    }
    if (![Util isEmpty:_maxPriceTextField.text]) {
        _maxPrice = [_maxPriceTextField.text floatValue];
    }
    if (_typeButton1.selected) {
        _housingType = 1;
    }
    if (_typeButton2.selected) {
        _housingType = 2;
    }
    if (_styleButton1.selected) {
        _housingStyle = 1;
    }
    if (_styleButton2.selected) {
        _housingStyle = 2;
    }
    if (_styleButton3.selected) {
        _housingStyle = 3;
    }
    if (_styleButton4.selected) {
        _housingStyle = 4;
    }
    [self hideSelectionView];
    [self housingSearch];
    
}
- (void)areaPickerShown {
    _areaLabel.textColor = [Util turnToRGBColor:@"12c1e8"];
}
- (void)areaPickerHiden {
    _areaLabel.textColor = [Util turnToRGBColor:@"323232"];
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        _areaDownIcon.transform = CGAffineTransformMakeRotation(0);
    } completion:nil];
}

@end
