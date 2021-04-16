//
//  APPViewController.m
//  PoporFloatBT
//
//  Created by popor on 04/15/2021.
//  Copyright (c) 2021 popor. All rights reserved.
//

#import "RootVC.h"
#import "PoporFloatTV.h"

@interface RootVC ()

@end

@implementation RootVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILabel * oneL = ({
        UILabel * oneL = [UILabel new];
        oneL.frame               = CGRectMake(0, 100, self.view.frame.size.width, 44);
        oneL.backgroundColor     = [UIColor whiteColor]; // ios8 之前
        oneL.font                = [UIFont systemFontOfSize:15];
        oneL.textColor           = [UIColor blackColor];
        oneL.layer.masksToBounds = YES; // ios8 之后 lableLayer 问题
        oneL.numberOfLines       = 1;
        oneL.textAlignment       = NSTextAlignmentCenter;
        
        [self.view addSubview:oneL];
        oneL;
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        PoporFloatTV * ptv = [PoporFloatTV share];
        
        {
            NSArray * cellArray = @[
                PfeInit (11, @"网络请求"),
                PfeInit (12, @"域名配置"),
                PfeClose(13, @"测试1", NO),
            ];
            UIButton * bt = [ptv addBtSize:CGSizeMake(50, 50) cellArray:cellArray];
            [bt setTitle:@"1" forState:UIControlStateNormal];
        }
        
        {
            NSArray * cellArray = @[
                PfeInit(20, @"网络请求"),
                PfeInit(21, @"域名配置"),
                PfeInit(22, @"测试1"),
                PfeInit(23, @"监测内存"),
                PfeInit(24, @"测试3"),
                PfeInit(25, @"H5"),
            ];
            UIButton * bt = [ptv addBtSize:CGSizeMake(50, 50) cellArray:cellArray];
            [bt setTitle:@"2" forState:UIControlStateNormal];
        }
        
        {
            UIButton * bt = [ptv addBtSize:CGSizeMake(50, 50) cellArray:nil];
            [bt setTitle:@"单独" forState:UIControlStateNormal];
        }
        
        ptv.btSelectBlock = ^(UIButton * _Nonnull bt) {
            oneL.text = [NSString stringWithFormat:@"❗️❗️ bt tag: %li, title:%@", (long)bt.tag, bt.currentTitle];
        };
        
        ptv.tvSelectBlock = ^(PoporFloatEntity * _Nonnull pfEntity) {
            oneL.text = [NSString stringWithFormat:@"✅✅ cell tag: %li, title: %@", (long)pfEntity.tag, pfEntity.title];
        };
        
        
        [ptv addDefaultShowGR];
        
        [ptv showFloatView:NO];
    });
    
    // iPhone 模拟器也可以记录最后拖拽的点, 前提是不能由xcode中止APP.
}


@end
