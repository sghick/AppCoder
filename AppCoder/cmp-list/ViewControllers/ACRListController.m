//
//  ACRListController.m
//  AppCoder
//
//  Created by 丁治文 on 2018/11/17.
//  Copyright © 2018年 sumrise.com. All rights reserved.
//

#import "ACRListController.h"
#import "SMRTableAssistant.h"
#import "ACRListCell.h"
#import "ACRAddBtn.h"
#import "ACRSideMenu.h"

#import "ACRAppModels.h"
#import "ACRAppDataBase.h"

#import "ACRInputController.h"

static NSString * const identifierOfListCell = @"identifierOfListCell";

typedef NS_ENUM(NSInteger, kSectionType) {
    kSectionTypeList,
};

typedef NS_ENUM(NSInteger, kRowType) {
    kRowTypeList,
};

@interface ACRListController ()<
UITableViewDataSource,
UITableViewDelegate,
UITableViewSectionsDelegate,
ACRSideMenuDelegate,
ACRInputControllerDelegate,
ACRListCellDelegate>

@property (strong, nonatomic) NSArray<ACRAppInfo *> *infoList;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) ACRAddBtn *addBtn;
@property (strong, nonatomic) ACRSideMenu *sideMenu;
@property (strong, nonatomic) NSArray<ACRTempleteMeta *> *sideMenuSource;// side menu source

@end

@implementation ACRListController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.super_appInfo) {
        self.navigationItem.title = self.super_appInfo.title;
    } else {
        self.navigationItem.title = @"项目列表";
    }
    
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
    if (self.super_appInfo) {
        // sub
        self.infoList = [ACRAppDataBase selectAppInfosWithSuperIdentifier:self.super_appInfo.identifier];
    } else {
        // root
        self.infoList = [ACRAppDataBase selectRootAppInfos];
    }
}

#pragma mark - UITableViewDataSource, UITableViewDelegate

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    SMRRow *row = [tableView rowWithIndexPath:indexPath];
    switch (row.rowKey) {
        case kRowTypeList: {
            ACRListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierOfListCell];
            cell.delegate = self;
            ACRAppInfo *info = self.infoList[row.rowSamesIndex];
            [cell setContentWithAppInfo:info];
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
        case kRowTypeList: {
            ACRAppInfo *info = self.infoList[row.rowSamesIndex];
            [self pushToNextListControllerWithAppInfo:info];
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
    
    [sections addSectionKey:kSectionTypeList rowKey:kRowTypeList rowSamesCount:self.infoList.count];
    
    return sections;
}

#pragma mark - ACRListCellDelegate

- (void)listCell:(ACRListCell *)cell didEditBtnTouched:(ACRAppInfo *)info {
    ACRTempleteMeta *meta = [ACRAppDataBase selectMetaWithIdentifier:info.meta_identifier];
    [self pushToInputEditControllerWithMeta:meta appInfo:info];
}

#pragma mark - ACRSideMenuDelegate

- (CGFloat)sideMenuView:(ACRSideMenu *)menu heightOfItem:(UIView *)item atIndex:(NSInteger)index {
    return 30;
}

- (void)sideMenuView:(ACRSideMenu *)menu didTouchedItem:(UIView *)item atIndex:(NSInteger)index {
    [menu hide];
    ACRTempleteMeta *meta = self.sideMenuSource[index];
    [self pushToInputAddControllerWithMeta:meta];
}

#pragma mark - Actions

- (void)addBtnAction:(UIButton *)sender {
    if (self.super_appInfo) {
        // others
        NSArray<ACRTempleteMeta *> *lastMeta = [ACRAppDataBase selectMetasWithSuperIdentifier:self.super_appInfo.meta_identifier];
        self.sideMenuSource = lastMeta;
    } else {
        // root
        NSArray<ACRTempleteMeta *> *rootMetas = [ACRAppDataBase selectRootMetas];
        self.sideMenuSource = rootMetas;
    }
    
    NSMutableArray *titles = [NSMutableArray array];
    for (ACRTempleteMeta *obj in self.sideMenuSource) {
        [titles addObject:obj.title];
    }
    NSArray *items = [ACRSideMenu menuItemsWithTitles:titles];
    CGPoint origin = CGPointMake(sender.frame.origin.x - 200 - 10, sender.frame.origin.y);
    [self.sideMenu loadMenuWithItems:items menuWidth:200 origin:origin];
    [self.sideMenu show];
}

#pragma mark - ACRInputControllerDelegate

- (void)inputController:(ACRInputController *)controller didSaveBtnTouchedWithInfo:(ACRAppInfo *)info {
    [self.navigationController popViewControllerAnimated:YES];
    
    // 指定super
    info.super_identifier = self.super_appInfo.identifier;
    
    // 更新数据库
    if ([self.infoList containsObject:info]) {
        [ACRAppDataBase updateAppInfoWithIdentifier:info];
    } else {
        [ACRAppDataBase insertOrReplaceAppInfos:@[info]];
    }
    
    [self queryDataFromDB];
    [self.tableView smr_reloadData];
}

- (void)inputController:(ACRInputController *)controller didDeleteBtnTouchedWithMeta:(ACRAppInfo *)info {
    NSString *content = [NSString stringWithFormat:@"是否要删除代码:%@", info.title];
    SMRAlertView *alert = [SMRAlertView alertViewWithContent:content
                                                buttonTitles:@[@"点错了", @"删除"]
                                               deepColorType:SMRAlertViewButtonDeepColorTypeCancel];
    [alert show];
    [alert setSureButtonTouchedBlock:^(id  _Nonnull maskView) {
        [maskView hide];
        [self.navigationController popViewControllerAnimated:YES];
        
        [ACRAppDataBase deleteAppInfoWithIdentifier:info.identifier];
        
        [self queryDataFromDB];
        [self.tableView smr_reloadData];
    }];
}

#pragma mark - JumpLogical

- (void)pushToInputAddControllerWithMeta:(ACRTempleteMeta *)meta {
    ACRInputController *inputVC = [[ACRInputController alloc] init];
    [inputVC setContentForAddWithMeta:meta];
    inputVC.delegate = self;
    inputVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:inputVC animated:YES];
}

- (void)pushToInputEditControllerWithMeta:(ACRTempleteMeta *)meta appInfo:(ACRAppInfo *)appInfo {
    ACRInputController *inputVC = [[ACRInputController alloc] init];
    [inputVC setContentForEditWithMeta:meta info:appInfo];
    inputVC.delegate = self;
    inputVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:inputVC animated:YES];
}

- (void)pushToNextListControllerWithAppInfo:(ACRAppInfo *)appInfo {
    ACRListController *listVC = [[ACRListController alloc] init];
    listVC.super_appInfo = appInfo;
    listVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:listVC animated:YES];
}

#pragma mark - Getters

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.sectionsDelegate = self;
        
        [_tableView registerClass:[ACRListCell class] forCellReuseIdentifier:identifierOfListCell];
    }
    return _tableView;
}

- (ACRAddBtn *)addBtn {
    if (!_addBtn) {
        _addBtn = [ACRAddBtn buttonWithType:UIButtonTypeSystem];
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
