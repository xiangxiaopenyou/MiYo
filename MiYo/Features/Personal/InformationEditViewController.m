//
//  InformationEditViewController.m
//  MiYo
//
//  Created by 项小盆友 on 16/4/8.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "InformationEditViewController.h"
#import "CommonsDefines.h"
#import "Util.h"
#import "PersonalModel.h"
#import <UIImageView+AFNetworking.h>
#import "XLBlockActionSheet.h"
#import "AddressChoicePickerView.h"
#import "UploadImageRequest.h"
#import "HousingExpectationsViewController.h"
#import "MBProgressHUD+Add.h"

@interface InformationEditViewController ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *informationTableView;
@property (copy, nonatomic) NSArray *titleArray;
@property (strong, nonatomic) UIImageView *headImage;
@property (strong, nonatomic) UITextField *nicknameTextField;
@property (strong, nonatomic) UITextField *wechatTextField;
@property (strong, nonatomic) UITextField *qqTextField;
@property (strong, nonatomic) UITextField *nameTextField;
@property (strong, nonatomic) UITextField *ageTextField;
@property (strong, nonatomic) UITextField *jobTextField;
@property (strong, nonatomic) UILabel *portraitLabel;
@property (strong, nonatomic) UILabel *sexLabel;
@property (strong, nonatomic) UILabel *birthPlaceLabel;
@property (strong, nonatomic) UILabel *livePlaceLabel;
@property (strong, nonatomic) PersonalModel *model;
@property (strong, nonatomic) UIImage *selectedHeadImage;
@property (copy, nonatomic) NSString *imageName;
@property (strong, nonatomic) UISwitch *shareSwitch;

@end

