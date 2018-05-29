//
//  ViewController.m
//  Test_MPVideoCutView
//
//  Created by 罗富中 on 2018/5/25.
//  Copyright © 2018年 George_luofz. All rights reserved.
//

#import "ViewController.h"
#import "MPFCaptureShangChuanVideoMeiHuaCaiJianView.h"

#define MPT_Device_Is_iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

#define MPT_Device_iPhoneX_StatusH 44
#define MPT_Device_iPhoneX_FooterH 34
#define MPT_Device_iPhoneX_NavH 44
#define MPT_Device_iPhoneX_NavStatusH (MPT_Device_iPhoneX_StatusH + MPT_Device_iPhoneX_NavH)
#define MPT_Device_iPhoneX_CenterViewH (MPT_ScreenW-MPT_Device_iPhoneX_NavStatusH - MPT_Device_iPhoneX_FooterH)

#define MPT_Device_GetTrueHeight(normalH,iphoneXH) (MPT_Device_Is_iPhoneX ? iphoneXH : normalH)

#define MPT_ScreenW [UIScreen mainScreen].bounds.size.width
#define MPT_ScreenH [UIScreen mainScreen].bounds.size.height
@interface ViewController ()
@property MPFCaptureShangChuanVideoMeiHuaCaiJianView *viewCaiJian;
@property UILabel *labTime;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self.view addSubview:self.viewCaiJian];
    
    NSMutableArray *imgs = [self _images];
    for(int i = 0 ;i < imgs.count;i++){
        [self.viewCaiJian setimageData:imgs[i] index:i];
    }
    
    
}

- (NSMutableArray *)_images{
    NSMutableArray *array = [NSMutableArray array];
    for(int i = 0 ;i < 30;i++){
        UIColor *color = [UIColor colorWithWhite:arc4random()%1 alpha:1.];
        UIImage *image = [self imageFromColor:color];
        [array addObject:image];
    }
    return array;
}


