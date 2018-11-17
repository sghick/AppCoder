//
//  ACRAppInfoController.m
//  AppCoder
//
//  Created by 丁治文 on 2018/11/2.
//  Copyright © 2018年 sumrise.com. All rights reserved.
//

#import "ACRAppInfoController.h"
#import "PureLayout.h"
#import "ACRAppModels.h"

@interface ACRAppInfoController ()

@property (strong, nonatomic) UITextField *appNameInput;
@property (strong, nonatomic) UIButton *sureBtn;

@end

@implementation ACRAppInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    self.navigationItem.title = self.appInfo?@"编辑App":@"新增App";
    
    [self createSubviews];
}

- (void)createSubviews {
    [self.view addSubview:self.appNameInput];
    [self.view addSubview:self.sureBtn];
    
    [self.appNameInput autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:100];
    [self.appNameInput autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [self.appNameInput autoSetDimensionsToSize:CGSizeMake(200, 30)];
    
    [self.sureBtn autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:100];
    [self.sureBtn autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [self.sureBtn autoSetDimensionsToSize:CGSizeMake(200, 30)];
}

#pragma mark - Privates

- (NSArray<NSError *> *)p_validateInputWithAppInfo:(ACRAppInfo *)appInfo {
    NSMutableArray *errors = [NSMutableArray array];
    if (!appInfo) {
        NSError *error = [self errorWithEmptyAppInfo];
        [errors addObject:error];
    }
    if (!appInfo.name || !appInfo.name.length) {
        NSError *error = [self errorWithEmptyAppName];
        [errors addObject:error];
    }
    return [errors copy];
}

#pragma mark - Actions

- (void)sureBtnAction:(UIButton *)sender {
    [self.view endEditing:YES];
    
    ACRAppInfo *appInfo = self.appInfo;
    if (!appInfo) {
        appInfo = [[ACRAppInfo alloc] init];
        appInfo.app_identifier = [NSUUID UUID].UUIDString;
    }
    appInfo.name = self.appNameInput.text;
    
    NSArray<NSError *> *errors = [self p_validateInputWithAppInfo:appInfo];
    if (errors.count) {
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(appInfoController:didRecvicedAppInfo:)]) {
        [self.delegate appInfoController:self didRecvicedAppInfo:appInfo];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark - Errors

static NSString * const error_domain_appinfo = @"error.domain.appinfo";
- (NSError *)errorWithEmptyAppInfo {
    NSError *error = [NSError errorWithDomain:error_domain_appinfo code:1 userInfo:nil];
    return error;
}

- (NSError *)errorWithEmptyAppName {
    NSError *error = [NSError errorWithDomain:error_domain_appinfo code:2 userInfo:nil];
    return error;
}

#pragma mark - Setters

- (void)setAppInfo:(ACRAppInfo *)appInfo {
    _appInfo = appInfo;
    
    self.appNameInput.text = appInfo.name;
}

#pragma mark - Getters

- (UITextField *)appNameInput {
    if (!_appNameInput) {
        _appNameInput = [[UITextField alloc] init];
        _appNameInput.placeholder = @"输入App名字";
        _appNameInput.borderStyle = UITextBorderStyleLine;
    }
    return _appNameInput;
}

- (UIButton *)sureBtn {
    if (!_sureBtn) {
        _sureBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [_sureBtn setTitle:@"保存" forState:UIControlStateNormal];
        [_sureBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_sureBtn setTintColor:[UIColor yellowColor]];
        [_sureBtn setBackgroundColor:[UIColor yellowColor]];
        [_sureBtn addTarget:self action:@selector(sureBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureBtn;
}

@end
