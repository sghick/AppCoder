//
//  ACRListCell.m
//  AppCoder
//
//  Created by 丁治文 on 2018/11/17.
//  Copyright © 2018年 sumrise.com. All rights reserved.
//

#import "ACRListCell.h"
#import "ACRAppModels.h"
#import "ACRAppDataBase.h"
#import "PureLayout.h"

@interface ACRListCell ()

@property (assign, nonatomic) BOOL didLoadLayout;

@property (strong, nonatomic) UIButton *editBtn;

@end

@implementation ACRListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createListSubviews];
        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void)createListSubviews {
    [self.contentView addSubview:self.editBtn];
}

- (void)updateConstraints {
    if (!self.didLoadLayout) {
        self.didLoadLayout = YES;
        
        [self.editBtn autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:20];
        [self.editBtn autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    }
    
    [super updateConstraints];
}

- (void)setContentWithAppInfo:(ACRAppInfo *)appInfo {
    _appInfo = appInfo;
    
    self.textLabel.text = appInfo.title;
    self.detailTextLabel.text = appInfo.des;
}

#pragma mark - Actions

- (void)editBtnAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(listCell:didEditBtnTouched:)]) {
        [self.delegate listCell:self didEditBtnTouched:self.appInfo];
    }
}

#pragma mark - Getters

- (UIButton *)editBtn {
    if (!_editBtn) {
        _editBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [_editBtn setTitle:@"编辑" forState:UIControlStateNormal];
        _editBtn.tintColor = [UIColor blueColor];
        _editBtn.contentEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
        [_editBtn addTarget:self action:@selector(editBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _editBtn;
}

@end
