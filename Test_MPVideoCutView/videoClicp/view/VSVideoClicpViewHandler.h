//
//  VSVideoClicpViewHandler.h
//  Test_MPVideoCutView
//
//  Created by 罗富中 on 2018/6/2.
//  Copyright © 2018年 George_luofz. All rights reserved.

//  功能：
//  1. headerView: 上方操作提示label，已选择多少秒；最短多少秒；水平翻转按钮
//  2. bottomView: 下方视频裁剪框视图

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
@class VSVideoClicpViewHandler;
@protocol VSVideoClicpViewHandlerDelegate <NSObject>
// 选择指定范围
- (void)videoClicpViewContainer:(VSVideoClicpViewHandler *)viewContainer selectAtRange:(CMTimeRange)timeTange;
// 水平翻转到指定方向
- (void)videoClicpViewContainer:(VSVideoClicpViewHandler *)viewContainer flipHorizontalToRotate:(CGFloat)rotate;

@end

@interface VSVideoClicpViewHandler : UIView

@property (nonatomic, assign) CGFloat videoDuration;                            //视频总时长

@property (nonatomic, assign, readonly) CMTimeRange currentSelectedTimeRange;   //当前选择时长范围
@property (nonatomic, assign, readonly) CGFloat currentSelectRotation;          //当前选择角度，取值0 0.5 1 1.5 2
@property (nonatomic, assign) CGFloat minSelectedVideoDuration;                 //允许最短选择时长，默认3s

@property (nonatomic, weak) id<VSVideoClicpViewHandlerDelegate> delegate;       //delegate

- (void)show;
- (void)hide;
@end