@implementation InformationEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _titleArray = @[@"昵称", @"微信号", @"QQ", @"姓名", @"性别", @"年龄", @"籍贯", @"居住地", @"工作", @"是否同意合租"];
    self.navigationItem.title = @"完善信息";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveClick)];
    
    _informationTableView.tableFooterView = [UIView new];
    
    
    [self fetchUserInformation];
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}
- (void)fetchUserInformation {
    NSString *userId = [[NSUserDefaults standardUserDefaults] stringForKey:USERID];
    [PersonalModel fetchUserInformationWith:userId handler:^(id object, NSString *msg) {
        if (!msg) {
            _model = object;
            [self.informationTableView reloadData];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView Delegate DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 0 ? 4 : 7;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return indexPath.row == 0 ? 70 : 40;
    } else {
        return 40;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            static NSString *cellIdentifier = @"HeadPortraitCell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
            if (!_portraitLabel) {
                _portraitLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 150, 20, 110, 30)];
                _portraitLabel.textColor = [Util turnToRGBColor:@"909090"];
                _portraitLabel.font = kSystemFont(13);
                _portraitLabel.textAlignment = NSTextAlignmentRight;
                _portraitLabel.text = @"修改头像";
            }
            [cell.contentView addSubview:_portraitLabel];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            if (!_headImage) {
                _headImage = [[UIImageView alloc] initWithFrame:CGRectMake(15, 6, 58, 58)];
                if (_headImage.layer.cornerRadius != 29.0) {
                    _headImage.layer.masksToBounds = YES;
                    _headImage.layer.cornerRadius = 29.0;
                }
            }
            
            [_headImage setImageWithURL:[NSURL URLWithString:[Util urlZoomPhoto:_model.headphoto]] placeholderImage:[UIImage imageNamed:@"default_portrait"]];
            [cell.contentView addSubview:_headImage];
            return cell;
        } else {
            //static NSString *cellIdentifier = @"InformationCell";
            UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell1"];
            cell.textLabel.text = _titleArray[indexPath.row - 1];
            cell.textLabel.font = kSystemFont(16);
            cell.textLabel.textColor = [Util turnToRGBColor:@"323232"];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            if (indexPath.row == 1) {
                if (!_nicknameTextField) {
                    _nicknameTextField = [[UITextField alloc] initWithFrame:CGRectMake(60, 0, SCREEN_WIDTH - 100, 40)];
                    _nicknameTextField.borderStyle = UITextBorderStyleNone;
                    _nicknameTextField.textAlignment = NSTextAlignmentRight;
                    _nicknameTextField.textColor = [Util turnToRGBColor:@"909090"];
                    _nicknameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
                    _nicknameTextField.font = kSystemFont(13);
                }
                if ([Util isEmpty:_model.nickname]) {
                    _nicknameTextField.text = @"起个好听的昵称吧～";
                } else {
                    _nicknameTextField.text = [NSString stringWithFormat:@"%@", _model.nickname];
                }
                _nicknameTextField.delegate = self;
                [cell.contentView addSubview:_nicknameTextField];
            } else if (indexPath.row == 2) {
                if (!_wechatTextField) {
                    _wechatTextField = [[UITextField alloc] initWithFrame:CGRectMake(60, 0, SCREEN_WIDTH - 100, 40)];
                    _wechatTextField.borderStyle = UITextBorderStyleNone;
                    _wechatTextField.textAlignment = NSTextAlignmentRight;
                    _wechatTextField.textColor = [Util turnToRGBColor:@"909090"];
                    _wechatTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
                    _wechatTextField.font = kSystemFont(13);
                }
                if ([Util isEmpty:_model.weichat]) {
                    _wechatTextField.text = @"请输入";
                    _wechatTextField.clearsOnBeginEditing = YES;
                } else {
                    _wechatTextField.text = [NSString stringWithFormat:@"%@", _model.weichat];
                    _wechatTextField.clearsOnBeginEditing = NO;
                }
                _wechatTextField.delegate = self;
                [cell.contentView addSubview:_wechatTextField];
            } else {
                if (!_qqTextField) {
                    _qqTextField = [[UITextField alloc] initWithFrame:CGRectMake(60, 0, SCREEN_WIDTH - 100, 40)];
                    _qqTextField.borderStyle = UITextBorderStyleNone;
                    _qqTextField.textAlignment = NSTextAlignmentRight;
                    _qqTextField.textColor = [Util turnToRGBColor:@"909090"];
                    _qqTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
                    _qqTextField.keyboardType = UIKeyboardTypeNumberPad;
                    _qqTextField.font = kSystemFont(13);
                }
                
                if ([Util isEmpty:_model.qq]) {
                    _qqTextField.text = @"请输入";
                    _qqTextField.clearsOnBeginEditing = YES;
                } else {
                    _qqTextField.text = [NSString stringWithFormat:@"%@", _model.qq];
                    _qqTextField.clearsOnBeginEditing = NO;
                }
                _qqTextField.delegate = self;
                [cell.contentView addSubview:_qqTextField];
            }
            
            return cell;
        }
        
    } else {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell2"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = _titleArray[indexPath.row + 3];
        cell.textLabel.font = kSystemFont(16);
        cell.textLabel.textColor = [Util turnToRGBColor:@"323232"];
        switch (indexPath.row) {
            case 0:{
                if (!_nameTextField) {
                    _nameTextField = [[UITextField alloc] initWithFrame:CGRectMake(60, 0, SCREEN_WIDTH - 100, 40)];
                    _nameTextField.borderStyle = UITextBorderStyleNone;
                    _nameTextField.textAlignment = NSTextAlignmentRight;
                    _nameTextField.textColor = [Util turnToRGBColor:@"909090"];
                    _nameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
                    _nameTextField.font = kSystemFont(13);
                }
                if ([Util isEmpty:_model.name]) {
                    _nameTextField.text = @"真实姓名";
                    _nameTextField.clearsOnBeginEditing = YES;
                } else {
                    _nameTextField.text = [NSString stringWithFormat:@"%@", _model.name];
                    _nameTextField.clearsOnBeginEditing = NO;
                }
                
                _nameTextField.delegate = self;
                [cell.contentView addSubview:_nameTextField];
            }
                break;
            case 1:{
                if (!_sexLabel) {
                    _sexLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 150, 5, 110, 30)];
                    _sexLabel.textColor = [Util turnToRGBColor:@"909090"];
                    _sexLabel.font = kSystemFont(13);
                    _sexLabel.textAlignment = NSTextAlignmentRight;
                }
                if ([_model.sex integerValue] == 0) {
                    _sexLabel.text = @"请选择";
                } else {
                    _sexLabel.text = [_model.sex integerValue] == 1 ? @"男" : @"女";
                }
                [cell.contentView addSubview:_sexLabel];
            }
                break;
            case 2:{
                if (!_ageTextField) {
                    _ageTextField = [[UITextField alloc] initWithFrame:CGRectMake(60, 0, SCREEN_WIDTH - 100, 40)];
                    _ageTextField.borderStyle = UITextBorderStyleNone;
                    _ageTextField.textAlignment = NSTextAlignmentRight;
                    _ageTextField.textColor = [Util turnToRGBColor:@"909090"];
                    _ageTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
                    _ageTextField.keyboardType = UIKeyboardTypeNumberPad;
                    _ageTextField.font = kSystemFont(13);
                }
                _ageTextField.text = [NSString stringWithFormat:@"%@", @([_model.age integerValue])];
                _ageTextField.delegate = self;
                [cell.contentView addSubview:_ageTextField];
            }
                break;
            case 3:{
                if (!_birthPlaceLabel) {
                    _birthPlaceLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 150, 5, 110, 30)];
                    _birthPlaceLabel.textColor = [Util turnToRGBColor:@"909090"];
                    _birthPlaceLabel.font = kSystemFont(13);
                    _birthPlaceLabel.textAlignment = NSTextAlignmentRight;
                }
                if ([Util isEmpty:_model.nativeplace]) {
                    _birthPlaceLabel.text = @"请选择";
                } else {
                    _birthPlaceLabel.text = [NSString stringWithFormat:@"%@", _model.nativeplace];
                }
                [cell.contentView addSubview:_birthPlaceLabel];
            }
                break;
            case 4:{
                if (!_livePlaceLabel) {
                    _livePlaceLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 150, 5, 110, 30)];
                    _livePlaceLabel.textColor = [Util turnToRGBColor:@"909090"];
                    _livePlaceLabel.font = kSystemFont(13);
                    _livePlaceLabel.textAlignment = NSTextAlignmentRight;
                }
                if ([Util isEmpty:_model.liveplace]) {
                    _livePlaceLabel.text = @"请选择";
                } else {
                    _livePlaceLabel.text = [NSString stringWithFormat:@"%@", _model.liveplace];
                }
                [cell.contentView addSubview:_livePlaceLabel];
            }
                break;
            case 5:{
                if (!_jobTextField) {
                    _jobTextField = [[UITextField alloc] initWithFrame:CGRectMake(60, 0, SCREEN_WIDTH - 100, 40)];
                    _jobTextField.borderStyle = UITextBorderStyleNone;
                    _jobTextField.textAlignment = NSTextAlignmentRight;
                    _jobTextField.textColor = [Util turnToRGBColor:@"909090"];
                    _jobTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
                    _jobTextField.returnKeyType = UIReturnKeyDone;
                    _jobTextField.font = kSystemFont(13);
                }
                if ([Util isEmpty:_model.job]) {
                    _jobTextField.text = @"请输入";
                    _jobTextField.clearsOnBeginEditing = YES;
                } else {
                    _jobTextField.text = [NSString stringWithFormat:@"%@", _model.job];
                    _jobTextField.clearsOnBeginEditing = NO;
                }
                _jobTextField.delegate = self;
                [cell.contentView addSubview:_jobTextField];
            }
                break;
            case 6:{
                if (!_shareSwitch) {
                    _shareSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 65, 5, 50, 30)];
                    _shareSwitch.tintColor = [Util turnToRGBColor:@"12c1e8"];
                    _shareSwitch.onTintColor = [Util turnToRGBColor:@"12c1e8"];
                    [_shareSwitch addTarget:self action:@selector(switchValueChanged:) forControlEvents:UIControlEventValueChanged];
                }
                [cell.contentView addSubview:_shareSwitch];
                if ([_model.isallowsharehouse integerValue] == 1) {
                    _shareSwitch.on = YES;
                } else {
                    _shareSwitch.on = NO;
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
//                if (!_shareSwitch.on) {
//                    
//                }
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
                break;
                
            default:
                break;
        }
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0: {
                [self hideKeyboard];
                [[[XLBlockActionSheet alloc] initWithTitle:nil clickedBlock:^(NSInteger buttonIndex) {
                    if (buttonIndex == 1) {
                        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                            UIImagePickerController *takePhotoController = [[UIImagePickerController alloc] init];
                            takePhotoController.delegate = self;
                            takePhotoController.allowsEditing = YES;
                            takePhotoController.sourceType = UIImagePickerControllerSourceTypeCamera;
                            [self presentViewController:takePhotoController animated:YES completion:nil];
                        }
                        
                    }
                    if (buttonIndex == 2) {
                        UIImagePickerController *photoPickerController = [[UIImagePickerController alloc] init];
                        photoPickerController.delegate = self;
                        photoPickerController.allowsEditing = YES;
                        photoPickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                        [self presentViewController:photoPickerController animated:YES completion:nil];
                    }
                } cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"从相册选择", nil] showInView:self.view];
            }
                break;
            case 1: {
                [_nicknameTextField becomeFirstResponder];
            }
                break;
            case 2: {
                [_wechatTextField becomeFirstResponder];
            }
                break;
                
            default:
                break;
        }
    } else {
        switch (indexPath.row) {
            case 0: {
                [_nameTextField becomeFirstResponder];
            }
                break;
            case 1: {
                [self hideKeyboard];
                [[[XLBlockActionSheet alloc] initWithTitle:nil clickedBlock:^(NSInteger buttonIndex) {
                    if (buttonIndex == 1) {
                        _model.sex = [NSNumber numberWithInteger:1];
                        _sexLabel.text = @"男";
                    }
                    if (buttonIndex == 2) {
                        _model.sex = [NSNumber numberWithInteger:2];
                        _sexLabel.text = @"女";
                    }
                } cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"男", @"女", nil] showInView:self.view];
            }
                break;
            case 2: {
                [_ageTextField becomeFirstResponder];
            }
                break;
            case 3: {
                [self hideKeyboard];
                AddressChoicePickerView *addressPickerView = [[AddressChoicePickerView alloc] init];
                addressPickerView.block = ^(AddressChoicePickerView *view, UIButton *button, AreaObject *locate) {
                    if (![Util isEmpty:locate.city]) {
                        _model.nativeplace = [NSString stringWithFormat:@"%@", locate.city];
                        _birthPlaceLabel.text = [NSString stringWithFormat:@"%@", locate.city];
                    } else {
                        _model.nativeplace = [NSString stringWithFormat:@"%@", locate.province];
                        _birthPlaceLabel.text = [NSString stringWithFormat:@"%@", locate.province];
                    }
                    
                };
                [addressPickerView show];
            }
                break;
            case 4: {
                [self hideKeyboard];
                AddressChoicePickerView *addressPickerView = [[AddressChoicePickerView alloc] init];
                addressPickerView.block = ^(AddressChoicePickerView *view, UIButton *button, AreaObject *locate) {
                    _model.liveplace = [NSString stringWithFormat:@"%@", locate.city];
                    _livePlaceLabel.text = [NSString stringWithFormat:@"%@", locate.city];
                };
                [addressPickerView show];
            }
                break;
            case 5: {
                [_jobTextField becomeFirstResponder];
            }
                break;
            case 6: {
                if (_shareSwitch.on) {
                    HousingExpectationsViewController *housingExpectaionController = [[UIStoryboard storyboardWithName:@"Personal" bundle:nil] instantiateViewControllerWithIdentifier:@"HousingExpectationsView"];
                    housingExpectaionController.personalModel = _model;
                    [housingExpectaionController editFinished:^(PersonalModel *model) {
                        _model = model;
                        
                    }];
                    [self.navigationController pushViewController:housingExpectaionController animated:YES];
                }
            }
                
            default:
                break;
        }
        
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section == 0 ? 0 : 15;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 15)];
    headerView.backgroundColor = [UIColor clearColor];
    return headerView;
}
#pragma mark - UIImagePickerController Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    _selectedHeadImage = [info objectForKey:UIImagePickerControllerEditedImage];
    _headImage.image = _selectedHeadImage;
    NSString *tempName = @(ceil([[NSDate date] timeIntervalSince1970])).stringValue;
    _imageName = tempName;
    _model.headphoto = tempName;
    [[UploadImageRequest new] request:^BOOL(UploadImageRequest *request) {
        request.images = [NSArray arrayWithObject:_selectedHeadImage];
        request.keys = [NSArray arrayWithObject:tempName];
        return YES;
    } result:^(id object, NSString *msg) {
        if (!msg) {
            NSLog(@"上传成功");
        } else {
            NSLog(@"上传失败");
        }
    }];
}

