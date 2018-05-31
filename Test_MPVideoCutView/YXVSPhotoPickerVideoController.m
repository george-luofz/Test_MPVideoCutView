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


@interface YXVSPhotoPickerVideoController () {
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
    //    CGFloat topHeight = [self _isIphoneX] ? 88 : 44;
    //    CGFloat bottomHeight = [self _isIphoneX] ? 34 : 0;
    //    CGFloat viewHeight = [UIScreen mainScreen].bounds.size.height - bottomHeight - topHeight;
    //    CGRectMake(0, topHeight, MPT_ScreenW, viewHeight);
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


#pragma clang diagnostic pop
@end
