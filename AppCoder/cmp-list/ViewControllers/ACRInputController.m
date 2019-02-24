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

typedef NS_ENUM(NSInteger, kSectionType) {
    kSectionTypeList,
};

typedef NS_ENUM(NSInteger, kRowType) {
    kRowTypeList,
};

@interface ACRInputController ()<
UITableViewDelegate,
UITableViewDataSource,
UITableViewSectionsDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSArray<ACRMetaProperty *> *inputs;
@property (strong, nonatomic) UIButton *saveBtn;

@end

@implementation ACRInputController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createSubviews];
}

- (void)createSubviews {
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.saveBtn];
    [self.view addSafeAreaViewWithColor:self.saveBtn.backgroundColor];
}

- (UIBarButtonItem *)copyBtn {
    UIBarButtonItem *btn = [[UIBarButtonItem alloc] initWithTitle:@"复制" style:UIBarButtonItemStyleDone target:self action:@selector(copyBtnAction:)];
    return btn;
}

- (UIBarButtonItem *)deleteBtn {
    UIBarButtonItem *btn = [[UIBarButtonItem alloc] initWithTitle:@"删除" style:UIBarButtonItemStyleDone target:self action:@selector(removeBtnAction:)];
    return btn;
}

#pragma mark - Publics

- (void)setContentForAddWithMeta:(ACRTempleteMeta *)meta {
    _meta = meta;
    _inputs = [[NSArray alloc] initWithArray:meta.inputs copyItems:YES];
    [self.tableView smr_reloadData];
    
    self.navigationItem.title = [NSString stringWithFormat:@"新建:%@", meta.title];
}

- (void)setContentForEditWithMeta:(ACRTempleteMeta *)meta info:(ACRAppInfo *)info {
    _meta = meta;
    _info = info;
    _inputs = [[NSArray alloc] initWithArray:meta.inputs copyItems:YES];
    NSMutableDictionary<NSString *, ACRMetaProperty *> *infoInputDict = [NSMutableDictionary dictionary];
    for (ACRMetaProperty *per in info.inputs) {
        [infoInputDict setObject:per forKey:per.title?:@""];
    }
    for (ACRMetaProperty *per in _inputs) {
        per.value = infoInputDict[per.title].value;
    }
    [self.tableView smr_reloadData];
    
    self.navigationItem.title = info.infoTitle;
    self.navigationItem.rightBarButtonItems = @[[self copyBtn], [self deleteBtn]];
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
            
        default:
            break;
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
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
    
    return sections;
}

#pragma mark - Actions

- (void)saveAction:(UIButton *)sender {
    [self.view endEditing:YES];
    
    if (!_info) {
        _info = [[ACRAppInfo alloc] init];
        _info.identifier = [NSUUID UUID].UUIDString;
    }
    _info.is_root = self.meta.is_root;
    _info.meta_identifier = self.meta.identifier;
    _info.inputs = self.inputs;
    if ([self.delegate respondsToSelector:@selector(inputController:didSaveBtnTouchedWithInfo:)]) {
        [self.delegate inputController:self didSaveBtnTouchedWithInfo:self.info];
    }
}

- (void)copyBtnAction:(id)sender {
    
}

- (void)removeBtnAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(inputController:didDeleteBtnTouchedWithMeta:)]) {
        [self.delegate inputController:self didDeleteBtnTouchedWithMeta:self.info];
    }
}

#pragma mark - Getters

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,
                                                                   0,
                                                                   SCREEN_WIDTH,
                                                                   SCREEN_HEIGHT - 50.0)
                                                  style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.sectionsDelegate = self;
        
        [_tableView registerClass:[ACRInputCell class] forCellReuseIdentifier:identifierOfInputCell];
        
        [_tableView smr_setExtraCellLineHidden];
    }
    return _tableView;
}

- (UIButton *)saveBtn {
    if (!_saveBtn) {
        _saveBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [_saveBtn setTitle:@"保存" forState:UIControlStateNormal];
        [_saveBtn addTarget:self action:@selector(saveAction:) forControlEvents:UIControlEventTouchUpInside];
        _saveBtn.backgroundColor = [UIColor yellowColor];
        _saveBtn.frame = CGRectMake(0, self.tableView.bottom, SCREEN_WIDTH, 50.0);
    }
    return _saveBtn;
}

@end
