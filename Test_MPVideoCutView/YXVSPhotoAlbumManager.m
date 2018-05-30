//
//  YXVSPhotoAlbumManager.m
//  Test_MPVideoCutView
//
//  Created by 罗富中 on 2018/5/30.
//  Copyright © 2018年 George_luofz. All rights reserved.
//

#import "YXVSPhotoAlbumManager.h"

@implementation YXVSPhotoAlbumManager

+ (instancetype)sharedInstance{
    static YXVSPhotoAlbumManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [YXVSPhotoAlbumManager new];
    });
    return manager;
}

- (void)allVideoGroupInfo:(PhotoKitAllGrougsBlock)allGrougsInfo{
    
    self.assetCollections = [NSMutableArray array];
    
    PHFetchOptions *fetchOptions = [[PHFetchOptions alloc] init];
    fetchOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"localizedTitle" ascending:YES]];
    
    PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAny options:nil];
    
    PHFetchResult *userAlbums = [PHCollectionList fetchTopLevelUserCollectionsWithOptions:nil];
    
    [self obtainAllAssetCollectionWithPHFetchResult:@[smartAlbums,userAlbums] allGrougsInfo:allGrougsInfo];
}

- (void)obtainAllAssetCollectionWithPHFetchResult:(NSArray *)resultAlbums allGrougsInfo:(PhotoKitAllGrougsBlock)allGrougsInfo{
    for (PHFetchResult *result in resultAlbums) {
        for (PHCollection *collection in result) {
            if ([collection isKindOfClass:[PHAssetCollection class]]) {
                PHAssetCollection *assetCollection = (PHAssetCollection *)collection;
                PHFetchResult *result = [self theFetchResultVideoInAssetCollection:assetCollection];
                if(result.count){
                    [self.assetCollections addObject:assetCollection];
                }
            }
        }
    }
    allGrougsInfo(self.assetCollections);
}

- (PHFetchResult *)theFetchResultVideoInAssetCollection:(PHAssetCollection *)assetCollection{
    PHFetchOptions *options = [PHFetchOptions new];
    options.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld", PHAssetMediaTypeVideo];
    PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:options];
    return fetchResult;
}

- (void)theCoverVideoInPHAssetGroup:(PHAssetCollection *)assetCollection PHImageInfo:(PHImageBlock)PHImageInfo{
    
    PHFetchResult *fetchResult = [self theFetchResultVideoInAssetCollection:assetCollection];
    
    if (fetchResult.count<=0) {
        UIImage *image = [UIImage imageNamed:@"yf_photo_default"];
        PHImageInfo(image,nil);
        return;
    }
    PHImageManager *manger = [PHImageManager  defaultManager];
    
    PHAsset *asset = fetchResult[0];
    [manger requestImageForAsset:asset targetSize:CGSizeMake(150, 150) contentMode:PHImageContentModeAspectFill options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        PHImageInfo(result,asset);
    }];
}


- (void)thePhotoInPHAsset:(PHAsset *)asset targetSize:(CGSize)targetSize PHImageInfo:(PHImageBlock)PHImageInfo{
    PHImageManager *manger = [PHImageManager defaultManager];
    PHImageRequestOptions * options = [[PHImageRequestOptions alloc] init];
    options.deliveryMode = PHImageRequestOptionsDeliveryModeFastFormat;
    options.resizeMode = PHImageRequestOptionsResizeModeFast;
    options.networkAccessAllowed = NO;
    
    [manger requestImageForAsset:asset targetSize:targetSize contentMode:PHImageContentModeAspectFill options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        PHImageInfo(result,asset);
    }];
}

@end
