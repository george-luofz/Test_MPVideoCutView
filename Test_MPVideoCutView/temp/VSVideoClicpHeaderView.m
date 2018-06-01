//
//  VSVideoClicpHeaderView.m
//  Test_MPVideoCutView
//
//  Created by 罗富中 on 2018/6/2.
//  Copyright © 2018年 George_luofz. All rights reserved.
//

#import "VSVideoClicpHeaderView.h"

@implementation VSVideoClicpHeaderView{
    RotateButtonHandler _rotateHandler;
    CGFloat _currentRoate; // 记录当前旋转角度
}

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.backgroundColor = [UIColor clearColor];
        [self _addSubViews];
    }
    return self;
}

- (void)addRotateButtonHandler:(RotateButtonHandler)handler{
    _rotateHandler = handler;
}
- (void)updateLabelTitle:(NSString *)title{
    _label.text = title;
    
    CGSize size = [title sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:17.0f]}];
    _label.bounds = CGRectMake(0, 0, size.width, _label.frame.size.height);
}

#pragma mark -- subView
- (void)_addSubViews{
    // 1.label
    // 2.button
    
    UIView *viewContainer = [[UIView alloc] initWithFrame:self.bounds];
    viewContainer.backgroundColor = [UIColor blackColor];
    viewContainer.alpha = 0.5;
    [self addSubview:viewContainer];
    
    UILabel *label = [[UILabel alloc] init];
    label.bounds = CGRectMake(148, 540, 100, 21); //动态计算宽度
    label.center = self.center;
    label.text = @"已选择900s";
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1/1.0];
    _label = label;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(self.frame.size.width - 15 - 80, (self.frame.size.height - 21)/2, 80, 21);
    btn.contentHorizontalAlignment= UIControlContentHorizontalAlignmentRight;
    [btn setTitle:@"水平翻转" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    btn.showsTouchWhenHighlighted = NO;
    [btn addTarget:self action:@selector(_btnClicked) forControlEvents:UIControlEventTouchUpInside];
    _rotateButton = btn;

    [viewContainer addSubview:label];
    [self addSubview:btn];
}

- (void)_btnClicked{
    if(_currentRoate < 2){
        _currentRoate += 0.5;
    }else if(_currentRoate == 2){
        _currentRoate = 0.5;
    }
    if(_rotateHandler)(_rotateHandler(_currentRoate));
}
@end