#pragma mark - UITextField Delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    NSInteger offsetY = 0;
    if (textField == _nameTextField) {
        if (SCREEN_HEIGHT <= 480) {
            offsetY = 100;
        } else {
            offsetY = 50;
        }
    } else if (textField == _ageTextField) {
        if (SCREEN_HEIGHT <= 480) {
            offsetY = 150;
        } else {
            offsetY = 120;
        }
    } else if (textField == _jobTextField) {
        if (SCREEN_HEIGHT <= 480) {
            offsetY = 300;
        } else {
            offsetY = 200;
        }
    }
    [_informationTableView setContentOffset:CGPointMake(0, offsetY) animated:YES];
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == _nicknameTextField) {
        if ([Util isEmpty:_nicknameTextField.text]) {
            _nicknameTextField.text = [NSString stringWithFormat:@"%@", _model.nickname];
        } else {
            _model.nickname = _nicknameTextField.text;
        }
    } else if (textField == _wechatTextField) {
        _model.weichat = [NSString stringWithFormat:@"%@", _wechatTextField.text];
        if ([Util isEmpty:_model.weichat]) {
            _wechatTextField.text = @"请输入";
        }
    } else if (textField == _qqTextField) {
        _model.qq = [NSString stringWithFormat:@"%@", _qqTextField.text];
        if ([Util isEmpty:_model.qq]) {
            _qqTextField.text = @"请输入";
        }
    } else if (textField == _nameTextField) {
        _model.name = [NSString stringWithFormat:@"%@", _nameTextField.text];
        if ([Util isEmpty:_model.name]) {
            _nameTextField.text = @"真实姓名";
        }
    } else if (textField == _ageTextField) {
        if (![Util isEmpty:_ageTextField.text]) {
            _model.age = [NSNumber numberWithInteger:[_ageTextField.text integerValue]];
        } else {
            _model.age = [NSNumber numberWithInt:0];
            _ageTextField.text = [NSString stringWithFormat:@"%@", @([_model.age integerValue])];
        }
    } else {
        _model.job = [NSString stringWithFormat:@"%@", _jobTextField.text];
        if ([Util isEmpty:_model.job]) {
            _jobTextField.text = @"请输入";
        }
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == _nicknameTextField) {
        [_nicknameTextField resignFirstResponder];
        [_wechatTextField becomeFirstResponder];
    } else if (textField == _wechatTextField) {
        [_wechatTextField resignFirstResponder];
        [_qqTextField becomeFirstResponder];
    } else if (textField == _qqTextField) {
        [_qqTextField resignFirstResponder];
        [_nameTextField becomeFirstResponder];
    } else if (textField == _nameTextField) {
        [_nameTextField resignFirstResponder];
        [_ageTextField becomeFirstResponder];
    } else if (textField == _ageTextField) {
        [_ageTextField resignFirstResponder];
        [_jobTextField becomeFirstResponder];
    } else {
        [textField resignFirstResponder];
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
- (void)switchValueChanged:(id)sender {
    UISwitch *tempSwitch = (UISwitch *)sender;
    if (tempSwitch.on) {
        _model.isallowsharehouse = @(1);
        HousingExpectationsViewController *housingExpectaionController = [[UIStoryboard storyboardWithName:@"Personal" bundle:nil] instantiateViewControllerWithIdentifier:@"HousingExpectationsView"];
        housingExpectaionController.personalModel = _model;
        [housingExpectaionController editFinished:^(PersonalModel *model) {
            _model = model;
            
        }];
        [self.navigationController pushViewController:housingExpectaionController animated:YES];
    } else {
        _model.isallowsharehouse = @(0);
        
    }
    [_informationTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:6 inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)saveClick {
    [self hideKeyboard];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *userId = [[NSUserDefaults standardUserDefaults] stringForKey:USERID];
    NSMutableDictionary *param = [@{@"userid" : userId} mutableCopy];
    if (![Util isEmpty:_model.headphoto]) {
        [param setObject:_model.headphoto forKey:@"headphoto"];
    }
    [param setObject:_model.nickname forKey:@"nickname"];
    if ([Util isEmpty:_model.weichat]) {
        [param setObject:@"" forKey:@"weichat"];
    } else {
        [param setObject:_model.weichat forKey:@"weichat"];
    }
    if ([Util isEmpty:_model.qq]) {
        [param setObject:@"" forKey:@"qq"];
    } else {
        [param setObject:_model.qq forKey:@"qq"];
    }
    if ([Util isEmpty:_model.name]) {
        [param setObject:@"" forKey:@"name"];
    } else {
        [param setObject:_model.name forKey:@"name"];
    }
    [param setObject:_model.sex forKey:@"sex"];
    [param setObject:_model.age forKey:@"age"];
    if ([Util isEmpty:_model.nativeplace]) {
        [param setObject:@"" forKey:@"nativeplace"];
    } else {
        [param setObject:_model.nativeplace forKey:@"nativeplace"];
    }
    if ([Util isEmpty:_model.liveplace]) {
        [param setObject:@"" forKey:@"liveplace"];
    } else {
        [param setObject:_model.liveplace forKey:@"liveplace"];
    }
    if ([Util isEmpty:_model.job]) {
        [param setObject:@"" forKey:@"job"];
    } else {
        [param setObject:_model.job forKey:@"job"];
    }
    [param setObject:_model.isallowsharehouse forKey:@"isallowsharehouse"];
    if (![Util isEmpty:_model.hopeaddress]) {
        [param setObject:_model.hopeaddress forKey:@"hopeaddress"];
    }
    [param setObject:_model.hopepricemin forKey:@"hopepricemin"];
    [param setObject:_model.hoppricemax forKey:@"hoppricemax"];
    [param setObject:_model.hoperenovation forKey:@"hoperenovation"];
    [param setObject:_model.wifi forKey:@"wifi"];
    [param setObject:_model.washingmachine forKey:@"washingmachine"];
    [param setObject:_model.television forKey:@"television"];
    [param setObject:_model.refrigerator forKey:@"refrigerator"];
    [param setObject:_model.heater forKey:@"heater"];
    [param setObject:_model.airconditioner forKey:@"airconditioner"];
    [param setObject:_model.accesscontrol forKey:@"accesscontrol"];
    [param setObject:_model.elevator forKey:@"elevator"];
    [param setObject:_model.parkingspace forKey:@"parkingspace"];
    [param setObject:_model.bathtub forKey:@"bathtub"];
    [param setObject:_model.keepingpets forKey:@"keepingpets"];
    [param setObject:_model.smoking forKey:@"smoking"];
    [param setObject:_model.paty forKey:@"paty"];
    [param setObject:_model.hoperenovation forKey:@"hoperenovation"];
    if (param.count > 1) {
        [PersonalModel modifyInformationWith:param handler:^(id object, NSString *msg) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if (!msg) {
                NSLog(@"修改成功");
                [MBProgressHUD showSuccess:@"修改成功" toView:self.view];
                [[NSUserDefaults standardUserDefaults] setValue:_model.nickname forKey:NICKNAME];
                [[NSUserDefaults standardUserDefaults] setValue:_model.headphoto forKey:PORTRAIT];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [self.navigationController popViewControllerAnimated:YES];
                //NSDictionary *tempDictionary = @{@""}
                [[NSNotificationCenter defaultCenter] postNotificationName:@"EditInformationSuccess" object:nil];
            } else {
                NSLog(@"修改失败");
                [MBProgressHUD showError:@"修改失败" toView:self.view];
            }
        }];
    }
    
}
- (void)hideKeyboard {
    [_nicknameTextField resignFirstResponder];
    [_wechatTextField resignFirstResponder];
    [_qqTextField resignFirstResponder];
    [_nameTextField resignFirstResponder];
    [_ageTextField resignFirstResponder];
    [_jobTextField resignFirstResponder];
}

@end
