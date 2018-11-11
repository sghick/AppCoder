//
//  ACRPageInfoController.m
//  AppCoder
//
//  Created by 丁治文 on 2018/11/11.
//  Copyright © 2018年 sumrise.com. All rights reserved.
//

#import "ACRPageInfoController.h"
#import "PureLayout.h"
#import "ACRAppModels.h"

@interface ACRPageInfoController ()

@property (strong, nonatomic) UITextField *appNameInput;
@property (strong, nonatomic) UIButton *sureBtn;

@end

@implementation ACRPageInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    self.navigationItem.title = self.page?@"编辑Page":@"新增Page";
    
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

- (NSArray<NSError *> *)p_validateInputWithAppPage:(ACRAppPage *)appPage {
    NSMutableArray *errors = [NSMutableArray array];
    if (!appPage) {
        NSError *error = [self errorWithEmptyPage];
        [errors addObject:error];
    }
    if (!appPage.name || !appPage.name.length) {
        NSError *error = [self errorWithEmptyPage];
        [errors addObject:error];
    }
    return [errors copy];
}

#pragma mark - Actions

- (void)sureBtnAction:(UIButton *)sender {
    [self.view endEditing:YES];
    
    ACRAppPage *page = self.page;
    if (!page) {
        page = [[ACRAppPage alloc] init];
        page.page_identifier = [NSUUID UUID].UUIDString;
    }
    page.name = self.appNameInput.text;
    
    NSArray<NSError *> *errors = [self p_validateInputWithAppPage:page];
    if (errors.count) {
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(appPageInfoController:didRecvicedAppPage:)]) {
        [self.delegate appPageInfoController:self didRecvicedAppPage:page];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark - Errors

static NSString * const error_domain_apppage = @"error.domain.apppage";
- (NSError *)errorWithEmptyPage {
    NSError *error = [NSError errorWithDomain:error_domain_apppage code:1 userInfo:nil];
    return error;
}

- (NSError *)errorWithEmptName {
    NSError *error = [NSError errorWithDomain:error_domain_apppage code:2 userInfo:nil];
    return error;
}

#pragma mark - Setters

- (void)setPage:(ACRAppPage *)page {
    _page = page;
    
    self.appNameInput.text = page.name;
}

#pragma mark - Getters

- (UITextField *)appNameInput {
    if (!_appNameInput) {
        _appNameInput = [[UITextField alloc] init];
        _appNameInput.placeholder = @"输入Page名字";
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
