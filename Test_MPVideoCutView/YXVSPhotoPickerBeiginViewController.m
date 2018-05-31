//
//  YXVSPhotoPickerBeiginViewController.m
//  Test_MPVideoCutView
//
//  Created by 罗富中 on 2018/5/30.
//  Copyright © 2018年 George_luofz. All rights reserved.
//

#import "YXVSPhotoPickerBeiginViewController.h"
#import "YXVSPhotoAlbumManager.h"
#import "YXVSPhotoPickerGroupList.h"
#import "YXPhotoPickerAssetPreviewList.h"
#import "YXVSPhotoPickerTopSwitchView.h"

@interface YXVSPhotoPickerBeiginViewController () <YXVSPhotoPickerGroupListDelegate, YXPhotoPickerAssetPreviewListDelegate>{
    YXVSPhotoPickerGroupList        *_groupList;
    YXPhotoPickerAssetPreviewList   *_previewList;
    YXVSPhotoPickerTopSwitchView    *_switchView;
    UIView                          *_shadeView;
    
    YXVSPhotoAlbumManager           *_photoManager;
    
    BOOL _isClicked;
    
    NSArray<PHCollection *>         *_groupListDatasource;
    NSArray<PHAsset *>              *_previewListDataSource;
}

@end

@implementation YXVSPhotoPickerBeiginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self _addSubviews];
//    [self _buildAllVideoData];
    [self _buildGroupData];
}
#pragma mark -- views
- (void)_addSubviews{
    [self _addTopSwithView];
    [self _addPreviewList];
    [self _addGroupList];
}

- (void)_addGroupList{
    
    UIView *shadeView = [[UIView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:shadeView];
    _shadeView = shadeView;
    
    _groupList = [[YXVSPhotoPickerGroupList alloc] initWithFrame:[self _selfSafeContentFrame]];
    _groupList.delegate = self;
    [self.view addSubview:_groupList];
//    _groupList.hidden = YES;
    [_groupList dismissWithView:_shadeView];
}

- (void)_addPreviewList{
    YXPhotoPickerAssetPreviewList *previewList = [[YXPhotoPickerAssetPreviewList alloc] initWithFrame:[self _selfSafeContentFrame]];
    previewList.delegate = self;
    [self.view addSubview:previewList];
    _previewList = previewList;
}
- (void)_addTopSwithView{
    
    YXVSPhotoPickerTopSwitchView *swithView = [[YXVSPhotoPickerTopSwitchView alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    [swithView addClickHandler:^(BOOL isSelected) {
        if(isSelected){
            [_groupList showWithView:_shadeView];
        }else{
            [_groupList dismissWithView:_shadeView];
        }
    }];
    self.navigationItem.titleView = swithView;
    _switchView = swithView;
}
#pragma mark - build data
- (void)_buildGroupData{
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        if(status == PHAuthorizationStatusAuthorized){
            [[YXVSPhotoAlbumManager sharedInstance] allVideoGroupInfo:^(NSArray<PHAssetCollection *> *groupArray) {
                _groupList.dataSource = groupArray;
                // 更新下title
                if(groupArray.count){
                    PHAssetCollection *collection = groupArray[0];
                    _switchView.title = collection.localizedTitle;
                    [self _buildExpecialCollectionData:collection];
                }
            }];
        }
    }];
}
- (void)_buildExpecialCollectionData:(PHAssetCollection *)collection{
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        if(status == PHAuthorizationStatusAuthorized){
            PHFetchResult *result = [[YXVSPhotoAlbumManager sharedInstance] theFetchResultVideoInAssetCollection:collection];
            NSMutableArray *colletionDatas = [NSMutableArray array];
            for (PHAsset *asset in result)
            {
                [colletionDatas insertObject:asset atIndex:0];
            }
            // 刷新数据
            _previewList.dataSource = colletionDatas;
            
        }
    }];
}


#pragma mark -- group list delegate
- (void)YXVSPhotoPickerGroupList:(YXVSPhotoPickerGroupList *)groupList selectAtIndex:(NSInteger)index{
    NSLog(@"click GroupList  at index:%ld",index);
    // 1. 关掉titleView
    // 2. 更新previewlist
    [_switchView clickTitle];
    PHAssetCollection *collection = groupList.dataSource[index];
    _switchView.title = collection.localizedTitle;
    
    [self _buildExpecialCollectionData:collection];
}

#pragma mark -- preview list delegate
- (void)YXPhotoPickerAssetPreviewList:(YXPhotoPickerAssetPreviewList *)groupList selectAtIndex:(NSInteger)index{
    NSLog(@"click PreviewList at index:%ld",index);
    [self _clickAPreviewAsset:index dataSource:groupList.dataSource];
}
- (void)_clickAPreviewAsset:(NSInteger)index dataSource:(NSArray *)dataSource{
    if (_isClicked == YES)
    {
        return;
    }
    
    _isClicked = YES;
    PHAsset *assetP = dataSource[index];
    PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
    options.deliveryMode = PHVideoRequestOptionsDeliveryModeAutomatic;
    options.networkAccessAllowed = YES;
    
    [[PHImageManager defaultManager] requestAVAssetForVideo:assetP options:options resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
        
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
#pragma mark -- private
- (CGRect)_selfSafeContentFrame{
    CGFloat topHeight = [self _isIphoneX] ? 88 : 44;
    CGFloat bottomHeight = [self _isIphoneX] ? 34 : 0;
    CGFloat viewHeight = [UIScreen mainScreen].bounds.size.height - bottomHeight - topHeight;
    return CGRectMake(0, topHeight, [UIScreen mainScreen].bounds.size.width, viewHeight);
}

- (BOOL)_isIphoneX{
    return [UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO;
}

@end
