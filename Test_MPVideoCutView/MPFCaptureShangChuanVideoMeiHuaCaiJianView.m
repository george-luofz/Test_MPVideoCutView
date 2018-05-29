//
//  MPFCaptureShangChuanVideoMeiHuaCaiJianView.m
//  MiaoPai
//
//  Created by HouGeng on 17/8/4.
//  Copyright © 2017年 Jeakin. All rights reserved.
//

#import "MPFCaptureShangChuanVideoMeiHuaCaiJianView.h"


@interface MPFImageViewMask ()

/// 左边控制
@property (nonatomic, strong) UIImageView *btnLeft;

/// 右边控制
@property (nonatomic, strong) UIImageView *btnRight;

/// 时长
@property (nonatomic, assign) CGFloat videoDuration;

/// 裁剪最大
@property (nonatomic, assign) CGFloat fltClipMax;

/// 裁剪最小
@property (nonatomic, assign) CGFloat fltClipMin;

/// 时间精度对应的长度
@property (nonatomic, assign) CGFloat fltTimeTempLet;

@end

@implementation MPFImageViewMask

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setVideoDuration:(CGFloat)videoDuration
{
    _videoDuration = videoDuration;
    [self initSubviews];
}

- (void)initSubviews
{
    _fltTimeTempLet = (CGRectGetWidth(self.frame) - 40) / _videoDuration;
    
    _fltClipMax = 900 * _fltTimeTempLet;
    
    _fltClipMin = 3 * _fltTimeTempLet;
    
    self.btnLeft = [[UIImageView alloc] init];
    self.btnLeft.backgroundColor = [UIColor clearColor];
//    self.btnLeft.image = [UIImage imageNamed:@"paishehuakuaishoubing"];
    [_btnLeft setBackgroundColor:[UIColor orangeColor]];
    self.btnLeft.frame = CGRectMake(0, 0, 25, 66);
    self.btnLeft.contentMode = UIViewContentModeCenter;
    self.btnLeft.userInteractionEnabled = YES;
    [self addSubview:self.btnLeft];
    
    self.btnRight = [[UIImageView alloc] init];
    self.btnRight.backgroundColor = [UIColor clearColor];
    
    if (_videoDuration > 900)
    {
        self.btnRight.frame = CGRectMake(_fltClipMax + 25 - 10, 0, 25, 66);
        ;
    }
    else
    {
        self.btnRight.frame = CGRectMake(self.frame.size.width - 25, 0, 25, 66);
    }
    
    self.btnRight.image = [UIImage imageNamed:@"paishehuakuaishoubing"];
    [_btnRight setBackgroundColor:[UIColor orangeColor]];
    self.btnRight.contentMode = UIViewContentModeCenter;
    self.btnRight.userInteractionEnabled = YES;
    [self addSubview:self.btnRight];
    
    UIPanGestureRecognizer *leftPan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognizer:)];
    [self.btnLeft addGestureRecognizer:leftPan];
    
    UIPanGestureRecognizer *rightPan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognizer:)];
    [self.btnRight addGestureRecognizer:rightPan];
    
    /// 点击选择框内白条跟随
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self addGestureRecognizer:tap];
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGContextClearRect(context, rect);
//    UIColor *aColor = [UIColor yellowColor];
//    CGContextSetFillColorWithColor(context,aColor.CGColor);
    
//    /// 左
    CGContextFillRect(context, CGRectMake(0,
                                          0,
                                          CGRectGetMinX(_btnLeft.frame)+5,
                                          self.frame.size.height));
    
    /// 右
    CGContextFillRect(context, CGRectMake(CGRectGetMaxX(_btnRight.frame)-5,
                                          0,
                                          self.frame.size.width -  CGRectGetMaxX(_btnRight.frame)+5,
                                          self.frame.size.height));
    
    CGContextSetFillColorWithColor(context,[UIColor blueColor].CGColor);
    
    ///  上线
    CGContextFillRect(context, CGRectMake(CGRectGetMaxX(_btnLeft.frame)-6,
                                          0,
                                          CGRectGetMinX(_btnRight.frame) - CGRectGetMaxX(_btnLeft.frame)+12,
                                          5));
    /// 下线
    CGContextFillRect(context, CGRectMake(CGRectGetMaxX(_btnLeft.frame) - 6,
                                          self.frame.size.height - 5,
                                          CGRectGetMinX(_btnRight.frame) - CGRectGetMaxX(_btnLeft.frame)+12,
                                          5));
    CGContextRestoreGState(context);
}


/// 点击选择框的区域
- (void)tap:(UITapGestureRecognizer *)gestureRecognizer
{
    CGPoint curPoint = [gestureRecognizer locationInView:self];
    if (curPoint.x >= CGRectGetMaxX(_btnLeft.frame)- 5 && curPoint.x <= CGRectGetMinX(_btnRight.frame)+5)
    {
        if (self.MPFImageViewMaskClickBlock)
        {
            CGFloat fltTime =  (curPoint.x - 20) / _fltTimeTempLet;
            self.MPFImageViewMaskClickBlock(fltTime, curPoint.x);
        }
    }
}

