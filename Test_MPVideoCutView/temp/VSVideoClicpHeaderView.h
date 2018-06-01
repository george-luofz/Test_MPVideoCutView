//
//  VSVideoClicpHeaderView.h
//  Test_MPVideoCutView
//
//  Created by 罗富中 on 2018/6/2.
//  Copyright © 2018年 George_luofz. All rights reserved.
//  裁剪页头部视图
//  功能：
//  1. 上方操作提示label，已选择多少秒；最短多少秒；水平翻转按钮

#import <UIKit/UIKit.h>

typedef void (^RotateButtonHandler)(CGFloat rotate);
@interface VSVideoClicpHeaderView : UIView

@property (nonatomic, strong, readonly) UILabel *label; //提示框
@property (nonatomic, strong, readonly) UIButton *rotateButton; //翻转按钮
// 翻转按钮点击事件
- (void)addRotateButtonHandler:(RotateButtonHandler)handler;
// 更新提示框title
- (void)updateLabelTitle:(NSString *)title;

@end
