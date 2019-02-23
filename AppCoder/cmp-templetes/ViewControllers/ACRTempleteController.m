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
#import "ACRMetaListCell.h"
#import "ACRAddBtn.h"
#import "ACRSideMenu.h"

#import "ACRAppModels.h"
#import "ACRAppDataBase.h"

#import "ACRSubmetaSelectController.h"

static NSString * const kErrorDomainForTemplete = @"com.sumrise.appcoder.templete.meta.domain.error";

static NSString * const identifierOfSupermetaCell = @"identifierOfSupermetaCell";
static NSString * const identifierOfMetaInfoCell = @"identifierOfMetaInfoCell";
static NSString * const identifierOfProtertyCell = @"identifierOfProtertyCell";
static NSString * const identifierOfSubmetaCell = @"identifierOfSubmetaCell";

typedef NS_ENUM(NSInteger, kSectionType) {
    kSectionTypeSuperMeta,
    kSectionTypeMetaInfo,
    kSectionTypeProterties,
    kSectionTypeSubMetas,
};

typedef NS_ENUM(NSInteger, kRowType) {
    kRowTypeSuperMeta,
    kRowTypeMetaInfo,
    kRowTypeProterties,
    kRowTypeSubMetas,
};

@interface ACRTempleteController ()<
UITableViewDelegate,
UITableViewDataSource,
UITableViewSectionsDelegate,
ACRSideMenuDelegate,
ACRTempleteControllerDelegate,
ACRSubmetaSelectControllerDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) ACRAddBtn *addBtn;
@property (strong, nonatomic) ACRSideMenu *sideMenu;
@property (strong, nonatomic) UIButton *saveBtn;

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
    [self.view addSubview:self.saveBtn];
    [self.view addSafeAreaViewWithColor:self.saveBtn.backgroundColor];
    
    self.addBtn.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - [ACRAddBtn generalSize].width - 10,
                                   [UIScreen mainScreen].bounds.size.height - [ACRAddBtn generalSize].height - 160,
                                   [ACRAddBtn generalSize].width,
                                   [ACRAddBtn generalSize].height);
}

- (UIBarButtonItem *)copyBtn {
    UIBarButtonItem *btn = [[UIBarButtonItem alloc] initWithTitle:@"复制" style:UIBarButtonItemStyleDone target:self action:@selector(copyBtnAction:)];
    return btn;
}

- (UIBarButtonItem *)delteBtn {
    UIBarButtonItem *btn = [[UIBarButtonItem alloc] initWithTitle:@"删除" style:UIBarButtonItemStyleDone target:self action:@selector(removeBtnAction:)];
    return btn;
}

#pragma mark - Datas

#pragma mark - Publics

- (void)setContentForAdd {
    
    if (!self.meta) {
        _meta = [[ACRTempleteMeta alloc] init];
        _meta.identifier = [NSUUID UUID].UUIDString;
    }
    
    [self.tableView smr_reloadData];
    
    self.navigationItem.title = @"新建模板";
}

- (void)setContentForEditWithMeta:(ACRTempleteMeta *)meta {
    _meta = meta;
    _inputs = [[NSArray alloc] initWithArray:meta.inputs copyItems:YES];
    _subMetaList = [ACRAppDataBase selectMetasWithSuperIdentifier:meta.identifier];
    
    for (ACRMetaInfo *info in self.metaInfoList) {
        info.value = [NSString stringWithFormat:@"%@", [_meta valueForKey:info.property_name]];
    }
    
    [self.tableView smr_reloadData];
    
    self.navigationItem.title = meta.title;
    self.navigationItem.rightBarButtonItems = @[[self delteBtn], [self copyBtn]];
}

