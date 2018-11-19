//
//  ACRTestController.m
//  AppCoder
//
//  Created by 丁治文 on 2018/11/19.
//  Copyright © 2018年 sumrise.com. All rights reserved.
//

#import "ACRTestController.h"
#import "ACRAppDataBase.h"

@interface ACRTestController ()

@end

@implementation ACRTestController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [ACRAppDataBase deleteAllMetas];
    [ACRAppDataBase deleteAllAppInfos];
    NSLog(@"清除数据成功");
}

@end
