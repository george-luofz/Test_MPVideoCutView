//
//  YXPhotoPickerAssetPreviewListCell.m
//  Test_MPVideoCutView
//
//  Created by 罗富中 on 2018/5/31.
//  Copyright © 2018年 George_luofz. All rights reserved.
//

#import "YXPhotoPickerAssetPreviewListCell.h"

@implementation YXPhotoPickerAssetPreviewListCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _imageV = [[UIImageView alloc] initWithFrame:self.bounds];
        _imageV.contentMode = UIViewContentModeScaleAspectFill;
        _imageV.clipsToBounds = YES;
        _imageV.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_imageV];
        
        // lable背景
        UIView *labelBgView = [[UIView alloc] initWithFrame:CGRectMake(frame.size.width - 6 - 36, frame.size.height - 20, 36, 18)];
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

@end
