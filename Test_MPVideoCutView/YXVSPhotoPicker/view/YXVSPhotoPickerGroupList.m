//
//  YXVSPhotoPickerGroupList.m
//  Test_MPVideoCutView
//
//  Created by 罗富中 on 2018/5/31.
//  Copyright © 2018年 George_luofz. All rights reserved.
//

#import "YXVSPhotoPickerGroupList.h"
#import "YXVSPhotoPickerGroupListCell.h"
#import "YXVSPhotoAlbumManager.h"

CGFloat static YXVSPhotoPickerTableViewCellHeight = 80;


@interface YXVSPhotoPickerGroupList() <UITableViewDelegate,UITableViewDataSource>
{
    UITableView     *_tableView;
    CGRect _originalFrame;
}
@end
@implementation YXVSPhotoPickerGroupList

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        _originalFrame = frame;
        self.backgroundColor = [UIColor redColor];
        [self _addSubViews];
    }
    return self;
}

- (void)setDataSource:(NSArray<PHAssetCollection *> *)dataSource{
    _dataSource = dataSource;
    [_tableView reloadData];
}


- (void)showWithView:(UIView *)view{
    __weak __typeof(self) weakSelf = self;
    self.hidden = NO;
    view.hidden = NO;
    view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveLinear animations:^{
        __strong __typeof(self) strongSelf = weakSelf;
        view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
        strongSelf.frame = _originalFrame;
    } completion:^(BOOL finished) {

    }];
}

- (void)dismissWithView:(UIView *)view{
    __weak __typeof(self) weakSelf = self;
    view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.75];
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:1.0 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveLinear animations:^{
        __strong __typeof(self) strongSelf = weakSelf;
        strongSelf.frame = [strongSelf _hideFrame];
        view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
    } completion:^(BOOL finished) {
        view.hidden = YES;
        self.hidden = YES;
    }];
    
}

- (CGRect)_hideFrame{
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat y = [self _isIphoneX] ? screenHeight - 34 : screenHeight;
    return CGRectMake(0, y, self.frame.size.width, self.frame.size.height);
}
- (BOOL)_isIphoneX{
    return [UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO;
}
- (void)_addSubViews{
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.bounds];
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView registerClass:[YXVSPhotoPickerGroupListCell class] forCellReuseIdentifier:@"myCell"];
    tableView.tableFooterView = [UIView new];
    [self addSubview:tableView];
    
    _tableView = tableView;
}

#pragma mark -- tableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return YXVSPhotoPickerTableViewCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YXVSPhotoPickerGroupListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myCell"];
    if(cell == nil){
        cell = [[YXVSPhotoPickerGroupListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"myCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    // update cell
    [self _updateCell:cell atIndexpath:indexPath];
    return cell;
}

- (void)_updateCell:(YXVSPhotoPickerGroupListCell *)cell atIndexpath:(NSIndexPath *)indexPath{
    PHAssetCollection *collection = _dataSource[indexPath.row];
    cell.label.text = [NSString stringWithFormat:@"%@ (%ld)",collection.localizedTitle,[[YXVSPhotoAlbumManager sharedInstance] theFetchResultVideoInAssetCollection:collection].count];
    [[YXVSPhotoAlbumManager sharedInstance] theCoverVideoInPHAssetGroup:collection PHImageInfo:^(UIImage *photo, PHAsset *asset) {
        if(photo){
            cell.imgView.image = photo;
        }
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(self.delegate && [self.delegate respondsToSelector:@selector(YXVSPhotoPickerGroupList:selectAtIndex:)]){
        [self.delegate YXVSPhotoPickerGroupList:self selectAtIndex:indexPath.row];
    }
}

@end
