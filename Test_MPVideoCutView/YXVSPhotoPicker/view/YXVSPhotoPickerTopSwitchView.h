//
//  YXVSPhotoPickerTopSwitchView.h
//  Test_MPVideoCutView
//
//  Created by 罗富中 on 2018/5/31.
//  Copyright © 2018年 George_luofz. All rights reserved.
//  头部反转视图，上转、下转

#import <UIKit/UIKit.h>

typedef void (^ClickHandler)(BOOL isSelected);
@interface YXVSPhotoPickerTopSwitchView : UIView

@property (nonatomic, strong) UIButton *switchButton;
@property (nonatomic, strong) NSString *title;

- (void)addClickHandler:(ClickHandler)handler;
- (void)clickTitle;
@end
