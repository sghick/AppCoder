//
//  ACRInputCell.m
//  AppCoder
//
//  Created by 丁治文 on 2018/11/17.
//  Copyright © 2018年 sumrise.com. All rights reserved.
//

#import "ACRInputCell.h"
#import "ACRAppModels.h"
#import "PureLayout.h"

@interface ACRInputCell ()<
UITextFieldDelegate>

@property (strong, nonatomic) UITextField *valueText;

@property (assign, nonatomic) BOOL didLoadLayout;

@end

@implementation ACRInputCell

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
        [self.valueText autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:160];
        [self.valueText autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        [self.valueText autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:20];
    }
    
    [super updateConstraints];
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.input.value = textField.text;
}

#pragma mark - Setters

- (void)setInput:(ACRMetaProperty *)input {
    _input = input;
    self.textLabel.text = input.title;
    self.valueText.text = input.value;
}

#pragma mark - Getters

- (UITextField *)valueText {
    if (!_valueText) {
        _valueText = [[UITextField alloc] init];
        _valueText.borderStyle = UITextBorderStyleRoundedRect;
        _valueText.delegate = self;
    }
    return _valueText;
}

@end
