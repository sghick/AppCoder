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

@interface ACRAppListController ()<
UITableViewDelegate,
UITableViewDataSource,
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
    [self.tableView reloadData];
}

#pragma mark - Datas

- (void)queryDataFromDB {
    self.appInfoList = [ACRAppDataBase selectAllAppInfos];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"identifierOfAddApp"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"identifierOfAddApp"];
        }
        cell.textLabel.text = @"添加APP ++++++ ";
        return cell;
    } else if (indexPath.section == 1) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"identifierOfAppInfo"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"identifierOfAppInfo"];
        }
        ACRAppInfo *appInfo = self.appInfoList[indexPath.row];
        cell.textLabel.text = appInfo.name;
        cell.detailTextLabel.text = appInfo.app_identifier;
        return cell;
    }
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"identifierOfDefault"];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger secCount = 1;
    if (self.appInfoList.count > 0) {
        secCount++;
    }
    return secCount;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        return self.appInfoList.count;
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    if (section == 0) {
        ACRAppInfoController *controller = [[ACRAppInfoController alloc] init];
        controller.delegate = self;
        [self.navigationController pushViewController:controller animated:YES];
    } else if (section == 1) {
        ACRAppEditController *controller = [[ACRAppEditController alloc] init];
        controller.appInfo = self.appInfoList[indexPath.row];
        [self.navigationController pushViewController:controller animated:YES];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        return YES;
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
    ACRAppInfo *appInfo = self.appInfoList[indexPath.row];
    
    NSMutableArray *array = [self.appInfoList mutableCopy];
    [array removeObjectAtIndex:indexPath.row];
    self.appInfoList = [array copy];
    
    if (self.appInfoList.count) {
        [tableView beginUpdates];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [tableView endUpdates];
    } else {
        [tableView reloadData];
    }
    
    [ACRAppDataBase deleteAppInfoWithIdentifier:appInfo.app_identifier];
}

- (void)p_updateAppInfoWithIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    if (section == 1) {
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
    [self.tableView reloadData];
    
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
    }
    return _tableView;
}

@end
