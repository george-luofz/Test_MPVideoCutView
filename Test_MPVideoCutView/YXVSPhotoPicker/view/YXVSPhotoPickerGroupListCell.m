//
//  YXVSPhotoPickerGroupListCell.m
//  Test_MPVideoCutView
//
//  Created by 罗富中 on 2018/5/31.
//  Copyright © 2018年 George_luofz. All rights reserved.
//

#import "YXVSPhotoPickerGroupListCell.h"

@implementation YXVSPhotoPickerGroupListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    [self _addSubViews];
    return self;
}

- (void)_addSubViews{
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 60, 60)];
    imgView.backgroundColor = [UIColor redColor];
    imgView.contentMode = UIViewContentModeScaleAspectFill;
    imgView.clipsToBounds = YES;
    [self.contentView addSubview:imgView];
    _imgView = imgView;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imgView.frame)+15, 28, 200, 25)];
    label.font = [UIFont systemFontOfSize:18];
    label.textColor = [UIColor colorWithRed:59/255.0 green:66/255.0 blue:76/255.0 alpha:1/1.0];
    [self.contentView addSubview:label];
    _label = label;
}

@end
