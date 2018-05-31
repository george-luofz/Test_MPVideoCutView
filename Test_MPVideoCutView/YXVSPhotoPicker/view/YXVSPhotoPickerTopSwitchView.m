//
//  YXVSPhotoPickerTopSwitchView.m
//  Test_MPVideoCutView
//
//  Created by 罗富中 on 2018/5/31.
//  Copyright © 2018年 George_luofz. All rights reserved.
// 

#import "YXVSPhotoPickerTopSwitchView.h"

@implementation YXVSPhotoPickerTopSwitchView{
    ClickHandler _clickHandler;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.switchButton.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
//    [self horizontalCenterTitleAndImageRight:5];
    
}
- (void)addClickHandler:(ClickHandler)handler{
    _clickHandler = handler;
}

- (void)clickTitle{
    [self btnClicked:self.switchButton];
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if ( self ) {
        
        self.switchButton = ({
            UIButton *button = [[UIButton alloc]init];
            button.titleLabel.font = [UIFont systemFontOfSize:18];
            [button setTitleColor:[UIColor colorWithRed:34/255 green:34/255 blue:34/255 alpha:1] forState:UIControlStateNormal];
            button.adjustsImageWhenHighlighted = NO;
            [button setImage:[UIImage imageNamed:@"YXVSPhotoPicker_bullet_down"] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"YXVSPhotoPicker_bullet_up"] forState:UIControlStateSelected];
            [button addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
            button;
        });
        [self addSubview:self.switchButton];
    }
    return self;
}

- (void)horizontalCenterTitleAndImageRight:(CGFloat)spacing
{
    CGSize imageSize = CGSizeMake(20, 20);
    
    CGSize titleSize = [self.switchButton.currentTitle boundingRectWithSize:CGSizeMake(200, 44) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18]} context:nil].size;
    
    self.switchButton.titleEdgeInsets = UIEdgeInsetsMake(0.0, - imageSize.width, 0.0, 0.0);
    
    self.switchButton.imageEdgeInsets = UIEdgeInsetsMake(0.0, titleSize.width + imageSize.width + spacing, 0.0, - titleSize.width);
}

- (void)setTitle:(NSString *)title{
    _title = title;
    [self.switchButton setTitle:title forState:UIControlStateNormal];
    [self horizontalCenterTitleAndImageRight:5];
}

- (void)btnClicked:(UIButton *)btn{
    btn.selected = !btn.selected;
    if(_clickHandler)(_clickHandler(btn.selected));
}
@end