/// 裁剪区域计算
- (void)panGestureRecognizer:(UIPanGestureRecognizer *)gestureRecognizer
{
    CGPoint curPoint = [gestureRecognizer locationInView:self];
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan)
    {

    }
    else if (gestureRecognizer.state == UIGestureRecognizerStateChanged)
    {

        if ([gestureRecognizer.view isEqual:self.btnLeft])
        {
            /// 当前选取的长度
            CGFloat fltWith = ((CGRectGetMinX(_btnRight.frame)+5) - curPoint.x);
            
            
            if (curPoint.x < 20)
            {
                curPoint.x = 20;
            }
            
            if (fltWith > _fltClipMax)
            {
                curPoint.x = (CGRectGetMinX(_btnRight.frame)+5) - _fltClipMax;
            }
            
            if (fltWith < _fltClipMin)
            {
                curPoint.x = (CGRectGetMinX(_btnRight.frame)+5) - _fltClipMin;
            }
            
            self.btnLeft.frame = CGRectMake(curPoint.x -20, self.btnLeft.frame.origin.y, self.btnLeft.frame.size.width, self.btnLeft.frame.size.height);
        }
        else
        {
            /// 当前选取的长度
            CGFloat fltWith = (curPoint.x - (CGRectGetMaxX(_btnLeft.frame)-5));
            if (curPoint.x > self.frame.size.width - 20)
            {
                curPoint.x = self.frame.size.width - 20;
            }
            
            if (fltWith > _fltClipMax)
            {
                curPoint.x = (CGRectGetMaxX(_btnLeft.frame)-5) + _fltClipMax;
            }
            
            if (fltWith < _fltClipMin)
            {
                curPoint.x = (CGRectGetMaxX(_btnLeft.frame)-5) + _fltClipMin;
            }
            
            self.btnRight.frame = CGRectMake(curPoint.x - 5, self.btnRight.frame.origin.y, self.btnRight.frame.size.width, self.btnRight.frame.size.height);

        }

        if (self.MPFImageViewMaskBlock)
        {
            BOOL isBegin = [gestureRecognizer.view isEqual:self.btnLeft];
            
            CGFloat fltTime =  ((curPoint.x - 20) / _fltTimeTempLet);
            self.MPFImageViewMaskBlock((isBegin ? KaiShi : JieShu), fltTime, gestureRecognizer.view.center.x);
        }
        [self setNeedsDisplay];
    }
    else /// 停止滑动
    {
        if (self.MPFImageViewMaskEndBlock)
        {
            self.MPFImageViewMaskEndBlock();
        }
    }
}

@end


@interface MPFCaptureShangChuanVideoMeiHuaCaiJianView()

@property (nonatomic, assign) CGFloat videoDuration;

/// 遮罩
@property (nonatomic, strong) MPFImageViewMask *viewMask;

/// 播放进度的白条
@property (nonatomic, strong) UIImageView *viewLine;

/// 滑动滑块时开始播放的位置
@property (nonatomic, assign) CGFloat fltPlayTime;

/// 滑动滑块时结束播放的位置
@property (nonatomic, assign) CGFloat fltEndPlayTime;

@end

@implementation MPFCaptureShangChuanVideoMeiHuaCaiJianView

#pragma mark - ********************** View Lifecycle **********************

- (void)dealloc
{
    // 一定要关注这个函数是否被执行了！！！
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithFrame:(CGRect)frame maryImages:(NSMutableArray *)maryImages videoDuration:(CGFloat)videoDuration
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        _videoDuration = videoDuration;
        
        _fltPlayTime = 0;
        
        if (videoDuration > 900)
        {
            _fltEndPlayTime = 900;
        }
        else
        {
            _fltEndPlayTime = videoDuration;
        }
        
        // 注册消息
        [self regNotification];
        
        // 初始化变量
        [self initVariable];
        
        // 创建相关子view
        [self initMainViews];
    }
    
    return self;
}

