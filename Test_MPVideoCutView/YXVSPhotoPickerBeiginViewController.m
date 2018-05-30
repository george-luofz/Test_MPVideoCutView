//
//  YXVSPhotoPickerBeiginViewController.m
//  Test_MPVideoCutView
//
//  Created by 罗富中 on 2018/5/30.
//  Copyright © 2018年 George_luofz. All rights reserved.
//

#import "YXVSPhotoPickerBeiginViewController.h"
#import "YXVSPhotoAlbumManager.h"

@interface YXVSPhotoPickerBeiginViewController ()
@property YXVSPhotoAlbumManager *photoManager;

@end

@implementation YXVSPhotoPickerBeiginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self _testFindGroups];
}

// 1. 找含有视频的分组名称及该组最后一张图片
// 2. videoController支持展示指定分组里的视频，提供一个delegate给调用页

- (void)_testFindGroups{
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        if(status == PHAuthorizationStatusAuthorized){
            [[YXVSPhotoAlbumManager sharedInstance] allVideoGroupInfo:^(NSArray<PHAssetCollection *> *groupArray) {
                for(PHAssetCollection *collection  in groupArray){
                    NSLog(@"title :%@",collection);
                }
            }];
        }
    }];
    
}
@end
