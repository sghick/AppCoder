//
//  ACRInputController.m
//  AppCoder
//
//  Created by 丁治文 on 2018/11/17.
//  Copyright © 2018年 sumrise.com. All rights reserved.
//

#import "ACRInputController.h"
#import "SMRTableAssistant.h"
#import "ACRInputCell.h"

#import "ACRAppModels.h"

static NSString * const identifierOfInputCell = @"identifierOfInputCell";
static NSString * const identifierOfSaveCell = @"identifierOfSaveCell";

typedef NS_ENUM(NSInteger, kSectionType) {
    kSectionTypeList,
    kSectionTypeSave,
};

typedef NS_ENUM(NSInteger, kRowType) {
    kRowTypeList,
    kRowTypeSave,
};

@interface ACRInputController ()<
UITableViewDelegate,
UITableViewDataSource,
UITableViewSectionsDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSArray<ACRMetaProperty *> *inputs;

@end

@implementation ACRInputController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createSubviews];
}

- (void)createSubviews {
    [self.view addSubview:self.tableView];
}

#pragma mark - Publics

- (void)setContentForAddWithMeta:(ACRTempleteMeta *)meta {
    _meta = meta;
    _inputs = [[NSArray alloc] initWithArray:meta.inputs copyItems:YES];
    [self.tableView smr_reloadData];
}

- (void)setContentForEditWithMeta:(ACRTempleteMeta *)meta info:(ACRAppInfo *)info {
    _meta = meta;
    _info = info;
    _inputs = [[NSArray alloc] initWithArray:info.inputs copyItems:YES];
    [self.tableView smr_reloadData];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    SMRRow *row = [tableView rowWithIndexPath:indexPath];
    switch (row.rowKey) {
        case kRowTypeList: {
            ACRInputCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierOfInputCell];
            ACRMetaProperty *input = self.inputs[row.rowSamesIndex];
            cell.input = input;
            return cell;
        }
            break;
        case kRowTypeSave: {
            UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierOfInputCell];
            cell.textLabel.text = @"保存";
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            cell.textLabel.textColor = [UIColor blackColor];
            cell.contentView.backgroundColor = [UIColor yellowColor];
            return cell;
        }
            break;
            
        default:
            break;
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SMRRow *row = [tableView rowWithIndexPath:indexPath];
    switch (row.rowKey) {
        case kRowTypeSave: {
            [self saveAction];
        }
            break;
            
        default:
            break;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return tableView.sections.sectionSamesCountOfAll;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    SMRSection *sec = [tableView sectionWithIndexPathSection:section];
    return sec.rowSamesCountOfAll;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

#pragma mark - UITableViewSectionsDelegate

- (SMRSections *)sectionsInTableView:(UITableView *)tableView {
    SMRSections *sections = [[SMRSections alloc] init];
    
    [sections addSectionKey:kSectionTypeList rowKey:kRowTypeList rowSamesCount:self.inputs.count];
    [sections addSectionKey:kSectionTypeSave rowKey:kRowTypeSave];
    
    return sections;
}

#pragma mark - Actions

- (void)saveAction {
    [self.view endEditing:YES];
    
    // 寻找title的property,使用第1个作为title
    ACRMetaProperty *titleP = self.inputs.firstObject;
    // 寻找des的property,使用第2个作为des
    ACRMetaProperty *desP = nil;
    if (self.inputs.count >= 2) {
        desP = self.inputs[1];
    }
    
    if (!_info) {
        _info = [[ACRAppInfo alloc] init];
        _info.identifier = [NSUUID UUID].UUIDString;
        _info.title = titleP.value;
        _info.des = desP.value;
    }
    _info.is_root = self.meta.is_root;
    _info.meta_identifier = self.meta.identifier;
    _info.inputs = self.inputs;
    if ([self.delegate respondsToSelector:@selector(inputController:didSaveBtnTouchedWithInfo:)]) {
        [self.delegate inputController:self didSaveBtnTouchedWithInfo:self.info];
    }
}

#pragma mark - Getters

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.sectionsDelegate = self;
        
        [_tableView registerClass:[ACRInputCell class] forCellReuseIdentifier:identifierOfInputCell];
    }
    return _tableView;
}

@end
