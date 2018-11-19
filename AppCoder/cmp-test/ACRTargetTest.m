//
//  ACRTargetTest.m
//  AppCoder
//
//  Created by 丁治文 on 2018/11/19.
//  Copyright © 2018年 sumrise.com. All rights reserved.
//

#import "ACRTargetTest.h"
#import "ACRTestController.h"

@implementation ACRTargetTest

+ (UIViewController *)mainController {
    ACRTestController *vc = [[ACRTestController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    vc.navigationController.tabBarItem.title = @"测试";
    return nav;
}

@end
