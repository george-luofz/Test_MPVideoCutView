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

- (PHFetchResult *)allVideos{
    PHFetchOptions *options = [[PHFetchOptions alloc]init];
    options.predicate = [NSPredicate predicateWithFormat:@"mediaType in %@",@[@(PHAssetMediaTypeVideo)]];
    options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
    return [PHAsset fetchAssetsWithOptions:options];
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
                    // 支持中英文
                    if([assetCollection.localizedTitle isEqualToString:@"Camera Roll"] || [assetCollection.localizedTitle isEqualToString:@"相机胶卷"]){
                        [self.assetCollections insertObject:assetCollection atIndex:0];
                    }else{
                        [self.assetCollections addObject:assetCollection];
                    }
                }
            }
        }
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        allGrougsInfo(self.assetCollections);
    });
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
        dispatch_async(dispatch_get_main_queue(), ^{
            PHImageInfo(result,asset);
        });
    }];
}


- (void)thePhotoInPHAsset:(PHAsset *)asset targetSize:(CGSize)targetSize PHImageInfo:(PHImageBlock)PHImageInfo{
    PHImageManager *manger = [PHImageManager defaultManager];
    PHImageRequestOptions * options = [[PHImageRequestOptions alloc] init];
    options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    
    [manger requestImageForAsset:asset targetSize:targetSize contentMode:PHImageContentModeAspectFill options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        dispatch_async(dispatch_get_main_queue(), ^{
            PHImageInfo(result,asset);
        });
    }];
}
@end
