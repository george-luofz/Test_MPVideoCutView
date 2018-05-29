//
//  YXVSCaptureVideoViewContainer.m
//  Test_MPVideoCutView
//
//  Created by 罗富中 on 2018/5/29.
//  Copyright © 2018年 George_luofz. All rights reserved.
//

#import "YXVSCaptureVideoViewContainer.h"
#import "YXVSCaptureBorderRectView.h"
@interface YXVSCaptureVideoViewContainer() <YXVSCaptureBorderRectViewDelegate>
{
    CGFloat _videoDuration;
    
    UIScrollView *_scrollView; //滚动视图
    UIView *_imgViewContainer; //图片容器
    YXVSCaptureBorderRectView *_captureBorderView; //裁剪框
}
@end
@implementation YXVSCaptureVideoViewContainer

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self _initSubviews];
    }
    return self;
}

- (void)setUpVideoDuration:(CGFloat)duration{
    _videoDuration = duration;
    
    _scrollView.frame = [self _caculateScrollViewFrame];
    
}

- (void)addImage:(UIImage *)image atIndex:(NSInteger)index{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:[self _caculateImageViewFrame:index]];
    imageView.userInteractionEnabled = YES;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.image = image ? image : nil;
    imageView.clipsToBounds = YES;
    [_imgViewContainer addSubview:imageView];
}

#pragma mark -- private
- (void)_initSubviews{
    // 1.scrollView
    // 2._imgViewContainer
    // 3.YXVSCaptureBorderRectView
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    scrollView.contentSize = CGSizeMake(1000, 66); //TODO:
    scrollView.backgroundColor = [UIColor yellowColor];
    [self addSubview:scrollView];
    _scrollView = scrollView;
    
    UIView *imgViewContainer = [[UIView alloc] initWithFrame:[self _caculateImgViewContainerFrame]];
    imgViewContainer.clipsToBounds = YES; //超出裁剪
    [_scrollView addSubview:imgViewContainer];
    _imgViewContainer = imgViewContainer;
    
    return;
    YXVSCaptureBorderRectView *captureBorderView = [[YXVSCaptureBorderRectView alloc] initWithFrame:[self _caculateCaptureBorderViewFrame]];
    captureBorderView.longPressDelegate = self;
    [_scrollView addSubview:captureBorderView];
    _captureBorderView = captureBorderView;
}
#pragma mark -- caculate frames
- (CGRect)_caculateScrollViewFrame{
    CGFloat viewWidth = KYXVSCaptureBorderRectViewLeftWidth * 2 + _videoDuration * KYXVSCaptureBorderRectViewImageWidth;
    CGFloat viewHeight = KYXVSCaptureBorderRectViewImageHeight + 2 * KYXVSCaptureBorderRectViewTopWidth;
    return CGRectMake(0, 0, viewWidth, viewHeight);
}
- (CGRect)_caculateImgViewContainerFrame{
    return CGRectMake(KYXVSCaptureBorderRectViewLeftWidth, KYXVSCaptureBorderRectViewTopWidth, self.bounds.size.width - 2 * KYXVSCaptureBorderRectViewLeftWidth, KYXVSCaptureBorderRectViewImageHeight);
}
- (CGRect)_caculateImageViewFrame:(NSInteger)index{
    CGFloat x = 0 + index * KYXVSCaptureBorderRectViewImageWidth;
    CGRect rect = CGRectMake(x, KYXVSCaptureBorderRectViewTopWidth, KYXVSCaptureBorderRectViewImageWidth, KYXVSCaptureBorderRectViewImageHeight);
    return rect;
}
- (CGRect)_caculateCaptureBorderViewFrame{
    return CGRectMake(KYXVSCaptureBorderRectViewLeftWidth, KYXVSCaptureBorderRectViewTopWidth, self.bounds.size.width - 2 * KYXVSCaptureBorderRectViewLeftWidth, KYXVSCaptureBorderRectViewImageHeight);
}

#pragma mark -- YXVSCaptureBorderRectView delegate
- (void)YXVSCaptureBorderRectView:(YXVSCaptureBorderRectView *)view leftBtnLongPressed:(UILongPressGestureRecognizer *)longPressGesture{
    CGPoint point = [longPressGesture locationInView:view.superview];
    CGFloat x = point.x;
    CGFloat width = view.originalWidth-x; //宽度要变窄，应该是原始宽度减才对
    CGRect frame = CGRectMake(x, view.frame.origin.y, width, view.frame.size.height);
    view.frame = frame;
}

- (void)YXVSCaptureBorderRectView:(YXVSCaptureBorderRectView *)view rightBtnLongPressed:(UILongPressGestureRecognizer *)longPressGesture{
    // 1.找到移动的位置坐标
    // 2.更改选择框的frame，就是宽度改变了；左侧是x轴和宽度
    
    CGPoint point = [longPressGesture locationInView:view.superview];
    CGFloat width = point.x;
    CGRect frame = CGRectMake(0, view.frame.origin.y, width, view.frame.size.height);
    view.frame = frame;
}
@end
