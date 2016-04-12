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

@end

@implementation InformationEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _titleArray = @[@"昵称", @"微信号", @"QQ", @"姓名", @"性别", @"年龄", @"籍贯", @"居住地", @"工作"];
    self.navigationItem.title = @"完善信息";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveClick)];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    _informationTableView.tableFooterView = [UIView new];
    
    
    [self fetchUserInformation];
    
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
    return section == 0 ? 4 : 6;
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
                _ageTextField.text = [NSString stringWithFormat:@"%@岁", @([_model.age integerValue])];
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
                    _model.nativeplace = [NSString stringWithFormat:@"%@", locate.city];
                    _birthPlaceLabel.text = [NSString stringWithFormat:@"%@", locate.city];
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
}

#pragma mark - UITextField Delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    CGFloat viewHeight = CGRectGetHeight(self.view.frame);
    CGFloat viewWidth = CGRectGetWidth(self.view.frame);
    NSInteger offset;
    if (textField == _nameTextField) {
        offset = 245 - (viewHeight - 320.0);
    } else if (textField == _ageTextField) {
        offset = 325 - (viewHeight - 285.0);
    } else if (textField == _jobTextField) {
        if (SCREEN_HEIGHT > 480) {
            offset = 445 - (viewHeight - 320.0);
        } else {
            offset = 445 - (viewHeight - 285.0);
        }
    } else {
        offset = 0;
    }
    [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];
    [UIView setAnimationDuration:0.2f];
    if (offset > 0) {
        self.view.frame = CGRectMake(0, - offset, viewWidth, viewHeight);
    }
    [UIView commitAnimations];
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
            _ageTextField.text = [NSString stringWithFormat:@"%@岁", @([_model.age integerValue])];
        }
    } else {
        _model.job = [NSString stringWithFormat:@"%@", _jobTextField.text];
        if ([Util isEmpty:_model.job]) {
            _jobTextField.text = @"请输入";
        }
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
- (void)keyboardWillHide:(NSNotification *)notification {
    CGFloat viewHeight = CGRectGetHeight(self.view.frame);
    CGFloat viewWidth = CGRectGetWidth(self.view.frame);
    [UIView beginAnimations:@"HideForKeyBoard" context:nil];
    [UIView setAnimationDuration:0.2f];
    self.view.frame = CGRectMake(0, 0, viewWidth, viewHeight);
    [UIView commitAnimations];
}
- (void)saveClick {
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
