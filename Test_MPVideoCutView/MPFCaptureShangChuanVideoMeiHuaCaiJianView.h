//
//  MPFCaptureShangChuanVideoMeiHuaCaiJianView.h
//  MiaoPai
//
//  Created by HouGeng on 17/8/4.
//  Copyright © 2017年 Jeakin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    KaiShi = 1,
    JieShu,
} CaiJianType;

/// 图片选择框
@interface MPFImageViewMask : UIView

/// 选取时间的回调 哪个按钮  时间的中心点
@property (nonatomic, copy) void(^MPFImageViewMaskBlock) (CaiJianType type, CGFloat fltTime, CGFloat fltCenterY);

/// 停止了滑动
@property (nonatomic, copy) void(^MPFImageViewMaskEndBlock) ();

/// 点击了裁剪区域的block
@property (nonatomic, copy) void(^MPFImageViewMaskClickBlock) (CGFloat fltTime, CGFloat fltCenterY);

@end


/// 图片缩略图
@interface MPFCaptureShangChuanVideoMeiHuaCaiJianView : UIView

/// 创建
- (instancetype)initWithFrame:(CGRect)frame maryImages:(NSMutableArray *)maryImages videoDuration:(CGFloat)videoDuration;

/// 选取时间的回调 哪个按钮  时间的中心点
@property (nonatomic, copy) void(^MPFCaptureShangChuanVideoMeiHuaCaiJianViewBlock) (CaiJianType type, CGFloat fltTime, CGFloat fltCenterY);

/// 停止了滑动
@property (nonatomic, copy) void(^MPFCaptureShangChuanVideoMeiHuaCaiJianViewEndBlock) (BOOL isHuaKuai);

///滑动了滑块
@property (nonatomic, copy) void(^MPFCaptureShangChuanVideoMeiHuaCaiJianViewHuaKuaiBlock) (CGFloat fltTime);

/// 设置播放时间
- (void)setPlayProgressTime:(CGFloat)fltTime;

- (void)setimageData:(UIImage *)image index:(NSInteger)index;

@end