- (void)setContentForCopyWithMeta:(ACRTempleteMeta *)meta {
    _meta = meta;
    _inputs = [[NSArray alloc] initWithArray:meta.inputs copyItems:YES];
    _subMetaList = [ACRAppDataBase selectMetasWithSuperIdentifier:meta.identifier];
    
    for (ACRMetaInfo *info in self.metaInfoList) {
        info.value = [NSString stringWithFormat:@"%@", [_meta valueForKey:info.property_name]];
    }
    
    [self.tableView smr_reloadData];
    
    self.navigationItem.title = meta.title;
}

#pragma mark - UITableViewDataSource, UITableViewDelegate

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    SMRRow *row = [tableView rowWithIndexPath:indexPath];
    switch (row.rowKey) {
        case kRowTypeSuperMeta: {
            ACRMetaListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierOfSupermetaCell];
            ACRTempleteMeta *meta = [ACRAppDataBase selectMetaWithIdentifier:self.meta.super_identifier];
            cell.textLabel.text = meta.title;
            cell.detailTextLabel.text = meta.des;
            return cell;
        }
            break;
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
            ACRMetaListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierOfSubmetaCell];
            ACRTempleteMeta *meta = self.subMetaList[row.rowSamesIndex];
            cell.textLabel.text = meta.title;
            cell.detailTextLabel.text = meta.des;
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
        case kRowTypeProterties: {
#warning TODO:在这里设置属性的其它属性
        }
            break;
        case kRowTypeSubMetas: {
            ACRTempleteMeta *meta = self.subMetaList[row.rowSamesIndex];
            [self pushToEditSubMetasControllerWithMeta:meta];
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    SMRSection *sec = [tableView sectionWithIndexPathSection:section];
    switch (sec.sectionKey) {
            case kSectionTypeSuperMeta:{
                return @"所属";
            }
                break;
            case kSectionTypeMetaInfo:{
                return @"模板信息";
            }
                break;
            case kSectionTypeProterties:{
                return @"属性输入";
            }
                break;
            case kSectionTypeSubMetas:{
                return @"子模板";
            }
                break;
        default:
            break;
    }
    return @"";
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

#pragma mark - UITableViewSectionsDelegate

- (SMRSections *)sectionsInTableView:(UITableView *)tableView {
    SMRSections *sections = [[SMRSections alloc] init];
    
    [sections addSectionKey:kSectionTypeSuperMeta rowKey:kRowTypeSuperMeta rowSamesCount:self.meta.super_identifier?1:0];
    [sections addSectionKey:kSectionTypeMetaInfo rowKey:kRowTypeMetaInfo rowSamesCount:self.metaInfoList.count];
    [sections addSectionKey:kSectionTypeProterties rowKey:kRowTypeProterties rowSamesCount:self.inputs.count];
    [sections addSectionKey:kSectionTypeSubMetas rowKey:kRowTypeSubMetas rowSamesCount:self.subMetaList.count];
    
    return sections;
}

#pragma mark - ACRTempleteControllerDelegate

// only from add logical
- (void)tempController:(ACRTempleteController *)controller didSaveBtnTouchedWithMeta:(ACRTempleteMeta *)meta {
    [self.navigationController popViewControllerAnimated:YES];
    
    // 指定super
    meta.super_identifier = self.meta.identifier;
    // 更新数据库
    if ([self.subMetaList containsObject:meta]) {
        [ACRAppDataBase updateMetaWithIdentifier:meta];
    } else {
        [ACRAppDataBase insertOrReplaceMetas:@[meta]];
    }
    
    _subMetaList = [ACRAppDataBase selectMetasWithSuperIdentifier:self.meta.identifier];
    [self.tableView smr_reloadData];
    
    // 滚动焦点到刚编辑的模板位置
    NSInteger index = [self.subMetaList indexOfObject:meta];
    NSIndexPath *indexPath = [self.tableView.sections indexPathWithSectionKey:kSectionTypeSubMetas
                                                                       rowKey:kRowTypeSubMetas
                                                                rowSamesIndex:index];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
}


#pragma mark - ACRSubmetaSelectControllerDelegate

- (void)submetaSelectController:(ACRSubmetaSelectController *)controller didSelectedMeta:(ACRTempleteMeta *)meta {
    [self.navigationController popViewControllerAnimated:YES];
    
    // 是否有主的
    if (meta.super_identifier) {
        meta = [meta copy];
        meta.identifier = [NSUUID UUID].UUIDString;
        NSLog(@"复制了一份:%@", meta);
        // 先在数据库新增一份数据
        [ACRAppDataBase insertOrReplaceMetas:@[meta]];
    }
    // 设置root为NO
    meta.is_root = NO;
    // 指定super
    meta.super_identifier = self.meta.identifier;
    // 更新数据库
    [ACRAppDataBase updateMetaWithIdentifier:meta];
    
    _subMetaList = [ACRAppDataBase selectMetasWithSuperIdentifier:self.meta.identifier];
    [self.tableView smr_reloadData];
}

- (void)tempController:(ACRTempleteController *)controller didDeleteBtnTouchedWithMeta:(ACRTempleteMeta *)meta {
    NSString *content = [NSString stringWithFormat:@"是否要删除模板:\n%@", meta.title];
    SMRAlertView *alert = [SMRAlertView alertViewWithContent:content
                                                buttonTitles:@[@"点错了", @"删除"]
                                               deepColorType:SMRAlertViewButtonDeepColorTypeCancel];
    [alert show];
    [alert setSureButtonTouchedBlock:^(id  _Nonnull maskView) {
        [maskView hide];
        [self.navigationController popViewControllerAnimated:YES];
        
        [ACRAppDataBase deleteMetaWithIdentifier:meta.identifier];
        
        self.subMetaList = [ACRAppDataBase selectMetasWithSuperIdentifier:self.meta.identifier];
        [self.tableView smr_reloadData];
    }];
}

#pragma mark - ACRSideMenuDelegate

- (CGFloat)sideMenuView:(ACRSideMenu *)menu heightOfItem:(UIView *)item atIndex:(NSInteger)index {
    return 40;
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
            
            // 滚动焦点到刚编辑的模板位置
            NSInteger index = [self.inputs indexOfObject:property];
            NSIndexPath *indexPath = [self.tableView.sections indexPathWithSectionKey:kSectionTypeProterties
                                                                               rowKey:kRowTypeProterties
                                                                        rowSamesIndex:index];
            [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
        }
            break;
        case 1: {
            // 增加子模板
            [self pushToSelectSubmetaController];
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

- (void)saveAction:(UIButton *)sender {
    [self.view endEditing:YES];
    
    if (![self tryToSaveTempletes]) {
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(tempController:didSaveBtnTouchedWithMeta:)]) {
        [self.delegate tempController:self didSaveBtnTouchedWithMeta:self.meta];
    }
}

- (void)copyBtnAction:(id)sender {
    SMRAlertView *alert = [SMRAlertView alertViewWithContent:@"是否复制到新的模板?\n温馨提示:复制前\n当前模板会自动保存并退出."
                                                buttonTitles:@[@"点错了", @"复制"]
                                               deepColorType:SMRAlertViewButtonDeepColorTypeCancel];
    [alert show];
    [alert setSureButtonTouchedBlock:^(id  _Nonnull maskView) {
        [maskView hide];
        [self saveAndCopyToNewsTempletes];
    }];
}

- (void)removeBtnAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(tempController:didDeleteBtnTouchedWithMeta:)]) {
        [self.delegate tempController:self didDeleteBtnTouchedWithMeta:self.meta];
    }
}

