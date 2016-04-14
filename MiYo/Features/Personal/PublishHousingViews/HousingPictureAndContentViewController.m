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

@interface HousingPictureAndContentViewController ()<UITextViewDelegate, CTAssetsPickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UIView *viewOfPicture;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewOfPictureHeightConstraint;
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
@property (weak, nonatomic) IBOutlet UILabel *textViewPlaceholderLabel;
@property (strong, nonatomic) NSMutableArray *picturesArray;
@property (strong, nonatomic) NSMutableArray *keysArray;
@property (strong, nonatomic) PHImageRequestOptions *requestOptions;

@end

@implementation HousingPictureAndContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"添加图片";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    _contentTextView.layer.masksToBounds = YES;
    _contentTextView.layer.cornerRadius = 5.0;
    _contentTextView.layer.borderWidth = 0.5;
    _contentTextView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
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
    CGFloat viewHeight = CGRectGetHeight(self.view.frame);
    CGFloat viewWidth = CGRectGetWidth(self.view.frame);
    NSInteger offset;
    if (SCREEN_HEIGHT <= 480) {
        offset = 150;
    } else {
        offset = 190;
    }
    [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];
    [UIView setAnimationDuration:0.2f];
    if (offset > 0) {
        self.view.frame = CGRectMake(0, - offset, viewWidth, viewHeight);
    }
    [UIView commitAnimations];
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
- (void)keyboardWillHide:(NSNotification *)notification {
    CGFloat viewHeight = CGRectGetHeight(self.view.frame);
    CGFloat viewWidth = CGRectGetWidth(self.view.frame);
    [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];
    [UIView setAnimationDuration:0.2f];
    self.view.frame = CGRectMake(0, 0, viewWidth, viewHeight);
    [UIView commitAnimations];
}
- (IBAction)deleteButtonClick:(id)sender {
}
- (IBAction)sendButton:(id)sender {
}

@end
