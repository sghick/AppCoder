//
//  ACRSubmetaSelectController.m
//  AppCoder
//
//  Created by 丁治文 on 2018/11/19.
//  Copyright © 2018 sumrise.com. All rights reserved.
//

#import "ACRSubmetaSelectController.h"
#import "SMRTableAssistant.h"
#import "ACRListCell.h"
#import "ACRAddBtn.h"
#import "ACRSideMenu.h"

#import "ACRAppModels.h"
#import "ACRAppDataBase.h"

#import "ACRTempleteController.h"

static NSString * const identifierOfRootCell = @"identifierOfRootCell";
static NSString * const identifierOfWildCell = @"identifierOfWildCell";
static NSString * const identifierOfListCell = @"identifierOfListCell";

typedef NS_ENUM(NSInteger, kSectionType) {
    kSectionTypeRoot,
    kSectionTypeWild,
    kSectionTypeList,
};

typedef NS_ENUM(NSInteger, kRowType) {
    kRowTypeRoot,
    kRowTypeWild,
    kRowTypeList,
};

@interface ACRSubmetaSelectController ()<
UITableViewDataSource,
UITableViewDelegate,
UITableViewSectionsDelegate,
ACRSideMenuDelegate,
ACRTempleteControllerDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) ACRAddBtn *addBtn;
@property (strong, nonatomic) ACRSideMenu *sideMenu;

@property (strong, nonatomic) NSArray<ACRTempleteMeta *> *metaRoot;
@property (strong, nonatomic) NSArray<ACRTempleteMeta *> *metaWild;
@property (strong, nonatomic) NSArray<ACRTempleteMeta *> *metaList;

@end

@implementation ACRSubmetaSelectController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"选择模板";
    
    [self createSubviews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self queryDataFromDB];
    [self.tableView smr_reloadData];
}

- (void)createSubviews {
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.addBtn];
    
    self.addBtn.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - [ACRAddBtn generalSize].width - 10,
                                   [UIScreen mainScreen].bounds.size.height - [ACRAddBtn generalSize].height - 160,
                                   [ACRAddBtn generalSize].width,
                                   [ACRAddBtn generalSize].height);
}

- (void)queryDataFromDB {
    self.metaRoot = [ACRAppDataBase selectRootMetas];
    self.metaWild = [ACRAppDataBase selectNotRootWildMetas];
    self.metaList = [ACRAppDataBase selectNotRootNormalMetas];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    SMRRow *row = [tableView rowWithIndexPath:indexPath];
    switch (row.rowKey) {
            case kRowTypeRoot: {
                ACRListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierOfRootCell];
                ACRTempleteMeta *meta = self.metaRoot[row.rowSamesIndex];
                cell.textLabel.text = meta.title;
                cell.detailTextLabel.text = meta.des;
                return cell;
            }
            break;
        case kRowTypeWild: {
            ACRListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierOfWildCell];
            ACRTempleteMeta *meta = self.metaWild[row.rowSamesIndex];
            cell.textLabel.text = meta.title;
            cell.detailTextLabel.text = meta.des;
            return cell;
        }
            break;
        case kRowTypeList: {
            ACRListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierOfListCell];
            ACRTempleteMeta *meta = self.metaList[row.rowSamesIndex];
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
        case kRowTypeRoot: {
            ACRTempleteMeta *meta = self.metaRoot[row.rowSamesIndex];
            [self didSelctedMeta:meta];
        }
            break;
        case kRowTypeWild: {
            ACRTempleteMeta *meta = self.metaWild[row.rowSamesIndex];
            [self didSelctedMeta:meta];
        }
            break;
        case kRowTypeList: {
            ACRTempleteMeta *meta = self.metaList[row.rowSamesIndex];
            [self didSelctedMeta:meta];
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

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    SMRSection *sec = [tableView sectionWithIndexPathSection:section];
    switch (sec.sectionKey) {
        case kSectionTypeRoot:{
            return @"根模板";
        }
            break;
        case kSectionTypeWild:{
            return @"未用模板";
        }
            break;
        case kSectionTypeList:{
            return @"普通模板";
        }
            break;
        default:
            break;
    }
    return @"";
}

