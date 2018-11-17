//
//  ACRTargetList.m
//  AppCoder
//
//  Created by 丁治文 on 2018/11/17.
//  Copyright © 2018年 sumrise.com. All rights reserved.
//

#import "ACRTargetList.h"
#import "ACRListController.h"

@implementation ACRTargetList

+ (UIViewController *)mainController {
    ACRListController *vc = [[ACRListController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    vc.navigationController.tabBarItem.title = @"列表";
    return nav;
}

@end
