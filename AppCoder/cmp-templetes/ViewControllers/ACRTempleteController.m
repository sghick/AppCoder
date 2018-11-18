//
//  ACRTempleteController.m
//  AppCoder
//
//  Created by 丁治文 on 2018/11/17.
//  Copyright © 2018年 sumrise.com. All rights reserved.
//

#import "ACRTempleteController.h"
#import "SMRTableAssistant.h"
#import "ACRMetaInfoCell.h"
#import "ACRMetaPropertyCell.h"
#import "ACRListCell.h"
#import "ACRAddBtn.h"
#import "ACRSideMenu.h"

#import "ACRAppModels.h"
#import "ACRAppDataBase.h"

static NSString * const identifierOfMetaInfoCell = @"identifierOfMetaInfoCell";
static NSString * const identifierOfProtertyCell = @"identifierOfProtertyCell";
static NSString * const identifierOfSubmetaCell = @"identifierOfSubmetaCell";
static NSString * const identifierOfSaveCell = @"identifierOfSaveCell";

typedef NS_ENUM(NSInteger, kSectionType) {
    kSectionTypeMetaInfo,
    kSectionTypeProterties,
    kSectionTypeSubMetas,
    kSectionTypeSave,
};

typedef NS_ENUM(NSInteger, kRowType) {
    kRowTypeMetaInfo,
    kRowTypeProterties,
    kRowTypeSubMetas,
    kRowTypeSave,
};

@interface ACRTempleteController ()<
UITableViewDelegate,
UITableViewDataSource,
UITableViewSectionsDelegate,
ACRSideMenuDelegate,
ACRTempleteControllerDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) ACRAddBtn *addBtn;
@property (strong, nonatomic) ACRSideMenu *sideMenu;

@property (strong, nonatomic) NSArray<ACRMetaInfo *> *metaInfoList;
@property (strong, nonatomic) NSArray<ACRMetaProperty *> *inputs;
@property (strong, nonatomic) NSArray<ACRTempleteMeta *> *subMetaList;

@end

@implementation ACRTempleteController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createSubviews];
}

- (void)createSubviews {
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.addBtn];
    
    self.addBtn.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - [ACRAddBtn generalSize].width - 10,
                                   [UIScreen mainScreen].bounds.size.height - [ACRAddBtn generalSize].height - 160,
                                   [ACRAddBtn generalSize].width,
                                   [ACRAddBtn generalSize].height);
}

#pragma mark - Publics

- (void)setContentForAdd {
    
    [self.tableView smr_reloadData];
}

- (void)setContentForEditWithMeta:(ACRTempleteMeta *)meta {
    _meta = meta;
    _inputs = [[NSArray alloc] initWithArray:meta.inputs copyItems:YES];
    _subMetaList = [ACRAppDataBase selectMetasWithSuperIdentifier:meta.identifier];
    
    for (ACRMetaInfo *info in self.metaInfoList) {
        info.value = [_meta valueForKey:info.property_name];
    }
    
    [self.tableView smr_reloadData];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    SMRRow *row = [tableView rowWithIndexPath:indexPath];
    switch (row.rowKey) {
        case kRowTypeMetaInfo: {
            ACRMetaInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierOfMetaInfoCell];
            ACRMetaInfo *info = self.metaInfoList[row.rowSamesIndex];
            cell.info = info;
            return cell;
        }
            break;
        case kRowTypeProterties: {
            ACRMetaPropertyCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierOfProtertyCell];
            ACRMetaProperty *input = self.inputs[row.rowSamesIndex];
            cell.input = input;
            return cell;
        }
            break;
        case kRowTypeSubMetas: {
            ACRListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierOfSubmetaCell];
            ACRTempleteMeta *meta = self.subMetaList[row.rowSamesIndex];
            cell.textLabel.text = meta.title;
            cell.detailTextLabel.text = meta.des;
            return cell;
        }
            break;
        case kRowTypeSave: {
            UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierOfSaveCell];
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
    
    [sections addSectionKey:kSectionTypeMetaInfo rowKey:kRowTypeMetaInfo rowSamesCount:self.metaInfoList.count];
    [sections addSectionKey:kSectionTypeProterties rowKey:kRowTypeProterties rowSamesCount:self.inputs.count];
    [sections addSectionKey:kSectionTypeSubMetas rowKey:kRowTypeSubMetas rowSamesCount:self.subMetaList.count];
    [sections addSectionKey:kSectionTypeSave rowKey:kRowTypeSave];
    
    return sections;
}

#pragma mark - ACRTempleteControllerDelegate

// only from add logical
- (void)tempController:(ACRTempleteController *)controller didSaveBtnTouchedWithMeta:(ACRTempleteMeta *)meta {
    [self.navigationController popViewControllerAnimated:YES];
    
    // 指定super
    meta.super_identifier = self.meta.identifier;
    
    NSMutableArray *arr = [NSMutableArray arrayWithArray:self.subMetaList];
    if (![arr containsObject:meta]) {
        [arr addObject:meta];
    }
    self.subMetaList = [arr copy];
    // sub
    [ACRAppDataBase deleteMetaWithIdentifier:meta.identifier];
    [ACRAppDataBase insertOrReplaceMetas:@[meta]];
    
    [self.tableView smr_reloadData];
}

#pragma mark - ACRSideMenuDelegate

- (CGFloat)sideMenuView:(ACRSideMenu *)menu heightOfItem:(UIView *)item atIndex:(NSInteger)index {
    return 30;
}

