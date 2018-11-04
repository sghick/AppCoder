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
#import "ACRAppDataBase.h"

@interface ACRAppListController ()<
UITableViewDelegate,
UITableViewDataSource,
ACRAppInfoControllerDelegate
>

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSArray<ACRAppInfo *> *appInfo;

@end

@implementation ACRAppListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"我的App";
    
    [self.view addSubview:self.tableView];
    
    [self queryDataFromDB];
    [self.tableView reloadData];
}

#pragma mark - Datas

- (void)queryDataFromDB {
    self.appInfo = [ACRAppDataBase selectAllAppInfos];
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
        ACRAppInfo *appInfo = self.appInfo[indexPath.row];
        cell.textLabel.text = appInfo.name;
        cell.detailTextLabel.text = appInfo.app_identifier;
        return cell;
    }
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"identifierOfDefault"];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger secCount = 1;
    if (self.appInfo.count > 0) {
        secCount++;
    }
    return secCount;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        return self.appInfo.count;
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
        ACRAppInfo *appInfo = self.appInfo[indexPath.row];
        ACRAppInfoController *controller = [[ACRAppInfoController alloc] init];
        controller.appInfo = appInfo;
        controller.delegate = self;
        [self.navigationController pushViewController:controller animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        return UITableViewCellEditingStyleDelete;
    }
    return UITableViewCellEditingStyleNone;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        return YES;
    }
    return NO;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        return @"删除";
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if (indexPath.section == 1) {
            ACRAppInfo *appInfo = self.appInfo[indexPath.row];
            
            NSMutableArray *array = [self.appInfo mutableCopy];
            [array removeObjectAtIndex:indexPath.row];
            self.appInfo = [array copy];
            
            if (self.appInfo.count) {
                [tableView beginUpdates];
                [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                [tableView endUpdates];
            } else {
                [tableView reloadData];
            }
            
            [ACRAppDataBase deleteAppInfoWithIdentifier:appInfo.app_identifier];
        }
    }
}

#pragma mark - ACRAppInfoControllerDelegate

- (void)appInfoController:(ACRAppInfoController *)controller didRecvicedAppInfo:(ACRAppInfo *)appInfo {
    if (![self.appInfo containsObject:appInfo]) {
        self.appInfo = [@[appInfo] arrayByAddingObjectsFromArray:self.appInfo];
    }
    [self.tableView reloadData];
    
    [ACRAppDataBase deleteAllAppInfos];
    [ACRAppDataBase insertOrReplaceAppInfos:self.appInfo];
    
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
