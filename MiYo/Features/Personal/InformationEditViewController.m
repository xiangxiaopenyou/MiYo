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

@interface InformationEditViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (copy, nonatomic) NSArray *titleArray;
@property (strong, nonatomic) UIImageView *headImage;
@property (strong, nonatomic) UITextField *nicknameTextField;
@property (strong, nonatomic) UITextField *phoneNumberTextField;
@property (strong, nonatomic) UITextField *nameTextField;
@property (strong, nonatomic) UITextField *ageTextField;
@property (strong, nonatomic) UITextField *jobTextField;
@property (strong, nonatomic) UILabel *portraitLabel;
@property (strong, nonatomic) UILabel *sexLabel;
@property (strong, nonatomic) UILabel *birthPlaceLabel;
@property (strong, nonatomic) UILabel *livePlaceLabel;

@end

@implementation InformationEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _titleArray = @[@"昵称", @"手机号", @"姓名", @"性别", @"年龄", @"籍贯", @"居住地", @"工作"];
    self.navigationItem.title = @"完善信息";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveClick)];
    
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
    return section == 0 ? 3 : 6;
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
            }
            _portraitLabel.text = @"修改头像";
            _portraitLabel.textColor = [Util turnToRGBColor:@"909090"];
            _portraitLabel.font = kSystemFont(13);
            _portraitLabel.textAlignment = NSTextAlignmentRight;
            [cell.contentView addSubview:_portraitLabel];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            if (!_headImage) {
                _headImage = [[UIImageView alloc] initWithFrame:CGRectMake(15, 6, 58, 58)];
            }
            if (_headImage.layer.cornerRadius != 29.0) {
                _headImage.layer.masksToBounds = YES;
                _headImage.layer.cornerRadius = 29.0;
            }
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
                }
                _nicknameTextField.borderStyle = UITextBorderStyleNone;
                _nicknameTextField.textAlignment = NSTextAlignmentRight;
                _nicknameTextField.textColor = [Util turnToRGBColor:@"909090"];
                _nicknameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
                _nicknameTextField.font = kSystemFont(13);
                _nicknameTextField.text = @"起个好听的昵称吧～";
                [cell.contentView addSubview:_nicknameTextField];
            } else {
                if (!_phoneNumberTextField) {
                    _phoneNumberTextField = [[UITextField alloc] initWithFrame:CGRectMake(60, 0, SCREEN_WIDTH - 100, 40)];
                }
                _phoneNumberTextField.borderStyle = UITextBorderStyleNone;
                _phoneNumberTextField.textAlignment = NSTextAlignmentRight;
                _phoneNumberTextField.textColor = [Util turnToRGBColor:@"909090"];
                _phoneNumberTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
                _phoneNumberTextField.keyboardType = UIKeyboardTypeNumberPad;
                _phoneNumberTextField.font = kSystemFont(13);
                _phoneNumberTextField.text = @"手机号码";
                [cell.contentView addSubview:_phoneNumberTextField];
            }
            
            return cell;
        }
        
    } else {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell2"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = _titleArray[indexPath.row + 2];
        cell.textLabel.font = kSystemFont(16);
        cell.textLabel.textColor = [Util turnToRGBColor:@"323232"];
        switch (indexPath.row) {
            case 0:{
                if (!_nameTextField) {
                    _nameTextField = [[UITextField alloc] initWithFrame:CGRectMake(60, 0, SCREEN_WIDTH - 100, 40)];
                }
                _nameTextField.borderStyle = UITextBorderStyleNone;
                _nameTextField.textAlignment = NSTextAlignmentRight;
                _nameTextField.textColor = [Util turnToRGBColor:@"909090"];
                _nameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
                _nameTextField.font = kSystemFont(13);
                _nameTextField.text = @"真实姓名";
                [cell.contentView addSubview:_nameTextField];
            }
                break;
            case 1:{
                if (!_sexLabel) {
                    _sexLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 150, 5, 110, 30)];
                }
                _sexLabel.text = @"请选择";
                _sexLabel.textColor = [Util turnToRGBColor:@"909090"];
                _sexLabel.font = kSystemFont(13);
                _sexLabel.textAlignment = NSTextAlignmentRight;
                [cell.contentView addSubview:_sexLabel];
            }
                break;
            case 2:{
                if (!_ageTextField) {
                    _ageTextField = [[UITextField alloc] initWithFrame:CGRectMake(60, 0, SCREEN_WIDTH - 100, 40)];
                }
                
                _ageTextField.borderStyle = UITextBorderStyleNone;
                _ageTextField.textAlignment = NSTextAlignmentRight;
                _ageTextField.textColor = [Util turnToRGBColor:@"909090"];
                _ageTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
                _ageTextField.keyboardType = UIKeyboardTypeNumberPad;
                _ageTextField.font = kSystemFont(13);
                _ageTextField.text = @"0岁";
                [cell.contentView addSubview:_ageTextField];
            }
                break;
            case 3:{
                if (!_birthPlaceLabel) {
                    _birthPlaceLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 150, 5, 110, 30)];
                }
                _birthPlaceLabel.text = @"请选择";
                _birthPlaceLabel.textColor = [Util turnToRGBColor:@"909090"];
                _birthPlaceLabel.font = kSystemFont(13);
                _birthPlaceLabel.textAlignment = NSTextAlignmentRight;
                [cell.contentView addSubview:_birthPlaceLabel];
            }
                break;
            case 4:{
                if (!_livePlaceLabel) {
                    _livePlaceLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 150, 5, 110, 30)];
                }
                
                _livePlaceLabel.text = @"请选择";
                _livePlaceLabel.textColor = [Util turnToRGBColor:@"909090"];
                _livePlaceLabel.font = kSystemFont(13);
                _livePlaceLabel.textAlignment = NSTextAlignmentRight;
                [cell.contentView addSubview:_livePlaceLabel];
            }
                break;
            case 5:{
                if (!_jobTextField) {
                    _jobTextField = [[UITextField alloc] initWithFrame:CGRectMake(60, 0, SCREEN_WIDTH - 100, 40)];
                }
                _jobTextField.borderStyle = UITextBorderStyleNone;
                _jobTextField.textAlignment = NSTextAlignmentRight;
                _jobTextField.textColor = [Util turnToRGBColor:@"909090"];
                _jobTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
                _jobTextField.font = kSystemFont(13);
                _jobTextField.text = @"你的工作是什么？";
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
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section == 0 ? 0 : 15;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 15)];
    headerView.backgroundColor = [UIColor clearColor];
    return headerView;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)saveClick {
    
}

@end
