//
//  ACRTargetTempletes.m
//  AppCoder
//
//  Created by 丁治文 on 2018/11/17.
//  Copyright © 2018年 sumrise.com. All rights reserved.
//

#import "ACRTargetTempletes.h"
#import "ACRTempleteListController.h"

@implementation ACRTargetTempletes

+ (UIViewController *)mainController {
    ACRTempleteListController *vc = [[ACRTempleteListController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    vc.navigationController.tabBarItem.title = @"模板";
    return nav;
}

@end
