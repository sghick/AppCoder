
//
//  ACRTempleteListController.m
//  AppCoder
//
//  Created by 丁治文 on 2018/11/17.
//  Copyright © 2018年 sumrise.com. All rights reserved.
//

#import "ACRTempleteListController.h"
#import "ACRAppModels.h"
#import "ACRAppDataBase.h"

@interface ACRTempleteListController ()

@end

@implementation ACRTempleteListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self addAnDefaultAppTemplete];
}

- (void)addAnDefaultAppTemplete {
    ACRMetaProperty *ppt1 = [[ACRMetaProperty alloc] init];
    ppt1.title = @"APP名称";
    ppt1.symbols = @"AppName";
    ppt1.des = @"APP名称";
    
    ACRTempleteMeta *appMeta = [[ACRTempleteMeta alloc] init];
    appMeta.identifier = [NSUUID UUID].UUIDString;
    appMeta.name = @"空白App";
    appMeta.meta_group = @"root";
    appMeta.rem = @"APP";
    appMeta.code = @"this is a code";
    appMeta.inputs = @[ppt1];
    
    ACRMetaProperty *clsppt = [[ACRMetaProperty alloc] init];
    clsppt.title = @"类名";
    clsppt.des = @"AppDelegate";

    ACRTempleteMeta *structMeta = [[ACRTempleteMeta alloc] init];
    structMeta.identifier = [NSUUID UUID].UUIDString;
    structMeta.name = @"AppDelegate";
    structMeta.meta_group = @"AppDelegate模版";
    structMeta.rem = @"AppDelegate";
    structMeta.code = @"this is a delegate code";
    structMeta.inputs = @[clsppt];

    appMeta.subTempletes = @[structMeta.identifier];
    
    [ACRAppDataBase deleteAllMetas];
    [ACRAppDataBase insertOrReplaceMetas:@[appMeta, structMeta]];
    
    NSLog(@"更新模版成功");
}

@end
