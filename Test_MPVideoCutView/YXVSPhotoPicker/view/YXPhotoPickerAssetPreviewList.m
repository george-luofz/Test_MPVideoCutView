//
//  YXPhotoPickerAssetPreviewList.m
//  Test_MPVideoCutView
//
//  Created by 罗富中 on 2018/5/31.
//  Copyright © 2018年 George_luofz. All rights reserved.
//

#import "YXPhotoPickerAssetPreviewList.h"
#import "YXPhotoPickerAssetPreviewListCell.h"
#import "YXVSPhotoAlbumManager.h"

#define MPT_ScreenH [UIScreen mainScreen].bounds.size.height
#define MPT_ScreenW [UIScreen mainScreen].bounds.size.width

@interface YXPhotoPickerAssetPreviewList() <UICollectionViewDelegate,UICollectionViewDataSource>
{
    UICollectionView *_collectionView;
}
@end
@implementation YXPhotoPickerAssetPreviewList

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self _addSubViews];
    }
    return self;
}

- (void)setDataSource:(NSArray<PHAsset *> *)dataSource{
    _dataSource = dataSource;
    dispatch_async(dispatch_get_main_queue(), ^{
        [_collectionView reloadData];
    });
}

- (void)_addSubViews{
    /// 列表
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.minimumLineSpacing = 1;
    layout.minimumInteritemSpacing = 1;
    

    _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
    
    _collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _collectionView.layer.masksToBounds = YES;
    _collectionView.backgroundColor =[UIColor whiteColor];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.bounces = YES;
    _collectionView.alwaysBounceVertical = YES;
    [_collectionView registerClass:[YXPhotoPickerAssetPreviewListCell class] forCellWithReuseIdentifier:@"YXPhotoPickerAssetPreviewListCell"];
    [self addSubview:_collectionView];
}

#pragma mark -- collectionView delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataSource.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    YXPhotoPickerAssetPreviewListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"YXPhotoPickerAssetPreviewListCell" forIndexPath:indexPath];
    
    PHAsset *asset = _dataSource[indexPath.row];
    [[YXVSPhotoAlbumManager sharedInstance] thePhotoInPHAsset:asset targetSize:[self _caculteItemSize] PHImageInfo:^(UIImage *photo, PHAsset *asset) {
        if(photo){
            cell.imageV.image = photo;
        }
    }];
    cell.lableTime.text = [self _convertTime:asset.duration];
    return cell;
}
// TODO:可以由外边自己实现
//- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    PHAsset *asset = _dataSource[indexPath.row];
//    /// 小于3秒的视频不能用
//    if (asset.duration <3.0)
//    {
//        // TODO: do sommething
//        return NO;
//    }
//    return YES;
//}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [self _caculteItemSize];
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(YXPhotoPickerAssetPreviewList:selectAtIndex:)]){
        [self.delegate YXPhotoPickerAssetPreviewList:self selectAtIndex:indexPath.row];
    }
}
#pragma mark -- other method
// 计算一个cell的尺寸，多处使用
- (CGSize)_caculteItemSize{
    return CGSizeMake((self.frame.size.width - 3) / 4.0,(self.frame.size.width - 3) / 4.0);
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

@end
