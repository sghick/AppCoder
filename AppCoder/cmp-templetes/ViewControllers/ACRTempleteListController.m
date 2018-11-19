
//
//  ACRTempleteListController.m
//  AppCoder
//
//  Created by 丁治文 on 2018/11/17.
//  Copyright © 2018年 sumrise.com. All rights reserved.
//

#import "ACRTempleteListController.h"
#import "SMRTableAssistant.h"
#import "ACRListCell.h"
#import "ACRAddBtn.h"
#import "ACRSideMenu.h"

#import "ACRAppModels.h"
#import "ACRAppDataBase.h"

#import "ACRTempleteController.h"

static NSString * const identifierOfRootCell = @"identifierOfRootCell";
static NSString * const identifierOfListCell = @"identifierOfListCell";

typedef NS_ENUM(NSInteger, kSectionType) {
    kSectionTypeRoot,
    kSectionTypeList,
};

typedef NS_ENUM(NSInteger, kRowType) {
    kRowTypeRoot,
    kRowTypeList,
};

@interface ACRTempleteListController ()<
UITableViewDataSource,
UITableViewDelegate,
UITableViewSectionsDelegate,
ACRSideMenuDelegate,
ACRTempleteControllerDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) ACRAddBtn *addBtn;
@property (strong, nonatomic) ACRSideMenu *sideMenu;

@property (strong, nonatomic) NSArray<ACRTempleteMeta *> *metaRoot;
@property (strong, nonatomic) NSArray<ACRTempleteMeta *> *metaList;

@end

@implementation ACRTempleteListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createSubviews];
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
    if (self.super_meta) {
        // sub
        self.metaList = [ACRAppDataBase selectMetasWithSuperIdentifier:self.super_meta.identifier];
    } else {
        // root
        self.metaRoot = [ACRAppDataBase selectRootMetas];
//        self.metaList = [ACRAppDataBase selectNotRootMetas];
    }
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
            [self pushToMetaEditControllerWithMeta:meta];
        }
            break;
        case kRowTypeList: {
            ACRTempleteMeta *meta = self.metaList[row.rowSamesIndex];
            [self pushToMetaEditControllerWithMeta:meta];
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
    
    [sections addSectionKey:kSectionTypeList rowKey:kRowTypeRoot rowSamesCount:self.metaRoot.count];
    [sections addSectionKey:kSectionTypeRoot rowKey:kRowTypeList rowSamesCount:self.metaList.count];
    
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
            // 增加模版
            [self pushToMetaAddController];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - Actions

- (void)addBtnAction:(UIButton *)sender {
    NSArray *titles = @[@"增加模版"];
    NSArray *items = [ACRSideMenu menuItemsWithTitles:titles];
    CGPoint origin = CGPointMake(sender.frame.origin.x - 200 - 10, sender.frame.origin.y);
    [self.sideMenu loadMenuWithItems:items menuWidth:200 origin:origin];
    [self.sideMenu show];
}

#pragma mark - ACRTempleteControllerDelegate

- (void)tempController:(ACRTempleteController *)controller didSaveBtnTouchedWithMeta:(ACRTempleteMeta *)meta {
    [self.navigationController popViewControllerAnimated:YES];
    
    // 指定super
    meta.super_identifier = self.super_meta.identifier;
    
    NSMutableArray *arr = [NSMutableArray arrayWithArray:self.metaRoot];
    [arr addObjectsFromArray:self.metaList];
    if (![arr containsObject:meta]) {
        [arr addObject:meta];
        [ACRAppDataBase insertOrReplaceMetas:@[meta]];
    } else {
        [ACRAppDataBase updateMetaWithIdentifier:meta];
    }
    
    [self queryDataFromDB];
    [self.tableView smr_reloadData];
}

#pragma mark - JumpLogical

- (void)pushToMetaAddController {
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
        [_tableView registerClass:[ACRListCell class] forCellReuseIdentifier:identifierOfListCell];
    }
    return _tableView;
}

- (ACRAddBtn *)addBtn {
    if (!_addBtn) {
        _addBtn = [ACRAddBtn buttonWithType:UIButtonTypeSystem];
        _addBtn.backgroundColor = [UIColor orangeColor];
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
