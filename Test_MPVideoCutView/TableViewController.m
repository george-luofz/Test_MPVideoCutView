//
//  TableViewController.m
//  Test_MPVideoCutView
//
//  Created by 罗富中 on 2018/5/31.
//  Copyright © 2018年 George_luofz. All rights reserved.
//

#import "TableViewController.h"
#import "YXVSEditRootViewController.h"
#import "YXVSPhotoPickerBeiginViewController.h"
#import "YXVSVideoEditViewController.h"

@interface TableViewController ()
{
    NSArray *_dataSource;
}
@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _dataSource = @[@"发布页",@"相册",@"视频编辑页"];
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myCell"];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"myCell"];
    }
    cell.textLabel.text = _dataSource[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIViewController *vc = nil;
    if(indexPath.row == 0){
        vc = [YXVSEditRootViewController new];
    }else if (indexPath.row == 1){
        vc = [YXVSPhotoPickerBeiginViewController new];
    }else if (indexPath.row == 2){
        vc = [YXVSVideoEditViewController new];
    }
    [self.navigationController pushViewController:vc animated:YES];
}
@end
