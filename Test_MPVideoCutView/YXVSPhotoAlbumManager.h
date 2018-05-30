//
//  YXVSPhotoAlbumManager.h
//  Test_MPVideoCutView
//
//  Created by 罗富中 on 2018/5/30.
//  Copyright © 2018年 George_luofz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

typedef void(^PhotoKitAllGrougsBlock)(NSArray<PHAssetCollection *> *groupArray);
typedef void(^PHImageBlock)(UIImage *photo, PHAsset *asset);
typedef void(^PHICloudBlock)(NSNumber *isICloud);

@interface YXVSPhotoAlbumManager : NSObject

@property (nonatomic, strong) NSMutableArray *assetCollections;  //相册分组

+ (instancetype)sharedInstance;

#pragma mark -- for YXVS

// 获取所有视频相册分组
- (void)allVideoGroupInfo:(PhotoKitAllGrougsBlock)allGrougsInfo;

// 获取该分组里所有视频
- (PHFetchResult *)theFetchResultVideoInAssetCollection:(PHAssetCollection *)assetCollection;

// 该分组里第一个视频的封面
- (void)theCoverVideoInPHAssetGroup:(PHAssetCollection *)assetCollection PHImageInfo:(PHImageBlock)PHImageInfo;

// 获取指定尺寸的封面
- (void)thePhotoInPHAsset:(PHAsset *)asset targetSize:(CGSize)targetSize PHImageInfo:(PHImageBlock)PHImageInfo;
@end