-(void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    
    if(newSuperview == nil)
    {
        // 这块需要注意一下，当前view如果在其他地方被移除了的话，要小心下面这行代码！
        [[self subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
        
        return ;
    }
}


#pragma mark - ********************** init and config **********************

/**
 TODO: 初始化变量，例如：分页的page可以在该函数中赋初值
 */
- (void)initVariable
{
    
}

/**
 TODO: 创建相关子view
 */
- (void)initMainViews
{
    self.backgroundColor  = [UIColor greenColor];
    
    /// 滑块
    _viewMask = [[MPFImageViewMask alloc] initWithFrame:CGRectMake(0, 12, [UIScreen mainScreen].bounds.size.width, 66)];
    _viewMask.videoDuration = _videoDuration;
    _viewMask.userInteractionEnabled = YES;
    [self addSubview:_viewMask];
    [_viewMask setNeedsDisplay];
    
    __weak MPFCaptureShangChuanVideoMeiHuaCaiJianView *weakSelf = self;
    [_viewMask setMPFImageViewMaskBlock:^(CaiJianType type, CGFloat time, CGFloat fltX) {
        weakSelf.viewLine.hidden = YES;
        
        if(type == KaiShi)
        {
            _fltPlayTime = time;
        }
        else
        {
            _fltEndPlayTime = time;
        }
        weakSelf.MPFCaptureShangChuanVideoMeiHuaCaiJianViewBlock(type, time, fltX);

    }];
    
    /// 停止滑动
    [_viewMask setMPFImageViewMaskEndBlock:^{
        if (weakSelf.MPFCaptureShangChuanVideoMeiHuaCaiJianViewEndBlock)
        {   
            weakSelf.MPFCaptureShangChuanVideoMeiHuaCaiJianViewEndBlock(NO);
        }
    }];
    
    /// 点击了裁剪区域
    [_viewMask setMPFImageViewMaskClickBlock:^(CGFloat time, CGFloat fltX) {
        weakSelf.viewLine.hidden = NO;
        weakSelf.viewLine.center = CGPointMake(fltX, weakSelf.viewLine.center.y);
        
        if (weakSelf.MPFCaptureShangChuanVideoMeiHuaCaiJianViewHuaKuaiBlock)
        {
            weakSelf.MPFCaptureShangChuanVideoMeiHuaCaiJianViewHuaKuaiBlock(time);
        }
        
        if (weakSelf.MPFCaptureShangChuanVideoMeiHuaCaiJianViewEndBlock)
        {
            weakSelf.MPFCaptureShangChuanVideoMeiHuaCaiJianViewEndBlock(YES);
        }
    }];
    
    /// 进度的白条
    [self insertSubview:self.viewLine aboveSubview:_viewMask];
    
    UIPanGestureRecognizer *Pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(LinepanGestureRecognizer:)];
    [_viewLine addGestureRecognizer:Pan];
}

/**
 TODO: 注册通知
 */
- (void)regNotification
{
    
}


#pragma mark - ******************************************* 对外方法 **********************************

/// 设置图片
- (void)setimageData:(UIImage *)image index:(NSInteger)index
{
    return;
    if (image)
    {
        CGFloat picWith = (self.frame.size.width - 40)/6;
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        CGRect frame = imageView.frame;
        frame.origin.x = 20 +index * picWith;
        frame.origin.y = (self.frame.size.height - picWith)/2.0;
        frame.size.width = picWith;
        frame.size.height = picWith;
        imageView.frame = frame;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        [self insertSubview:imageView belowSubview:_viewMask];

    }
}

- (void)setPlayProgressTime:(CGFloat)fltTime
{
    _viewLine.hidden = NO;
    CGFloat fltX = fltTime  / _videoDuration * (CGRectGetWidth(self.frame) - 40)  +20;
    if (_videoDuration * (CGRectGetWidth(self.frame) - 40) != 0)
    {
        _viewLine.center = CGPointMake(fltX, _viewLine.center.y);
    }
}

#pragma mark - ******************************************* 基类方法(一般发生在重写函数) ****************


#pragma mark - ******************************************* Touch Event ***********************

/// 裁剪区域计算
- (void)LinepanGestureRecognizer:(UIPanGestureRecognizer *)gestureRecognizer
{
    CGPoint curPoint = [gestureRecognizer locationInView:self];
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan)
    {
        
    }
    else if (gestureRecognizer.state == UIGestureRecognizerStateChanged)
    {
        /// 当前时间点
        CGFloat fltTime =  (curPoint.x - 20) / ((CGRectGetWidth(self.frame) - 40) / _videoDuration);

        if (fltTime < _fltPlayTime || fltTime > _fltEndPlayTime)
        {
            return;
        }
        _viewLine.center = CGPointMake(curPoint.x, _viewLine.center.y);
        if (self.MPFCaptureShangChuanVideoMeiHuaCaiJianViewHuaKuaiBlock)
        {
            self.MPFCaptureShangChuanVideoMeiHuaCaiJianViewHuaKuaiBlock(fltTime);
        }
        
    }
    else /// 停止滑动
    {
        if (self.MPFCaptureShangChuanVideoMeiHuaCaiJianViewEndBlock)
        {
            self.MPFCaptureShangChuanVideoMeiHuaCaiJianViewEndBlock(YES);
        }
    }
}


#pragma mark - ******************************************* 私有方法 **********************************


#pragma mark - ******************************************* Net Connection Event ********************

#pragma mark - 请求 demo

- (void)req_url_demo
{
    
}


#pragma mark - ******************************************* Delegate Event **************************


#pragma mark - ******************************************* Notification Event **********************

#pragma mark - 通知 demo

- (void)notification_demo:(NSNotification *)aNotification
{
    
}


#pragma mark - ******************************************* 属性变量的 Set 和 Get 方法 *****************

- (UIView *)viewLine
{
    if (!_viewLine)
    {
        /// 播放的进度
        _viewLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 25, 60)];
        _viewLine.image = [UIImage imageNamed:@"recorder_huakuai_jjindu"];
        _viewLine.contentMode = UIViewContentModeCenter;
        _viewLine.userInteractionEnabled = YES;
        _viewLine.center = CGPointMake(12.5, 45);
        _viewLine.backgroundColor = [UIColor redColor];
    }
    
    return _viewLine;
}

@end
