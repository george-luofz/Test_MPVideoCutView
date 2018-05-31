//
//  YXVSPhotoPickerGroupList.h
//  Test_MPVideoCutView
//
//  Created by 罗富中 on 2018/5/31.
//  Copyright © 2018年 George_luofz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

@class YXVSPhotoPickerGroupList;
@protocol YXVSPhotoPickerGroupListDelegate <NSObject>
- (void)YXVSPhotoPickerGroupList:(YXVSPhotoPickerGroupList *)groupList selectAtIndex:(NSInteger)index;
@end

@interface YXVSPhotoPickerGroupList : UIView
@property (nonatomic, strong) NSArray<PHAssetCollection *>              *dataSource;
@property (nonatomic, assign) id<YXVSPhotoPickerGroupListDelegate>      delegate;

- (void)showWithView:(UIView *)view;
- (void)dismissWithView:(UIView *)view;
@end