#pragma mark - JumpLogicals

- (void)pushToAddSubMetasController {
    ACRTempleteController *nextVC = [[ACRTempleteController alloc] init];
    [nextVC setContentForAdd];
    nextVC.delegate = self;
    [self.navigationController pushViewController:nextVC animated:YES];
}

- (void)pushToEditSubMetasControllerWithMeta:(ACRTempleteMeta *)meta {
    ACRTempleteController *nextVC = [[ACRTempleteController alloc] init];
    [nextVC setContentForEditWithMeta:meta];
    nextVC.delegate = self;
    [self.navigationController pushViewController:nextVC animated:YES];
}

- (void)pushToSelectSubmetaController {
    ACRSubmetaSelectController *nextVC = [[ACRSubmetaSelectController alloc] init];
    nextVC.delegate = self;
    [self.navigationController pushViewController:nextVC animated:YES];
}

#pragma mark - Utils

- (NSArray<ACRMetaProperty *> *)trimEmptyInputs:(NSArray<ACRMetaProperty *> *)inputs {
    NSMutableArray<ACRMetaProperty *> *arr = [inputs mutableCopy];
    for (int i = 0; i < arr.count; i++) {
        ACRMetaProperty *ipt = arr[i];
        if (!ipt.title.length) {
            [arr removeObject:ipt];
        }
    }
    return [arr copy];
}

