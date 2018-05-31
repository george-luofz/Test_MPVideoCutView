//
//  YXPhotoPickerAssetPreviewList.h
//  Test_MPVideoCutView
//
//  Created by 罗富中 on 2018/5/31.
//  Copyright © 2018年 George_luofz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

@class YXPhotoPickerAssetPreviewList;
@protocol YXPhotoPickerAssetPreviewListDelegate <NSObject>
// 点击某个视频
- (void)YXPhotoPickerAssetPreviewList:(YXPhotoPickerAssetPreviewList *)groupList selectAtIndex:(NSInteger)index;
@end

@interface YXPhotoPickerAssetPreviewList : UIView

@property (nonatomic, strong) NSArray<PHAsset *>                            *dataSource;
@property (nonatomic, assign) id<YXPhotoPickerAssetPreviewListDelegate>      delegate;

@end
