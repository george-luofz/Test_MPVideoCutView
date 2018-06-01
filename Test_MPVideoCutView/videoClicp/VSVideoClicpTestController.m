//
//  VSVideoClicpTestController.m
//  Test_MPVideoCutView
//
//  Created by 罗富中 on 2018/6/2.
//  Copyright © 2018年 George_luofz. All rights reserved.
//

#import "VSVideoClicpTestController.h"
#import "VSVideoClicpViewHandler.h"

@interface VSVideoClicpTestController()<VSVideoClicpViewHandlerDelegate>{
    VSVideoClicpViewHandler *_viewHander;
}
@end
@implementation VSVideoClicpTestController

- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _viewHander = [[VSVideoClicpViewHandler alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 44 - 95, self.view.frame.size.width, 44 + 95)];
    _viewHander.delegate = self;
    [self.view addSubview:_viewHander];
}


@end
