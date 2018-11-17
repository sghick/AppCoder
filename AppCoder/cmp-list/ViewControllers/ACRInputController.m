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
@property (strong, nonatomic) NSArray<ACRMetaProperty *> *inputList;

@end

@implementation ACRInputController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createSubviews];
    
    [self.tableView smr_reloadData];
}

- (void)createSubviews {
    [self.view addSubview:self.tableView];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    SMRRow *row = [tableView rowWithIndexPath:indexPath];
    switch (row.rowKey) {
        case kRowTypeList: {
            ACRInputCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierOfInputCell];
            ACRMetaProperty *input = self.inputList[row.rowSamesIndex];
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

#pragma mark - UITableViewSectionsDelegate

- (SMRSections *)sectionsInTableView:(UITableView *)tableView {
    SMRSections *sections = [[SMRSections alloc] init];
    
    [sections addSectionKey:kSectionTypeList rowKey:kRowTypeList rowSamesCount:self.inputList.count];
    [sections addSectionKey:kSectionTypeSave rowKey:kRowTypeSave];
    
    return sections;
}

#pragma mark - Actions

- (void)saveAction {
    
    id info = nil;
    if ([self.delegate respondsToSelector:@selector(inputController:didSaveBtnTouchedWithInfo:)]) {
        [self.delegate inputController:self didSaveBtnTouchedWithInfo:info];
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
