//
//  ACRAppEditController.m
//  AppCoder
//
//  Created by 丁治文 on 2018/10/31.
//  Copyright © 2018年 sumrise.com. All rights reserved.
//

#import "ACRAppEditController.h"
#import "ACRAppModels.h"
#import "ACRAppDataBase.h"

@interface ACRAppEditController ()<
UITableViewDelegate,
UITableViewDataSource
>

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) ACRAppDelegate *appDelegate;
@property (strong, nonatomic) NSArray<ACRAppPage *> *rootPages;
@property (strong, nonatomic) NSArray<ACRAppPage *> *appPages;

@end

@implementation ACRAppEditController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    self.navigationItem.title = self.appInfo.name;
    
    [self.view addSubview:self.tableView];
    
    [self queryDataFromDB];
    [self.tableView reloadData];
}

#pragma mark - Datas

- (void)queryDataFromDB {

}

#pragma mark - UITableViewDataSource, UITableViewDelegate

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"identifierOfAddPages"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"identifierOfAddPages"];
        }
        cell.textLabel.text = @"添加页面 ++++++ ";
        return cell;
    } else if (indexPath.section == 1) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"identifierOfAppDelegate"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"identifierOfAppDelegate"];
        }
        cell.textLabel.text = @"AppDelegate";
        return cell;
    } else if (indexPath.section == 2) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"identifierOfRootPages"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"identifierOfRootPages"];
        }
        ACRAppPage *page = self.rootPages[indexPath.row];
        cell.textLabel.text = [NSString stringWithFormat:@"Root:%@", page.page_name];
        return cell;
    } else if (indexPath.section == 3) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"identifierOfAppPages"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"identifierOfAppPages"];
        }
        ACRAppPage *page = self.appPages[indexPath.row];
        cell.textLabel.text = page.page_name;
        return cell;
    }
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"identifierOfDefault"];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger secCount = 1;
    if (self.appDelegate) {
        secCount++;
    }
    if (self.rootPages.count > 0) {
        secCount++;
    }
    if (self.appPages.count > 0) {
        secCount++;
    }
    return secCount;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        return 1;
    } else if (section == 2) {
        return self.rootPages.count;
    } else if (section == 3) {
        return self.appPages.count;
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    if (section == 0) {
        [self p_showAddPagesTypeSelectionsAlert];
    } else if (section == 1) {
        
    } else if (section == 2) {
        
    } else if (section == 3) {
        
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        return YES;
    }
    if (indexPath.section == 2) {
        return YES;
    }
    if (indexPath.section == 3) {
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
    ACRAppPage *appPage = self.appPages[indexPath.row];
    
    NSMutableArray *array = [self.appPages mutableCopy];
    [array removeObjectAtIndex:indexPath.row];
    self.appPages = [array copy];
    
    if (self.appPages.count) {
        [tableView beginUpdates];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [tableView endUpdates];
    } else {
        [tableView reloadData];
    }
    
//    [ACRAppDataBase deleteAppPageWithIdentifier:appPage.page_identifier];
}

- (void)p_updateAppInfoWithIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    if (section == 2) {
        ACRAppPage *appPage = self.appPages[indexPath.row];
        
//        controller.delegate = self;
//        [self.navigationController pushViewController:controller animated:YES];
    }
}

- (void)p_showAddPagesTypeSelectionsAlert {
    UIAlertController *alert = [[UIAlertController alloc] init];
    UIAlertAction *addDelegateAction = [UIAlertAction actionWithTitle:@"新增AppDelegate" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        ACRAppDelegate *appDelegate = [[ACRAppDelegate alloc] init];
        appDelegate.delegate_identifier = [NSUUID UUID].UUIDString;
        self.appDelegate = appDelegate;
        
        [self.tableView reloadData];
    }];
    UIAlertAction *addRootAction = [UIAlertAction actionWithTitle:@"新增Root" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        ACRAppPage *page = [[ACRAppPage alloc] init];
        page.page_identifier = [NSUUID UUID].UUIDString;
        page.isRootPage = YES;
        NSMutableArray *pgs = [NSMutableArray arrayWithArray:self.rootPages];
        [pgs insertObject:page atIndex:0];
        self.rootPages = [pgs copy];
        
        [self.tableView reloadData];
    }];
    UIAlertAction *addPagesAction = [UIAlertAction actionWithTitle:@"新增Pages" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        ACRAppPage *page = [[ACRAppPage alloc] init];
        page.page_identifier = [NSUUID UUID].UUIDString;
        page.isRootPage = NO;
        NSMutableArray *pgs = [NSMutableArray arrayWithArray:self.appPages];
        [pgs insertObject:page atIndex:0];
        self.appPages = [pgs copy];
        
        [self.tableView reloadData];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        // cancel
    }];
    [alert addAction:addDelegateAction];
    [alert addAction:addRootAction];
    [alert addAction:addPagesAction];
    [alert addAction:cancelAction];
    [self.navigationController presentViewController:alert animated:YES completion:nil];
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
