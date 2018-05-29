//
//  YXVSEditRootViewController.m
//  Test_MPVideoCutView
//
//  Created by 罗富中 on 2018/5/29.
//  Copyright © 2018年 George_luofz. All rights reserved.
//

#import "YXVSEditRootViewController.h"



@interface YXVSEditRootViewController ()

@end

@implementation YXVSEditRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self _addSubViews];
}

- (void)_addSubViews{
    [self _addPlayer];
    [self _addBtns];
    
}
- (void)_addPlayer{
    // TODO:
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, [self _viewTop], self.view.frame.size.width, self.view.frame.size.height - [self _viewTop] - [self _viewBottom])];
    imageView.userInteractionEnabled = YES;
    imageView.backgroundColor = [UIColor redColor];
    [self.view addSubview:imageView];
}
- (void)_addBtns{
    UIView *btnViewContainer = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 82 - [self _viewBottom], self.view.frame.size.width, 82)];
    btnViewContainer.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    [self.view addSubview:btnViewContainer];
    
    NSArray *titleArray = @[@"剪辑",@"音乐",@"特效",@"滤镜"];
    NSArray *imageNameArray = @[@"YXVSCapture_clicpBtn",@"YXVSCapture_musicBtn",@"YXVSCapture_specialBtn",@"YXVSCapture_filterBtn"];
    SEL selectors[4] = {@selector(_clicpBtnClicked:),@selector(_clicpBtnClicked:),@selector(_clicpBtnClicked:),@selector(_clicpBtnClicked:)};
    
    CGFloat leftMagin = 32,middleMagin = 64,topMagin = 15;
    CGFloat btnWidth = 30,btnHeight = 60;
    
    for(int i = 0 ;i < 4; i++){
        UIButton *btn = [self _buildBtnWith:titleArray[i] imgName:imageNameArray[i] seletor:selectors[i]];
        btn.frame = CGRectMake(leftMagin + i * (btnWidth + middleMagin), topMagin, btnWidth, btnHeight);
        btn.titleEdgeInsets = UIEdgeInsetsMake(btn.imageView.frame.size.height, -btn.imageView.frame.size.width, -5, 0);
        btn.imageEdgeInsets = UIEdgeInsetsMake(-btn.titleLabel.bounds.size.height, 0, 0, -btn.titleLabel.bounds.size.width);
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
- (void)_clicpBtnClicked:(UIButton *)sender{
    
}
- (void)_musicBtnClicked:(UIButton *)sender{
    
}

- (void)_specialBtnClicked:(UIButton *)sender{
    
}

- (void)_filterBtnClicked:(UIButton *)sender{
    
}

@end
