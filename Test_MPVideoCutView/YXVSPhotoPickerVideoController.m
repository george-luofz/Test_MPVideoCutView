//
//  YXVSPhotoPickerVideoController.m
//  Test_MPVideoCutView
//
//  Created by 罗富中 on 2018/5/30.
//  Copyright © 2018年 George_luofz. All rights reserved.
//

#import "YXVSPhotoPickerVideoController.h"
#import <Photos/Photos.h>

#define MPT_ScreenH [UIScreen mainScreen].bounds.size.height
#define MPT_ScreenW [UIScreen mainScreen].bounds.size.width

@interface YXVSPhotoPickerVideoListCell : UICollectionViewCell
/// 视频使用时候的时长
@property (nonatomic, strong) UILabel *lableTime;

/// 文字下萌版
@property (nonatomic, strong) UIImageView *imageVMengBan;


- (void)setImage:(UIImage *)image isSelect:(BOOL)isSelect;

@end

@interface YXVSPhotoPickerVideoListCell()

/// 图
@property (nonatomic, strong) UIImageView *imageV;

/// 遮罩
@property (nonatomic, strong) UIImageView *imageVB;

@end

@implementation YXVSPhotoPickerVideoListCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, (MPT_ScreenW -3) / 4.0, (MPT_ScreenW -3) / 4.0)];
        _imageV.contentMode = UIViewContentModeScaleAspectFill;
        _imageV.clipsToBounds = YES;
        _imageV.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_imageV];
        
        _imageVB = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, (MPT_ScreenW -3) / 4.0, (MPT_ScreenW -3) / 4.0)];
        [self.contentView addSubview:_imageVB];
        
//        _imageVMengBan = [[UIImageView alloc] initWithFrame:CGRectMake(0, (MPT_ScreenW -3) / 4.0 - 25, (MPT_ScreenW -3) / 4.0, 25)];
//        _imageVMengBan.image = [UIImage imageNamed:@"capture_begin_zhezhao"];
//        [self.contentView addSubview:_imageVMengBan];
        
        UIView *labelBgView = [[UIView alloc] initWithFrame:CGRectMake(frame.size.width - 6 - 36, (MPT_ScreenW -3) / 4.0 - 20, 36, 18)];
        labelBgView.backgroundColor = [UIColor blackColor];
        labelBgView.alpha = 0.5;
        labelBgView.layer.cornerRadius = 2.f;
        [self.contentView addSubview:labelBgView];
        
        /// 视频时长
        _lableTime = [[UILabel alloc] initWithFrame:labelBgView.frame];
        _lableTime.font = [UIFont systemFontOfSize:10];
        _lableTime.textColor = [UIColor whiteColor];
        _lableTime.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_lableTime];
    }
    return self;
}

- (void)setImage:(UIImage *)image isSelect:(BOOL)isSelect
{
    
    _imageV.image = image;
    _imageVB.backgroundColor =  isSelect ?[UIColor colorWithWhite:0 alpha:0.7]:[UIColor clearColor];
}

@end

@interface YXVSPhotoPickerVideoController () <UICollectionViewDelegate,UICollectionViewDataSource>{
    BOOL _isClicked; //是否已经选择图片
}

/// 列表
@property (nonatomic, strong) UICollectionView *collectionView;

///照片管理器
@property (nonatomic, strong) PHCachingImageManager *imageManager;

///相册资源
@property (nonatomic, strong) PHFetchResult *assetsFetchResults;

// 视频元数据数组
@property (nonatomic, strong) NSMutableArray *maryData;

/// 空视图
@property (nonatomic, strong) UIView *viewEmpty;

@end

@implementation YXVSPhotoPickerVideoController
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self _initSubviews];
    [self _initPHPhotoLibrary];
}

