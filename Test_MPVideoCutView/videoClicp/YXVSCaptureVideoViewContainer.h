//
//  YXVSCaptureVideoViewContainer.h
//  Test_MPVideoCutView
//
//  Created by 罗富中 on 2018/5/29.
//  Copyright © 2018年 George_luofz. All rights reserved.
//  裁剪视频视图容器


#import <UIKit/UIKit.h>

@interface YXVSCaptureVideoViewContainer : UIView

//- (instancetype)initWithVideoDuration:(CGFloat)videoDuration NS_DESIGNATED_INITIALIZER;

- (void)setUpVideoDuration:(CGFloat)duration;

- (void)addImage:(UIImage *)image atIndex:(NSInteger)index;;
@end
