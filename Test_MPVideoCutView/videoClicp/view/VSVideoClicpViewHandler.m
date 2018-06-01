//
//  VSVideoClicpViewHandler.m
//  Test_MPVideoCutView
//
//  Created by 罗富中 on 2018/6/2.
//  Copyright © 2018年 George_luofz. All rights reserved.
//

#import "VSVideoClicpViewHandler.h"
#import "VSVideoClicpHeaderView.h"

@interface VSVideoClicpViewHandler()
{
    UIView *_bgViewContainer; //alpha 0.5 背景图
    
    UIView *_headerView;
    UILabel *_label; //提示框
    UIButton *_rotateButton; //翻转按钮
    CGFloat _currentRoate; // 记录当前旋转角度
    
    
}
@end
@implementation VSVideoClicpViewHandler

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self _addSubviews];
    }
    return self;
}

#pragma mark -- subView
- (void)_addSubviews{
    // 1.headerView
    // 2.botomView
    
    UIView *viewContainer = [[UIView alloc] initWithFrame:self.bounds];
    viewContainer.backgroundColor = [UIColor blackColor];
    viewContainer.alpha = 0.5;
    [self addSubview:viewContainer];
    _bgViewContainer = viewContainer;
    
    [self _addHeaderViews];
    [self _addBottomViews];
}

- (void)_addHeaderViews{
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 44)];
    [self addSubview:headerView];
    _headerView = headerView;
    
    UILabel *label = [[UILabel alloc] init];
    label.bounds = CGRectMake(148, 540, 100, 21); //动态计算宽度
    label.center = headerView.center;
    label.text = @"已选择900s";
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1/1.0];
    _label = label;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(headerView.frame.size.width - 15 - 80, (headerView.frame.size.height - 21)/2, 80, 21);
    btn.contentHorizontalAlignment= UIControlContentHorizontalAlignmentRight;
    [btn setTitle:@"水平翻转" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    btn.showsTouchWhenHighlighted = NO;
    [btn addTarget:self action:@selector(_btnClicked) forControlEvents:UIControlEventTouchUpInside];
    _rotateButton = btn;
    
    [_bgViewContainer addSubview:label];
    [headerView addSubview:btn];
}

- (void)_addBottomViews{
    
}
#pragma mark event handler
- (void)_btnClicked{
    if(_currentRoate < 2){
        _currentRoate += 0.5;
    }else if(_currentRoate == 2){
        _currentRoate = 0.5;
    }
    NSLog(@"水平翻转:%lf",_currentRoate);
    if(self && [self.delegate respondsToSelector:@selector(videoClicpViewContainer:flipHorizontalToRotate:)]){
        [self.delegate videoClicpViewContainer:self flipHorizontalToRotate:_currentRoate];
    }
}

- (void)_updateLabelTitle:(NSString *)title{
    _label.text = title;
    
    CGSize size = [title sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15.0f]}];
    _label.bounds = CGRectMake(0, 0, size.width, _label.frame.size.height);
}

@end