- (NSArray<NSError *> *)validateInputsForMetaInfos:(NSArray<ACRMetaInfo *> *)metaInfos {
    NSMutableArray<NSError *> *errors = [NSMutableArray array];
    for (ACRMetaInfo *meta in metaInfos) {
        if (meta.required && (!meta.value.length)) {
            NSError *error = [NSError smr_errorWithDomain:kErrorDomainForTemplete
                                                     code:100
                                                   detail:[NSString stringWithFormat:@"%@不能为空", meta.title]
                                                  message:nil
                                                 userInfo:nil];
            [errors addObject:error];
        }
    }
    return [errors copy];
}

- (BOOL)tryToSaveTempletes {
    [self.view endEditing:YES];
    
    NSArray<NSError *> *errors = [self validateInputsForMetaInfos:self.metaInfoList];
    if (errors && errors.count) {
        SMRAlertView *alert = [SMRAlertView alertViewWithContent:errors.firstObject.smr_detail
                                                    buttonTitles:@[@"确定"]
                                                   deepColorType:SMRAlertViewButtonDeepColorTypeSure];
        [alert show];
        return NO;
    }
    
    for (ACRMetaInfo *info in self.metaInfoList) {
        [self.meta setValue:info.value?:@"" forKey:info.property_name];
    }
    
    self.meta.inputs = [self trimEmptyInputs:self.inputs];
    return YES;
}

- (void)saveAndCopyToNewsTempletes {
    if (![self tryToSaveTempletes]) {
        return;
    }
    // 创建一个直接更换一下id,同时将title置为空
    self.meta.identifier = [NSUUID UUID].UUIDString;
    self.meta.title = @"";
    [self setContentForCopyWithMeta:self.meta];
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
        
        [_tableView registerClass:[ACRMetaListCell class] forCellReuseIdentifier:identifierOfSupermetaCell];
        [_tableView registerClass:[ACRMetaInfoCell class] forCellReuseIdentifier:identifierOfMetaInfoCell];
        [_tableView registerClass:[ACRMetaPropertyCell class] forCellReuseIdentifier:identifierOfProtertyCell];
        [_tableView registerClass:[ACRMetaListCell class] forCellReuseIdentifier:identifierOfSubmetaCell];
        
        [_tableView smr_setExtraCellLineHidden];
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
#pragma mark - Default

- (NSArray<ACRMetaInfo *> *)constMetaInfo {
    // 根模版标识
    ACRMetaInfo *is_root = [[ACRMetaInfo alloc] init];
    is_root.property_name = @"is_root";
    is_root.title = @"根模版";
    is_root.type = @"BOOL";
    is_root.value = [NSString stringWithFormat:@"%@", @(self.default_is_root)];
    is_root.required = YES;
    // 模版名称
    ACRMetaInfo *title = [[ACRMetaInfo alloc] init];
    title.property_name = @"title";
    title.title = @"模版名称";
    title.type = @"NSString";
    title.required = YES;
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
