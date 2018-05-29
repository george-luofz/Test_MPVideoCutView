//
//  TestViewController.m
//  Test_MPVideoCutView
//
//  Created by 罗富中 on 2018/5/28.
//  Copyright © 2018年 George_luofz. All rights reserved.
//

#import "TestViewController.h"
#import "YXVSCaptureBorderRectView.h"
#import "YXVSCaptureVideoViewContainer.h"
@interface TestViewController () <YXVSCaptureBorderRectViewDelegate>
{
    UIScrollView *_scollView;
}
@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    YXVSCaptureBorderRectView *view = [[YXVSCaptureBorderRectView alloc] initWithVideoDuration:5];
//    view.backgroundColor = [UIColor whiteColor];
//    view.longPressDelegate = self;
////    [self.view addSubview:view];
//
//    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 66)];
//    scrollView.contentSize = CGSizeMake(1000, 66);
//    scrollView.backgroundColor = [UIColor yellowColor];
//    [scrollView addSubview:view];
//    [self.view addSubview:scrollView];
//    _scollView = scrollView;
//
//    [view setUpForLayout];
//    //
//    for(int  i = 0 ;i < 5; i++){
//        UIImage *image = [UIImage imageNamed:@"1111"];
//        [view addImage:image atIndex:i];
////        UIImageView *imageView = [self addImage:image atIndex:i];
////        [scrollView addSubview:imageView];
//    }
    
    YXVSCaptureVideoViewContainer *viewContainer = [[YXVSCaptureVideoViewContainer alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 66)];
    viewContainer.backgroundColor = [UIColor lightGrayColor];
    [viewContainer setUpVideoDuration:5];
    [self.view addSubview:viewContainer];
    
    for(int  i = 0 ;i < 5; i++){
        UIImage *image = [UIImage imageNamed:@"1111"];
        [viewContainer addImage:image atIndex:i];
    }
}

- (UIImageView *)addImage:(UIImage *)image atIndex:(NSInteger)index{
    CGFloat x = 15+ index * 56;
    CGRect rect = CGRectMake(x, 5 , 56, 56);
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:rect];
    imageView.userInteractionEnabled = YES;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.image = image ? image : nil;
    imageView.clipsToBounds = YES;
    return imageView;
}

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

// 1. 图片的位置没动；它的父视图的宽度在变化；
// 2. 框初始值跟图片宽度差不多；开始移动框，右侧移动，框的x不变；左侧移动，框的x变化
@end
