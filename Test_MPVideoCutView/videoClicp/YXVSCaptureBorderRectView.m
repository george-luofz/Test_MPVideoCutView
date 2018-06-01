//
//  YXVSCaptureBorderRectView.m
//  Test_MPVideoCutView
//
//  Created by 罗富中 on 2018/5/28.
//  Copyright © 2018年 George_luofz. All rights reserved.
//
//
#import "YXVSCaptureBorderRectView.h"

CGFloat const KYXVSCaptureBorderRectViewTopWidth = 5;    //上边框5
CGFloat const KYXVSCaptureBorderRectViewLeftWidth = 15;  //左边框15
CGFloat const KYXVSCaptureBorderRectViewImageWidth = 56; //一个截图的宽度
CGFloat const KYXVSCaptureBorderRectViewImageHeight = KYXVSCaptureBorderRectViewImageWidth; //截图的宽高相等

CGFloat const KYXVSCaptureBorderRectViewLongPressDuration = 0.5; //默认长按0.5s，开始左右滑动
@interface YXVSCaptureBorderRectView(){
    CGFloat _videoDuration; //视频时长，决定了边框的初始长度
    
    UIImageView *_leftBtn;
    UIImageView *_rightBtn;
    
    UIView *_imgViewContainer; //盛放图片的父容器
    
    UIBezierPath *_currentBezierPath;// 用于绘制圆角矩形
}
@end
@implementation YXVSCaptureBorderRectView

- (instancetype)initWithVideoDuration:(CGFloat)videoDuration{
    if(self = [super init]){
        // 1.计算初始化frame
        // 2.划线
        // 3.左右侧按钮加事件
        _videoDuration = videoDuration;

    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.originalWidth = frame.size.width;
        [self _initSubviews];
    }
    return self;
}

- (void)setUpForLayout{
    [self _setUpFrameWithDuration];
    [self _initSubviews];
//    [self _drawRectWithRoundCornerLines];
}

#pragma mark -- private
/**
 由时长布局frame
 */
- (void)_setUpFrameWithDuration{
    CGFloat viewWidth = KYXVSCaptureBorderRectViewLeftWidth * 2 + _videoDuration * KYXVSCaptureBorderRectViewImageWidth;
    CGFloat viewHeight = KYXVSCaptureBorderRectViewImageHeight + 2 * KYXVSCaptureBorderRectViewTopWidth;
    CGRect frame = CGRectMake(0, 0, viewWidth, viewHeight);
    self.frame = frame;
    self.originalWidth = viewWidth;
}

/**
 绘制圆角矩形
 */
- (void)_drawRectWithRoundCornerLines{
    // 1.清理之前的绘制
    // 2.绘制新的
    
    if(_currentBezierPath){
        _currentBezierPath = nil;
        [self setNeedsDisplay];
    }
    CGRect drawRect = CGRectMake(KYXVSCaptureBorderRectViewLeftWidth, KYXVSCaptureBorderRectViewTopWidth, self.bounds.size.width - 2 * KYXVSCaptureBorderRectViewLeftWidth, KYXVSCaptureBorderRectViewImageHeight);
    UIBezierPath *rectangle = [UIBezierPath bezierPathWithRect:drawRect];
//    边框线宽
    rectangle.lineWidth = KYXVSCaptureBorderRectViewTopWidth;
//    边框线颜色
    [[UIColor blueColor] setStroke];
//    线条之间连接点形状 圆角
    rectangle.lineJoinStyle = kCGLineJoinRound;
//    绘制边框
    [rectangle stroke];
    //全局保存
    _currentBezierPath =  rectangle;
    
    //不需要在drawRect中绘制
//    CAShapeLayer *lines = [CAShapeLayer layer];
//    lines.path = rectangle.CGPath;
//
//    lines.strokeColor = [UIColor blueColor].CGColor;
//
//    lines.lineWidth = KYXVSCaptureBorderRectViewTopWidth;
//
//    lines.lineJoin = @"round";
//
//    [self.layer insertSublayer:lines atIndex:0];
//    [self setNeedsDisplay];
//    [self layoutIfNeeded];
}

/**
 当frame改变时，修正左右两个btn、imgViewContainer的frame
 */
- (void)_changeSubViewFrames{
    if(_leftBtn == nil) return;
    
    _leftBtn.frame = [self _caculateLeftBtnFrame];
    _rightBtn.frame = [self _caculateRightBtnFrame];
}

- (void)_initSubviews{
    // 1._leftBtn、_rightBtn
    UIImageView *leftBtn = [[UIImageView alloc] initWithFrame:[self _caculateLeftBtnFrame]];
    UIImageView *rightBtn = [[UIImageView alloc] initWithFrame:[self _caculateRightBtnFrame]];
    leftBtn.image = nil; //TODO:
    rightBtn.image = nil;
    
    leftBtn.backgroundColor = [UIColor redColor];
    rightBtn.backgroundColor = [UIColor redColor];
    
    leftBtn.layer.cornerRadius = 5.f;
    rightBtn.layer.cornerRadius = 5.f;
    
    leftBtn.userInteractionEnabled = YES;
    rightBtn.userInteractionEnabled = YES;
    
    UILongPressGestureRecognizer *leftLongPressReg = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(_longPressHanlder:)];
    leftLongPressReg.minimumPressDuration = KYXVSCaptureBorderRectViewLongPressDuration;
    
    UILongPressGestureRecognizer *rightLongPressReg = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(_longPressHanlder:)];
    rightLongPressReg.minimumPressDuration = KYXVSCaptureBorderRectViewLongPressDuration;
    
    [leftBtn addGestureRecognizer:leftLongPressReg];
    [rightBtn addGestureRecognizer:rightLongPressReg];
    
    [self addSubview:leftBtn];
    [self addSubview:rightBtn];
    _leftBtn = leftBtn;
    _rightBtn = rightBtn;
}

- (void)_longPressHanlder:(UILongPressGestureRecognizer *)longPressReg{
    NSString *str = nil;
    if([longPressReg.view isEqual:_leftBtn]){
        str = @"左边";
        [self.longPressDelegate YXVSCaptureBorderRectView:self leftBtnLongPressed:longPressReg];
    }else{
        str = @"右边";
        [self.longPressDelegate YXVSCaptureBorderRectView:self rightBtnLongPressed:longPressReg];
    }
    NSLog(@"%@,%s,point:%@",str,__func__,NSStringFromCGPoint([longPressReg locationInView:self.superview]));
}

- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    [self _changeSubViewFrames];
}

- (void)drawRect:(CGRect)rect{
    [self _drawRectWithRoundCornerLines];
}
#pragma mark -- caculate frames
- (CGRect)_caculateLeftBtnFrame{
    return CGRectMake(0, 0, KYXVSCaptureBorderRectViewLeftWidth, self.frame.size.height);
}
- (CGRect)_caculateRightBtnFrame{
    return CGRectMake(self.frame.size.width-KYXVSCaptureBorderRectViewLeftWidth, 0, KYXVSCaptureBorderRectViewLeftWidth, self.frame.size.height);
}
@end
