//
//  ACRMetaPropertyCell.m
//  AppCoder
//
//  Created by 丁治文 on 2018/11/18.
//  Copyright © 2018年 sumrise.com. All rights reserved.
//

#import "ACRMetaPropertyCell.h"
#import "ACRAppModels.h"
#import "PureLayout.h"

@interface ACRMetaPropertyCell ()<
UITextFieldDelegate>

@property (strong, nonatomic) UITextField *valueText;

@property (assign, nonatomic) BOOL didLoadLayout;

@end

@implementation ACRMetaPropertyCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createSubviews];
        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void)createSubviews {
    [self.contentView addSubview:self.valueText];
}

- (void)updateConstraints {
    if (!self.didLoadLayout) {
        self.didLoadLayout = YES;
        [self.valueText autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:20];
        [self.valueText autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        [self.valueText autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:20];
    }
    
    [super updateConstraints];
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.input.title = textField.text;
}

#pragma mark - Setters

- (void)setInput:(ACRMetaProperty *)input {
    _input = input;
    self.valueText.placeholder = @"请输入属性";
    self.valueText.text = input.title;
}

#pragma mark - Getters

- (UITextField *)valueText {
    if (!_valueText) {
        _valueText = [[UITextField alloc] init];
        _valueText.borderStyle = UITextBorderStyleRoundedRect;
        _valueText.delegate = self;
        _valueText.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
    return _valueText;
}

@end