- (void)sideMenuView:(ACRSideMenu *)menu didTouchedItem:(UIView *)item atIndex:(NSInteger)index {
    [menu hide];
    switch (index) {
        case 0: {
            // 增加输入项
            ACRMetaProperty *property = [[ACRMetaProperty alloc] init];
            NSArray *nInpts = [NSArray arrayWithArray:self.inputs];
            self.inputs = [nInpts arrayByAddingObject:property];
            [self.tableView smr_reloadData];
        }
            break;
        case 1: {
            // 增加子模板
            
        }
            break;
        case 2: {
            // 新建并增加子模板
            [self pushToAddSubMetasController];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - Actions

- (void)addBtnAction:(UIButton *)sender {
    NSArray *titles = @[@"增加输入项", @"增加子模板", @"新建并增加子模板"];
    NSArray *items = [ACRSideMenu menuItemsWithTitles:titles];
    CGPoint origin = CGPointMake(sender.frame.origin.x - 200 - 10, sender.frame.origin.y);
    [self.sideMenu loadMenuWithItems:items menuWidth:200 origin:origin];
    [self.sideMenu show];
}

- (void)saveAction {
    [self.view endEditing:YES];
    
    if (!self.meta) {
        _meta = [[ACRTempleteMeta alloc] init];
        _meta.identifier = [NSUUID UUID].UUIDString;
    }
    
    for (ACRMetaInfo *info in self.metaInfoList) {
        [self.meta setValue:info.value?:@"" forKey:info.property_name];
    }
    
    self.meta.inputs = self.inputs;
    if ([self.delegate respondsToSelector:@selector(tempController:didSaveBtnTouchedWithMeta:)]) {
        [self.delegate tempController:self didSaveBtnTouchedWithMeta:self.meta];
    }
}

#pragma mark - JumpLogicals

- (void)pushToAddSubMetasController {
    ACRTempleteController *nextVC = [[ACRTempleteController alloc] init];
    [nextVC setContentForAdd];
    nextVC.delegate = self;
    [self.navigationController pushViewController:nextVC animated:YES];
}

#pragma mark - Getters

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.sectionsDelegate = self;
        
        [_tableView registerClass:[ACRMetaInfoCell class] forCellReuseIdentifier:identifierOfMetaInfoCell];
        [_tableView registerClass:[ACRMetaPropertyCell class] forCellReuseIdentifier:identifierOfProtertyCell];
        [_tableView registerClass:[ACRListCell class] forCellReuseIdentifier:identifierOfSubmetaCell];
    }
    return _tableView;
}

- (NSArray<ACRMetaInfo *> *)metaInfoList {
    if (!_metaInfoList) {
        _metaInfoList = [self constMetaInfo];
    }
    return _metaInfoList;
}


- (ACRAddBtn *)addBtn {
    if (!_addBtn) {
        _addBtn = [ACRAddBtn buttonWithType:UIButtonTypeSystem];
        _addBtn.backgroundColor = [UIColor cyanColor];
        [_addBtn addTarget:self action:@selector(addBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addBtn;
}

- (ACRSideMenu *)sideMenu {
    if (!_sideMenu) {
        _sideMenu = [[ACRSideMenu alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _sideMenu.delegate = self;
        _sideMenu.maxHeightOfContent = 200;
    }
    return _sideMenu;
}

#pragma mark - Default

- (NSArray<ACRMetaInfo *> *)constMetaInfo {
    // 根模版标识
    ACRMetaInfo *is_root = [[ACRMetaInfo alloc] init];
    is_root.property_name = @"is_root";
    is_root.title = @"根模版";
    is_root.type = @"BOOL";
    // 模版名称
    ACRMetaInfo *title = [[ACRMetaInfo alloc] init];
    title.property_name = @"title";
    title.title = @"模版名称";
    title.type = @"NSString";
    // 描述
    ACRMetaInfo *des = [[ACRMetaInfo alloc] init];
    des.property_name = @"des";
    des.title = @"描述";
    des.type = @"NSString";
    // 注释
    ACRMetaInfo *rem = [[ACRMetaInfo alloc] init];
    rem.property_name = @"rem";
    rem.title = @"注释";
    rem.type = @"NSString";
    // 代码
    ACRMetaInfo *code = [[ACRMetaInfo alloc] init];
    code.property_name = @"code";
    code.title = @"代码";
    code.type = @"NSString";
    
    NSArray<ACRMetaInfo *> *arr = @[is_root, title, des, rem, code];
    return arr;
}


#pragma mark - Needs test

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)addAnDefaultAppTemplete {
    ACRMetaProperty *ppt1 = [[ACRMetaProperty alloc] init];
    ppt1.title = @"APP名称";
    
    ACRTempleteMeta *appMeta = [[ACRTempleteMeta alloc] init];
    appMeta.identifier = [NSUUID UUID].UUIDString;
    appMeta.title = @"空白App";
    appMeta.is_root = YES;
    appMeta.inputs = @[ppt1];
    
    ACRMetaProperty *clsppt = [[ACRMetaProperty alloc] init];
    clsppt.title = @"类名";
    clsppt.des = @"AppDelegate";
    
    ACRTempleteMeta *structMeta = [[ACRTempleteMeta alloc] init];
    structMeta.identifier = [NSUUID UUID].UUIDString;
    structMeta.super_identifier = appMeta.identifier;
    structMeta.title = @"AppDelegate";
    structMeta.inputs = @[clsppt];
    
    [ACRAppDataBase deleteAllMetas];
    [ACRAppDataBase insertOrReplaceMetas:@[appMeta, structMeta]];
    
    NSLog(@"更新模版成功");
}

@end
