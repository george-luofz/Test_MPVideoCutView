//
//  YXVSCaptureBorderRectView.h
//  Test_MPVideoCutView
//
//  Created by 罗富中 on 2018/5/28.
//  Copyright © 2018年 George_luofz. All rights reserved.
//
// 裁剪框视图
// 功能：
// 1.长按左右侧按钮，框长度拉伸到最大值或者最小值
// UI:
// 1.四周圆角
// 2.里边四周也圆角
// 3.左长按，右长按长度变长
// 4.左右有个小箭头

#import <UIKit/UIKit.h>

extern CGFloat const KYXVSCaptureBorderRectViewTopWidth;
extern CGFloat const KYXVSCaptureBorderRectViewLeftWidth;
extern CGFloat const KYXVSCaptureBorderRectViewImageWidth;
extern CGFloat const KYXVSCaptureBorderRectViewImageHeight;
extern CGFloat const KYXVSCaptureBorderRectViewLongPressDuration;

@class YXVSCaptureBorderRectView;
@protocol YXVSCaptureBorderRectViewDelegate <NSObject>

- (void)YXVSCaptureBorderRectView:(YXVSCaptureBorderRectView *)view leftBtnLongPressed:(UILongPressGestureRecognizer *)longPressGesture;

- (void)YXVSCaptureBorderRectView:(YXVSCaptureBorderRectView *)view rightBtnLongPressed:(UILongPressGestureRecognizer *)longPressGesture;

@end

@interface YXVSCaptureBorderRectView : UIView
@property CGFloat originalWidth;

@property id <YXVSCaptureBorderRectViewDelegate> longPressDelegate;

- (instancetype)initWithVideoDuration:(CGFloat)videoDuration NS_DESIGNATED_INITIALIZER;

- (void)setUpForLayout;

- (void)addImage:(UIImage *)image atIndex:(NSInteger)index;
@end
