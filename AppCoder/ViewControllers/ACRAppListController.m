//
//  ACRAppListController.m
//  AppCoder
//
//  Created by 丁治文 on 2018/10/31.
//  Copyright © 2018年 sumrise.com. All rights reserved.
//

#import "ACRAppListController.h"
#import "ACRAppModels.h"
#import "ACRAppInfoController.h"
#import "ACRAppEditController.h"
#import "ACRAppDataBase.h"
#import "SMRTableAssistant.h"


typedef NS_ENUM(NSInteger, kSectionType) {
    kSectionTypeAdd,
    kSectionTypeApp,
};

typedef NS_ENUM(NSInteger, kRowType) {
    kRowTypeAdd,
    kRowTypeApp,
};

@interface ACRAppListController ()<
UITableViewDelegate,
UITableViewDataSource,
UITableViewSectionsDelegate,
ACRAppInfoControllerDelegate
>

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSArray<ACRAppInfo *> *appInfoList;

@end

@implementation ACRAppListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"MCode";
    
    [self.view addSubview:self.tableView];
    
    [self queryDataFromDB];
    [self.tableView smr_reloadData];
}

#pragma mark - Datas

- (void)queryDataFromDB {
    self.appInfoList = [ACRAppDataBase selectAllAppInfos];
}

#pragma mark - UITableViewSectionsDelegate

- (SMRSections *)sectionsInTableView:(UITableView *)tableView {
    SMRSections *sections = [[SMRSections alloc] init];
    [sections addSectionKey:kSectionTypeAdd rowKey:kRowTypeAdd];
    [sections addSectionKey:kSectionTypeApp rowKey:kRowTypeApp rowSamesCount:self.appInfoList.count];
    return sections;
}

#pragma mark - UITableViewDataSource, UITableViewDelegate

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    SMRRow *row = [tableView rowWithIndexPath:indexPath];
    switch (row.sectionKey) {
        case kSectionTypeAdd: {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"identifierOfAddApp"];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"identifierOfAddApp"];
            }
            cell.textLabel.text = @"添加APP ++++++ ";
            return cell;
        }
            break;
        case kSectionTypeApp: {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"identifierOfAppInfo"];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"identifierOfAppInfo"];
            }
            ACRAppInfo *appInfo = self.appInfoList[indexPath.row];
            cell.textLabel.text = appInfo.name;
            cell.detailTextLabel.text = appInfo.app_identifier;
            return cell;
        }
            break;
            
        default:
            break;
    }
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"identifierOfDefault"];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return tableView.sections.sectionSamesCountOfAll;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    SMRSection *sec = [tableView sectionWithIndexPathSection:section];
    return sec.rowSamesCountOfAll;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SMRRow *row = [tableView rowWithIndexPath:indexPath];
    switch (row.sectionKey) {
        case kSectionTypeAdd: {
            ACRAppInfoController *controller = [[ACRAppInfoController alloc] init];
            controller.delegate = self;
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        case kSectionTypeApp: {
            ACRAppEditController *controller = [[ACRAppEditController alloc] init];
            controller.appInfo = self.appInfoList[indexPath.row];
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
            
        default:
            break;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    SMRRow *row = [tableView rowWithIndexPath:indexPath];
    switch (row.sectionKey) {
        case kSectionTypeAdd: {
            return NO;
        }
            break;
        case kSectionTypeApp: {
            return YES;
        }
            break;
        default:
            break;
    }
    return NO;
}

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    __weak typeof(self) weakSelf = self;
    // 删除
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:(UITableViewRowActionStyleDestructive) title:@"删除" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        [weakSelf p_askNeedsDeleteAppInfoInTableView:tableView indexPath:indexPath];
    }];
    deleteAction.backgroundColor = [UIColor cyanColor];
    
    // 编辑
    UITableViewRowAction *editAction =[UITableViewRowAction rowActionWithStyle:(UITableViewRowActionStyleDestructive) title:@"编辑" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        [weakSelf p_updateAppInfoWithIndexPath:indexPath];
    }];
    editAction.backgroundColor = [UIColor magentaColor];
    
    return @[deleteAction, editAction];
}

#pragma mark - Privates

// 询问是否确定要删除app信息
- (void)p_askNeedsDeleteAppInfoInTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
    SMRRow *row = [tableView rowWithIndexPath:indexPath];
    
    if (row.rowKey == kRowTypeApp) {
        ACRAppInfo *appInfo = self.appInfoList[indexPath.row];
        NSMutableArray *array = [self.appInfoList mutableCopy];
        [array removeObjectAtIndex:indexPath.row];
        self.appInfoList = [array copy];
        
        if (self.appInfoList.count) {
            [tableView beginUpdates];
            [tableView smr_deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            [tableView endUpdates];
        } else {
            [tableView smr_reloadData];
        }
        [ACRAppDataBase deleteAppInfoWithIdentifier:appInfo.app_identifier];
    }
}

- (void)p_updateAppInfoWithIndexPath:(NSIndexPath *)indexPath {
    SMRRow *row = [self.tableView rowWithIndexPath:indexPath];
    if (row.rowKey == kRowTypeApp) {
        ACRAppInfo *appInfo = self.appInfoList[indexPath.row];
        ACRAppInfoController *controller = [[ACRAppInfoController alloc] init];
        controller.appInfo = appInfo;
        controller.delegate = self;
        [self.navigationController pushViewController:controller animated:YES];
    }
}

#pragma mark - ACRAppInfoControllerDelegate

- (void)appInfoController:(ACRAppInfoController *)controller didRecvicedAppInfo:(ACRAppInfo *)appInfo {
    if (![self.appInfoList containsObject:appInfo]) {
        self.appInfoList = [@[appInfo] arrayByAddingObjectsFromArray:self.appInfoList];
    }
    [self.tableView smr_reloadData];
    
    [ACRAppDataBase deleteAllAppInfos];
    [ACRAppDataBase insertOrReplaceAppInfos:self.appInfoList];
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Getters

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.sectionsDelegate = self;
    }
    return _tableView;
}

@end
