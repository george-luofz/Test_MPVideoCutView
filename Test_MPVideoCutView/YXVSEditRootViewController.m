//
//  YXVSEditRootViewController.m
//  Test_MPVideoCutView
//
//  Created by 罗富中 on 2018/5/29.
//  Copyright © 2018年 George_luofz. All rights reserved.
//

#import "YXVSEditRootViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface YXVSEditRootViewController (){
    NSURL *_videoUrl;
    AVPlayer *_player;
}
@end

@implementation YXVSEditRootViewController
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

- (instancetype)initWithVideoUrl:(NSURL *)url{
    if(self = [super init]){
        _videoUrl = url;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self _addSubViews];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self _setUpNavigationBar];
}

#pragma mark -- navigation Bar
- (void)_setUpNavigationBar{
    if(!self.navigationController) return;
    if(self.navigationController.navigationBar.hidden){
        [self.navigationController.navigationBar setHidden:NO];
    }
    // 导航栏透明
//    self.navigationController.navigationBar.alpha = 0;
    //设置导航栏背景图片为一个空的image，这样就透明了
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    //去掉透明后导航栏下边的黑边
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"发布" forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor colorWithRed:0.918 green:0.322 blue:0.388 alpha:1.00]];
    btn.layer.cornerRadius = 2.f;
    btn.frame = CGRectMake(0, 0, 58, 28);
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    [btn addTarget:self action:@selector(_uploadBtnClciked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = rightBarItem;
}
#pragma mark -- subView

- (void)_addSubViews{
    
    [self _addPlayer];
    [self _addBtns];
    
}
- (void)_addPlayer{
    // TODO: change Url
    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"nianhui" ofType:@"mp4"]];
//    NSURL *url = _videoUrl;
    AVPlayer *player = [AVPlayer playerWithURL:url];
    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:player];
    playerLayer.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1/1.0].CGColor;
    
    playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    playerLayer.frame = CGRectMake(0, [self _viewTop], self.view.frame.size.width, self.view.frame.size.height - [self _viewTop] - [self _viewBottom]);
    [self.view.layer addSublayer:playerLayer];
    [player play];
    _player = player;
    
    [self _addSystemNotification];
}
- (void)_addBtns{
    UIView *btnViewContainer = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 82 - [self _viewBottom], self.view.frame.size.width, 82)];
    btnViewContainer.backgroundColor =  [UIColor clearColor];
    [self.view addSubview:btnViewContainer];
    
    UIView *btnViewContainer1 = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 82 - [self _viewBottom], self.view.frame.size.width, 82)];
    btnViewContainer1.alpha = 0.5;
    [self.view addSubview:btnViewContainer1];
    
    NSArray *titleArray = @[@"剪辑",@"音乐",@"特效",@"滤镜"];
    NSArray *imageNameArray = @[@"YXVSCapture_clicpBtn",@"YXVSCapture_musicBtn",@"YXVSCapture_specialBtn",@"YXVSCapture_filterBtn"];
    SEL selectors[4] = {@selector(_clicpBtnClicked:),@selector(_musicBtnClicked:),@selector(_specialBtnClicked:),@selector(_filterBtnClicked:)};
    
    CGFloat leftMagin = 32,middleMagin = 64,topMagin = 15;
    
    CGFloat btnWidth = 30,btnHeight = 60;
    
    for(int i = 0 ;i < 4; i++){
        UIButton *btn = [self _buildBtnWith:titleArray[i] imgName:imageNameArray[i] seletor:selectors[i]];
        btn.frame = CGRectMake(leftMagin + i * (btnWidth + middleMagin), topMagin, btnWidth, btnHeight);
        btn.titleEdgeInsets = UIEdgeInsetsMake(btn.imageView.frame.size.height, -btn.imageView.frame.size.width, 0, 0);
        btn.imageEdgeInsets = UIEdgeInsetsMake(-btn.titleLabel.bounds.size.height-10, 0, 0, -btn.titleLabel.bounds.size.width);
        [btnViewContainer addSubview:btn];
    }
}

- (UIButton *)_buildBtnWith:(NSString *)title imgName:(NSString *)imageName seletor:(SEL)selector{
    UIButton *clipBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [clipBtn setTitle:title forState:UIControlStateNormal];
    [clipBtn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [clipBtn setImage:[UIImage imageNamed:imageName] forState:UIControlStateHighlighted];
    [clipBtn addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    clipBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    return clipBtn;
}
- (CGFloat)_viewTop{
    return _isIphoneX() ? 44 : 0;
}
- (CGFloat)_viewBottom{
    return _isIphoneX() ? 34 : 0;
}

BOOL _isIphoneX(){
    return [UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO;
}
#pragma mark -- click events
// 剪辑
- (void)_clicpBtnClicked:(UIButton *)sender{
    
}
// 音乐
- (void)_musicBtnClicked:(UIButton *)sender{
    
}
// 特效
- (void)_specialBtnClicked:(UIButton *)sender{
    
}
// 滤镜
- (void)_filterBtnClicked:(UIButton *)sender{
    
}
// 发布按钮
- (void)_uploadBtnClciked{
    
}
#pragma mark -- video obsever
- (void)_addSystemNotification {
    // app退到后台
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterBackground) name:UIApplicationWillResignActiveNotification object:nil];
    // app进入前台
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterPlayground) name:UIApplicationDidBecomeActiveNotification object:nil];
    // 视频播放完毕
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayDidEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:_player.currentItem];
}

// 视频循环播放
- (void)moviePlayDidEnd:(NSNotification*)notification{
    AVPlayerItem *item = [notification object];
    [item seekToTime:kCMTimeZero];
    [_player play];
}

- (void)appDidEnterBackground{
    if(_player) [_player pause];
}

- (void)appDidEnterPlayground{
    if(_player) [_player play];
}

- (void)dealloc{
     [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma clang diagnostic pop
@end

