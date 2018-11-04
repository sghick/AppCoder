//
//  ACRAppEditController.m
//  AppCoder
//
//  Created by 丁治文 on 2018/10/31.
//  Copyright © 2018年 sumrise.com. All rights reserved.
//

#import "ACRAppEditController.h"
#import "ACRAppModels.h"

@interface ACRAppEditController ()

@end

@implementation ACRAppEditController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    self.navigationItem.title = self.appInfo.name;
}

@end
