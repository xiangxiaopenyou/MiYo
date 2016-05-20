//
//  HousingPictureAndContentViewController.m
//  MiYo
//
//  Created by 项小盆友 on 16/4/14.
//  Copyright © 2016年 项小盆友. All rights reserved.
//
#import "HousingPictureAndContentViewController.h"
#import "XLNoticeHelper.h"
#import <CTAssetsPickerController.h>
#import <Photos/Photos.h>
#import "UploadImageRequest.h"
#import "CommonsDefines.h"
#import "Util.h"
#import "HousingModel.h"
#import <SVProgressHUD.h>

@interface HousingPictureAndContentViewController ()<UITextViewDelegate, CTAssetsPickerControllerDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *viewOfPicture;
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewOfPictureHeightConstraint;
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
@property (weak, nonatomic) IBOutlet UILabel *textViewPlaceholderLabel;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (strong, nonatomic) NSMutableArray *picturesArray;
@property (strong, nonatomic) NSMutableArray *keysArray;
@property (strong, nonatomic) PHImageRequestOptions *requestOptions;

@end

@implementation HousingPictureAndContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"添加图片";
    _contentTextView.layer.masksToBounds = YES;
    _contentTextView.layer.cornerRadius = 5.0;
    _contentTextView.layer.borderWidth = 0.5;
    _contentTextView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _titleTextField.returnKeyType = UIReturnKeyDone;
    
    _titleTextField.delegate  = self;
    
    UITapGestureRecognizer *tableViewGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignCurrentFirstResponder)];
    tableViewGestureRecognizer.cancelsTouchesInView = NO;
    [_mainTableView addGestureRecognizer:tableViewGestureRecognizer];
    
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self setPictureView];
}
- (void)setPictureView {
    for (NSInteger i = [_viewOfPicture.subviews count] - 1; i >= 0; i --) {
        if ([_viewOfPicture.subviews[i] isKindOfClass:[UIImageView class]] || [_viewOfPicture.subviews[i] isKindOfClass:[UIButton class]]) {
            [_viewOfPicture.subviews[i] removeFromSuperview];
        }
    }
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(addImage) userInfo:nil repeats:NO];
    [timer fire];
    
}
- (void)addImage {
    CGFloat viewWidth = CGRectGetWidth(_viewOfPicture.bounds);
    if (_picturesArray.count <= 0) {
        UIButton *addPictureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        addPictureButton.frame = CGRectMake(CGRectGetWidth(_viewOfPicture.bounds) / 2 - ((viewWidth - 70) / 8.0), CGRectGetHeight(_viewOfPicture.bounds) / 2 - ((viewWidth - 70) / 8.0), (viewWidth - 70) / 4.0, (viewWidth - 70) / 4.0);
        [addPictureButton setImage:[UIImage imageNamed:@"add_picture"] forState:UIControlStateNormal];
        [addPictureButton addTarget:self action:@selector(addPictureClick) forControlEvents:UIControlEventTouchUpInside];
        [_viewOfPicture addSubview:addPictureButton];
        _viewOfPictureHeightConstraint.constant = 128;
    } else {
        for (NSInteger i = 0; i < _picturesArray.count; i ++) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20 + (i % 4) * ((viewWidth - 70) / 4.0 + 10), 10 + (i / 4) * ((viewWidth - 70) / 4.0 + 10), (viewWidth - 70) / 4.0, (viewWidth - 70) / 4.0)];
            imageView.image = _picturesArray[i];
            imageView.tag = i;
            imageView.userInteractionEnabled = YES;
            imageView.clipsToBounds = YES;
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            [_viewOfPicture addSubview:imageView];
            CGFloat imageWidth = CGRectGetWidth(imageView.frame);
            UIButton *deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(imageWidth - 16, 0, 16, 16)];
            deleteButton.tag = i;
            [deleteButton setImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
            [deleteButton setBackgroundColor:kRGBColor(255, 255, 255, 0.5)];
            [deleteButton addTarget:self action:@selector(imageDelete:) forControlEvents:UIControlEventTouchUpInside];
            [imageView addSubview:deleteButton];
            
        }
        NSInteger pictureNumber = _picturesArray.count;
        if (pictureNumber < 9) {
            UIButton *addPictureButton = [UIButton buttonWithType:UIButtonTypeCustom];
            addPictureButton.frame = CGRectMake(20 + (pictureNumber % 4) * ((viewWidth - 70) / 4.0 + 10), 10 + (pictureNumber / 4) * ((viewWidth - 70) / 4.0 + 10), (viewWidth - 70) / 4.0, (viewWidth - 70) / 4.0);
            [addPictureButton setImage:[UIImage imageNamed:@"add_picture"] forState:UIControlStateNormal];
            [addPictureButton addTarget:self action:@selector(addPictureClick) forControlEvents:UIControlEventTouchUpInside];
            [_viewOfPicture addSubview:addPictureButton];
        }
        _viewOfPictureHeightConstraint.constant = ((pictureNumber / 4) + 1) * ((viewWidth - 70) / 4.0 + 10) + 10;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UITextView
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if (![text isEqualToString:@""]) {
        _textViewPlaceholderLabel.hidden = YES;
    } else {
        if (range.location == 0 && range.length == 1) {
            _textViewPlaceholderLabel.hidden = NO;
        }
    }
    if (range.location >= 200) {
        [XLNoticeHelper showNoticeAtViewController:self message:@"别超过200字哦～"];
        return NO;
    }
    return YES;
}
- (void)textViewDidBeginEditing:(UITextView *)textView {
    NSInteger offset;
    CGFloat viewWidth = CGRectGetWidth(_viewOfPicture.bounds);
    if (SCREEN_HEIGHT <= 480) {
        if (_picturesArray.count <= 0) {
            offset = 190;
        } else {
            offset = 120 + ((_picturesArray.count / 4) + 1) * ((viewWidth - 70) / 4.0 + 10);
            
        }
    } else {
        if (_picturesArray.count <= 0) {
            offset = 150;
        } else {
            offset = 80 + ((_picturesArray.count / 4) + 1) * ((viewWidth - 70) / 4.0 + 10);
        }
    }
    [self.mainTableView setContentOffset:CGPointMake(0, offset) animated:YES];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    [self.mainTableView setContentOffset:CGPointMake(0, 0) animated:YES];
}
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    NSInteger offset;
    CGFloat viewWidth = CGRectGetWidth(_viewOfPicture.bounds);
    if (SCREEN_HEIGHT <= 480) {
        if (_picturesArray <= 0) {
            offset = 100;
        } else {
            offset = 30 + ((_picturesArray.count / 4) + 1) * ((viewWidth - 70) / 4.0 + 10);
        }
    } else {
        if (_picturesArray.count <= 0) {
            offset = 60;
        } else {
            offset = ((_picturesArray.count / 4) + 1) * ((viewWidth - 70) / 4.0 + 10);
        }
    }
    [self.mainTableView setContentOffset:CGPointMake(0, offset) animated:YES];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self.mainTableView setContentOffset:CGPointMake(0, 0) animated:YES];
}
#pragma mark - CTAssetsPickerController Delegate
- (BOOL)assetsPickerController:(CTAssetsPickerController *)picker shouldSelectAsset:(PHAsset *)asset {
    NSInteger maxNumber = 9 - _picturesArray.count;
    if (picker.selectedAssets.count >= maxNumber) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"最多只能上传9张照片" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:action];
        [picker presentViewController:alert animated:YES completion:nil];
    }
    return (picker.selectedAssets.count < maxNumber);
}
- (void)assetsPickerController:(CTAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets {
    self.requestOptions = [[PHImageRequestOptions alloc] init];
    self.requestOptions.resizeMode = PHImageRequestOptionsResizeModeExact;
    self.requestOptions.deliveryMode = PHImageRequestOptionsDeliveryModeOpportunistic;
    self.requestOptions.synchronous = YES;
    self.requestOptions.networkAccessAllowed = YES;
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    NSMutableArray *tempPictureArray = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < assets.count; i ++) {
        NSString *fileName = @(ceil([[NSDate date] timeIntervalSince1970])).stringValue;
        fileName = [NSString stringWithFormat:@"%@%@", fileName, @(i)];
        if (_keysArray.count == 0) {
            _keysArray = [[NSMutableArray alloc] init];
        }
        [_keysArray addObject:fileName];
        PHAsset *asset = assets[i];
        PHImageManager *manager = [PHImageManager defaultManager];
        //CGSize targetSize = CGSizeMake(asset.pixelWidth, asset.pixelHeight);
        
        [manager requestImageForAsset:asset
                           targetSize:PHImageManagerMaximumSize
                          contentMode:PHImageContentModeDefault
                              options:self.requestOptions
                        resultHandler:^(UIImage *image, NSDictionary *info){
                            if (!image) {
                                return;
                            }
                            [tempPictureArray addObject:image];
                            if (tempPictureArray.count >= assets.count) {
                                if (_picturesArray.count > 0) {
                                    [_picturesArray addObjectsFromArray:tempPictureArray];
                                } else {
                                    _picturesArray = [tempPictureArray mutableCopy];
                                }
//                                [[UploadImageRequest new] request:^BOOL(UploadImageRequest *request) {
//                                    request.keys = _keysArray;
//                                    request.images = _picturesArray;
//                                    return YES;
//                                } result:^(id object, NSString *msg) {
//                                    if (msg) {
//                                        NSLog(@"图片上传失败");
//                                    } else {
//                                        NSLog(@"上传成功");
//                                    }
//                                }];
                                [self setPictureView];
                            }
                        }];
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
- (void)addPictureClick {
    if (_picturesArray.count < 9) {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            dispatch_async(dispatch_get_main_queue(), ^{
                CTAssetsPickerController *picker = [[CTAssetsPickerController alloc] init];
                picker.delegate = self;
                picker.defaultAssetCollection = PHAssetCollectionSubtypeSmartAlbumUserLibrary;
                if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                    picker.modalPresentationStyle = UIModalPresentationFormSheet;
                }
                PHFetchOptions *fetchOptions = [PHFetchOptions new];
                fetchOptions.predicate = [NSPredicate predicateWithFormat:@"mediaType == %d", PHAssetMediaTypeImage];
                picker.assetsFetchOptions = fetchOptions;
                [self presentViewController:picker animated:YES completion:nil];
            });
        }];
    }
}
- (IBAction)deleteButtonClick:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (IBAction)sendButton:(id)sender {
    if (_keysArray.count == 0) {
        [SVProgressHUD showErrorWithStatus:@"请给您的房子添加照片"];
        return;
    }
    if ([Util isEmpty:_titleTextField.text]) {
        [SVProgressHUD showErrorWithStatus:@"请给您的房子添加一个醒目的标题"];
        return;
    }
    if ([Util isEmpty:_contentTextView.text]) {
        [SVProgressHUD showErrorWithStatus:@"请简单描述一下您的房子"];
        return;
    }
    //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [SVProgressHUD showProgress:0 status:@"正在发布房源"];
    _sendButton.enabled = NO;
    _deleteButton.enabled = NO;
    [[UploadImageRequest new] request:^BOOL(UploadImageRequest *request) {
        request.keys = _keysArray;
        request.images = _picturesArray;
        return YES;
    } result:^(id object, NSString *msg) {
        if (msg) {
            NSLog(@"图片上传失败");
            [SVProgressHUD showErrorWithStatus:@"上传图片失败，请重试"];
            _sendButton.enabled = YES;
            _deleteButton.enabled = YES;
        } else {
            NSLog(@"上传成功");
            NSString *imageString = [Util toJSONDataSting:_keysArray];
            imageString = [imageString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            [_informationDictionary setObject:imageString forKey:@"image"];
            [_informationDictionary setObject:_titleTextField.text forKey:@"title"];
            [_informationDictionary setObject:_contentTextView.text forKey:@"description"];
            NSString *userId = [[NSUserDefaults standardUserDefaults] stringForKey:USERID];
            [_informationDictionary setObject:userId forKey:@"userid"];
            [HousingModel sendHousingWith:_informationDictionary handler:^(id object, NSString *msg) {
                //[SVProgressHUD dismiss];
                if (!msg) {
                    [SVProgressHUD showSuccessWithStatus:@"发布成功"];
                    [self performSelector:@selector(popView) withObject:nil afterDelay:0.8];
                    
                } else {
                    [SVProgressHUD showErrorWithStatus:@"发布失败"];
                    _sendButton.enabled = YES;
                    _deleteButton.enabled = YES;
                }
            }];

        }
    }];
    }
- (void)imageDelete:(id)sender {
    UIButton *button = (UIButton *)sender;
    NSInteger index = button.tag;
    [_keysArray removeObjectAtIndex:index];
    [_picturesArray removeObjectAtIndex:index];
    [self setPictureView];
}
- (void)popView {
    _sendButton.enabled = YES;
    _deleteButton.enabled = YES;
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)resignCurrentFirstResponder {
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    [keyWindow endEditing:YES];
}

@end