- (UIImage *)imageFromColor:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
/// 裁剪
- (MPFCaptureShangChuanVideoMeiHuaCaiJianView *)viewCaiJian
{
    if (!_viewCaiJian)
    {
        
        _viewCaiJian = [[MPFCaptureShangChuanVideoMeiHuaCaiJianView alloc] initWithFrame:CGRectMake(0, MPT_Device_GetTrueHeight(MPT_ScreenH - 90 - 50, MPT_ScreenH - 90 - 50-MPT_Device_iPhoneX_FooterH), MPT_ScreenW, 90) maryImages:nil videoDuration:30];
        
//        __weak MPFCaptureShangChuanVideoMeiHuaVC *weakSelf = self;
        /// 选取时间的回调 哪个按钮  时间的中心点
        [_viewCaiJian setMPFCaptureShangChuanVideoMeiHuaCaiJianViewBlock:^(CaiJianType type, CGFloat fltTime, CGFloat fltCenterX)
         {
             dispatch_async(dispatch_get_main_queue(), ^{
//                 if (weakSelf.videoEngine.isPlaying)
//                 {
//                     [weakSelf.videoEngine pause];
//                 }
                 
                 if (type == KaiShi)
                 {
//                     weakSelf.fltPlayTime = fltTime;
//
//                     if (weakSelf.fltEndPlayTime - weakSelf.fltPlayTime < 3)
//                     {
//                         weakSelf.fltPlayTime = weakSelf.fltEndPlayTime - 3;
//                     }
//                     if (weakSelf.fltEndPlayTime - weakSelf.fltPlayTime > 900)
//                     {
//                         weakSelf.fltPlayTime = weakSelf.fltEndPlayTime - 900;
//                     }
                 }
                 else
                 {
//                     weakSelf.fltEndPlayTime = fltTime;
//
//                     if (weakSelf.fltEndPlayTime - weakSelf.fltPlayTime < 3)
//                     {
//                         weakSelf.fltEndPlayTime = weakSelf.fltPlayTime + 3;
//                     }
//
//                     if (weakSelf.fltEndPlayTime - weakSelf.fltPlayTime > 900)
//                     {
//                         weakSelf.fltEndPlayTime = weakSelf.fltPlayTime + 900;
//                     }
                 }
                 
                 
                 
                 CGFloat fltC;
                 if (fltCenterX<(22.5+5))
                 {
                     fltC = 22.5+5;
                 }
                 else if (fltCenterX> (MPT_ScreenW - 22.5 - 5))
                 {
                     fltC = MPT_ScreenW - 22.5 - 5;
                 }
                 else
                 {
                     fltC = fltCenterX;
                 }
                 
                 
//                 weakSelf.labTime.center = CGPointMake(fltC, weakSelf.labTime.center.y);
//                 [weakSelf updateTime:fltTime];
                 
                 /// 快进
//                 [weakSelf.videoEngine seekToSecondWithHandleDecode:fltTime];
                 
                 /// 更新进度条时间
//                 if (weakSelf.viewSider)
//                 {
//                     [weakSelf.viewSider setTime:0];
//                     [weakSelf.viewSider setVideoDuration:weakSelf.fltEndPlayTime - weakSelf.fltPlayTime];
//                     weakSelf.viewSider.hidden = YES;
//                 }
                 
             });
         }];
        
        /// 滑动了滑块
        [_viewCaiJian setMPFCaptureShangChuanVideoMeiHuaCaiJianViewHuaKuaiBlock:^(CGFloat fltTime)
         {
             dispatch_async(dispatch_get_main_queue(), ^{
//                 if (weakSelf.videoEngine.isPlaying)
//                 {
//                     [weakSelf.videoEngine pause];
//                 }
//
//                 /// 记录快进时间
//                 weakSelf.fltSeekTime = fltTime;
//
//                 /// 改变进度条位置
//                 [weakSelf.viewSider setTime:(fltTime - weakSelf.fltPlayTime)];
//                 /// 调用了get方法先因此
//                 weakSelf.viewSider.hidden = YES;
//
//                 /// 快进
//                 [weakSelf.videoEngine seekToSecondWithHandleDecode:fltTime];
                 
             });
         }];
        
        /// 结束了滑动
        [_viewCaiJian setMPFCaptureShangChuanVideoMeiHuaCaiJianViewEndBlock:^(BOOL isHuaKuai){
            dispatch_async(dispatch_get_main_queue(), ^{
//                weakSelf.labTime.frame = CGRectMake(MPT_ScreenW - 50, CGRectGetMaxY(weakSelf.playerView.frame) - 27, 45, 21);
//
//                [weakSelf updateTime:weakSelf.fltEndPlayTime - weakSelf.fltPlayTime];
//                if (!isHuaKuai)
//                {
//                    weakSelf.fltSeekTime = 0;
//                }
//                [weakSelf.videoEngine seekServiceDone];
//
//                /// 如果时间有变化就重新改变播放位置
//                if (weakSelf.fltPlayTimeLast != weakSelf.fltPlayTime || weakSelf.fltEndPlayTimeLast != weakSelf.fltEndPlayTime)
//                {
//                    weakSelf.fltPlayTimeLast = weakSelf.fltPlayTime;
//                    weakSelf.fltEndPlayTimeLast = weakSelf.fltEndPlayTime;
//                    CMTimeRange  timeRange = CMTimeRangeMake(CMTimeMakeWithSeconds(weakSelf.fltPlayTimeLast, 30), CMTimeMakeWithSeconds(weakSelf.fltEndPlayTimeLast - weakSelf.fltPlayTimeLast, 30));
//                    weakSelf.videoEngine.videoRange = timeRange;
//                }
            });
        }];
        
        
        /// 显示的时间
        _labTime = [[UILabel alloc] initWithFrame:CGRectMake(MPT_ScreenW - 50,300 - 27, 45, 21)];
        _labTime.textColor = [UIColor whiteColor];
        _labTime.clipsToBounds = YES;
        _labTime.layer.cornerRadius = 2;
        _labTime.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        _labTime.font = [UIFont systemFontOfSize:12];
        _labTime.textAlignment = NSTextAlignmentCenter;
//        [self updateTime:_fltEndPlayTimeLast];
        [self.view addSubview:_labTime];
    }
    else
    {
//        [_viewBeiJing bringSubviewToFront:_viewCaiJian];
        _labTime.hidden = NO;
    }
    
    return _viewCaiJian;
}

@end