#pragma mark - UITableViewSectionsDelegate

- (SMRSections *)sectionsInTableView:(UITableView *)tableView {
    SMRSections *sections = [[SMRSections alloc] init];
    
    [sections addSectionKey:kSectionTypeRoot rowKey:kRowTypeRoot rowSamesCount:self.metaRoot.count];
    [sections addSectionKey:kSectionTypeWild rowKey:kRowTypeWild rowSamesCount:self.metaWild.count];
    [sections addSectionKey:kSectionTypeList rowKey:kRowTypeList rowSamesCount:self.metaList.count];
    
    return sections;
}

#pragma mark - ACRSideMenuDelegate

- (CGFloat)sideMenuView:(ACRSideMenu *)menu heightOfItem:(UIView *)item atIndex:(NSInteger)index {
    return 30;
}

- (void)sideMenuView:(ACRSideMenu *)menu didTouchedItem:(UIView *)item atIndex:(NSInteger)index {
    [menu hide];
    switch (index) {
            case 0: {
                // 增加根模版
                [self pushToRootMetaAddController];
            }
            break;
            case 1: {
                // 增加普通模板
                [self pushToSubMetaAddController];
            }
            break;
            
        default:
            break;
    }
}

#pragma mark - Actions

- (void)addBtnAction:(UIButton *)sender {
    NSArray *titles = @[@"增加根模版", @"增加普通模板"];
    NSArray *items = [ACRSideMenu menuItemsWithTitles:titles];
    CGPoint origin = CGPointMake(sender.frame.origin.x - 200 - 10, sender.frame.origin.y);
    [self.sideMenu loadMenuWithItems:items menuWidth:200 origin:origin];
    [self.sideMenu show];
}

- (void)didSelctedMeta:(ACRTempleteMeta *)meta {
    if ([self.delegate respondsToSelector:@selector(submetaSelectController:didSelectedMeta:)]) {
        [self.delegate submetaSelectController:self didSelectedMeta:meta];
    }
}

#pragma mark - ACRTempleteControllerDelegate

- (void)tempController:(ACRTempleteController *)controller didSaveBtnTouchedWithMeta:(ACRTempleteMeta *)meta {
    [self.navigationController popViewControllerAnimated:YES];
    
    // 指定super
//    meta.super_identifier = self.super_meta.identifier;
    
    // 更新数据库
    if ([self.metaRoot containsObject:meta] || [self.metaList containsObject:meta]) {
        [ACRAppDataBase updateMetaWithIdentifier:meta];
    } else {
        [ACRAppDataBase insertOrReplaceMetas:@[meta]];
    }
    
    [self queryDataFromDB];
    [self.tableView smr_reloadData];
}

#pragma mark - JumpLogical

- (void)pushToRootMetaAddController {
    ACRTempleteController *metaVC = [[ACRTempleteController alloc] init];
    metaVC.default_is_root = YES;
    [metaVC setContentForAdd];
    metaVC.delegate = self;
    metaVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:metaVC animated:YES];
}

- (void)pushToSubMetaAddController {
    ACRTempleteController *metaVC = [[ACRTempleteController alloc] init];
    [metaVC setContentForAdd];
    metaVC.delegate = self;
    metaVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:metaVC animated:YES];
}

- (void)pushToMetaEditControllerWithMeta:(ACRTempleteMeta *)meta {
    ACRTempleteController *metaVC = [[ACRTempleteController alloc] init];
    [metaVC setContentForEditWithMeta:meta];
    metaVC.delegate = self;
    metaVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:metaVC animated:YES];
}

#pragma mark - Getters

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.sectionsDelegate = self;
        
        [_tableView registerClass:[ACRListCell class] forCellReuseIdentifier:identifierOfRootCell];
        [_tableView registerClass:[ACRListCell class] forCellReuseIdentifier:identifierOfWildCell];
        [_tableView registerClass:[ACRListCell class] forCellReuseIdentifier:identifierOfListCell];
    }
    return _tableView;
}

- (ACRAddBtn *)addBtn {
    if (!_addBtn) {
        _addBtn = [ACRAddBtn buttonWithType:UIButtonTypeSystem];
        _addBtn.backgroundColor = [UIColor greenColor];
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

@end