#pragma mark -- 子视图
- (void)_initSubviews{
    /// 列表
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.minimumLineSpacing = 1;
    layout.minimumInteritemSpacing = 1;
    
    CGFloat topHeight = [self _isIphoneX] ? 88 : 44;
    CGFloat bottomHeight = [self _isIphoneX] ? 34 : 0;
    CGFloat viewHeight = [UIScreen mainScreen].bounds.size.height - bottomHeight - topHeight;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, topHeight, MPT_ScreenW, viewHeight) collectionViewLayout:layout];
    
    _collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _collectionView.layer.masksToBounds = YES;
    _collectionView.backgroundColor =[UIColor whiteColor];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.bounces = YES;
    _collectionView.alwaysBounceVertical = YES;
    [_collectionView registerClass:[YXVSPhotoPickerVideoListCell class] forCellWithReuseIdentifier:@"YXVSPhotoPickerVideoListCell"];
    [self.view addSubview:_collectionView];
}
#pragma mark -- 相册
- (void)_initPHPhotoLibrary
{
//    _fltSeet = 0;
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        if (status == PHAuthorizationStatusAuthorized)
        {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                _imageManager = [[PHCachingImageManager alloc]init];
                
                // 所有视频
                PHFetchOptions *options = [[PHFetchOptions alloc]init];
                options.predicate = [NSPredicate predicateWithFormat:@"mediaType in %@",@[@(PHAssetMediaTypeVideo)]];
                options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
                _assetsFetchResults = [PHAsset fetchAssetsWithOptions:options];
                
                _maryData = [NSMutableArray array];
                for (PHAsset *asset in _assetsFetchResults)
                {
                    [_maryData insertObject:asset atIndex:0];
                }
                
                if (_collectionView)
                {
                    [_collectionView reloadData];
                }
                
                /// 空视图处理
                if (_assetsFetchResults.count >0)
                {
                    [self _removeEmptyView];
                }
                else
                {
                    [self _createEmptyView];
                }
                
            });
        }
        else
        {
            /// 没有权限
            dispatch_async(dispatch_get_main_queue(), ^{
                [self _createEmptyView];
                // TODO: show something
//                if (self.hidden == NO)
//                {
//                    [MPTTips showTips:NSLocalizedString(@"AssetsLibrary_authority", @"相册权限提示")  duration:1.0];
//                }
            });
        }
    }];
}
- (void)_createEmptyView{
    
}
- (void)_removeEmptyView{
    
}
- (BOOL)_isIphoneX{
    return [UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO;
}

#pragma mark -- collectionView delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _maryData.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    YXVSPhotoPickerVideoListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"YXVSPhotoPickerVideoListCell" forIndexPath:indexPath];
    
    PHAsset *asset = _maryData[indexPath.row];
    PHImageRequestOptions *requestOptions = [[PHImageRequestOptions alloc] init];
    requestOptions.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    [_imageManager requestImageForAsset:asset targetSize:CGSizeMake((MPT_ScreenW - 3) / 4.0, (MPT_ScreenW - 3) / 4.0) contentMode:PHImageContentModeAspectFill options:requestOptions resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        [cell setImage:result isSelect:NO];
    }];
    
    cell.imageVMengBan.hidden = NO;
    cell.lableTime.text = [self _convertTime:asset.duration];
    return cell;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    PHAsset *asset = _maryData[indexPath.row];
    /// 小于3秒的视频不能用
    if (asset.duration <3.0)
    {
        // TODO: do sommething
        return NO;
    }
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (_isClicked == YES)
    {
        return;
    }
    
    _isClicked = YES;
    PHAsset *assetP = _maryData[indexPath.row];
    PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
    options.deliveryMode = PHVideoRequestOptionsDeliveryModeAutomatic;
    options.networkAccessAllowed = YES;
    [self.imageManager requestAVAssetForVideo:assetP options:options resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
        
        if (asset)
        {
            AVAsset *ass = asset;
            if (ass != nil)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    // TODO: 跳转页面
//                    MPTSpeedUploadVideoEditor *editor = [[MPTSpeedUploadVideoEditor alloc] initWithAsset:ass withRange:kCMTimeRangeZero];
//
//                    MPFCaptureShangChuanVideoMeiHuaVC *vc = [[MPFCaptureShangChuanVideoMeiHuaVC alloc] initWithComposition:editor.composition videoComposition:editor.videoComposition audioMix:editor.audioMix FromeType:ShiPin];
//                    vc.info = self.vc.info;
//                    [self.vc.navigationController pushViewController:vc animated:YES];
                });
            }
        }
        _isClicked = NO;
        
    }];
}
// 时间格式转换
- (NSString *)_convertTime:(NSTimeInterval)second
{
    NSDate *d = [NSDate dateWithTimeIntervalSince1970:second];
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    
    if (second/3600 >= 1) {
        [formatter setDateFormat:@"HH:mm:ss"];
    } else {
        [formatter setDateFormat:@"mm:ss"];
    }
    NSString *newTime = [formatter stringFromDate:d];
    return newTime;
}
#pragma mark - CHTCollectionViewDelegateWaterfallLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((MPT_ScreenW - 3) / 4.0,(MPT_ScreenW - 3) / 4.0);
}

#pragma clang diagnostic pop
@end
