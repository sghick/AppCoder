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
#import "SMRTableAssistant.h"
#import "ACRPageInfoController.h"
#import "ACRClassEditController.h"

typedef NS_ENUM(NSInteger, kSectionType) {
    kSectionTypeAdd,
    kSectionTypeAppDelegate,
    kSectionTypeRootPage,
    kSectionTypePages
};

typedef NS_ENUM(NSInteger, kRowType) {
    kRowTypeAdd,
    kRowTypeAppDelegate,
    kRowTypeRootPage,
    kRowTypePages
};

@interface ACRAppEditController ()<
UITableViewDelegate,
UITableViewDataSource,
UITableViewSectionsDelegate,
ACRPageInfoControllerDelegate
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
    [self.tableView smr_reloadData];
}

#pragma mark - Datas

- (void)queryDataFromDB {
    ACRAppDelegate *delegate = [[ACRAppDelegate alloc] init];
    delegate.app_identifier = self.appInfo.app_identifier;
    delegate.delegate_identifier = [NSUUID UUID].UUIDString;
    delegate.name = @"AppDelegate";
    self.appDelegate = delegate;
    
    self.rootPages = [ACRAppDataBase selectAppPagesWithAppIdentifier:self.appInfo.app_identifier root:YES];
    self.appPages = [ACRAppDataBase selectAppPagesWithAppIdentifier:self.appInfo.app_identifier root:NO];
}

#pragma mark - UITableViewSectionsDelegate

- (SMRSections *)sectionsInTableView:(UITableView *)tableView {
    SMRSections *sections = [[SMRSections alloc] init];
    [sections addSectionKey:kSectionTypeAdd rowKey:kRowTypeAdd];
    [sections addSectionKey:kSectionTypeAppDelegate rowKey:kRowTypeAppDelegate rowSamesCount:self.appDelegate?1:0];
    [sections addSectionKey:kSectionTypeRootPage rowKey:kRowTypeRootPage rowSamesCount:self.rootPages.count];
    [sections addSectionKey:kSectionTypePages rowKey:kRowTypePages rowSamesCount:self.appPages.count];
    return sections;
}

#pragma mark - UITableViewDataSource, UITableViewDelegate

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    SMRRow *row = [tableView rowWithIndexPath:indexPath];
    switch (row.rowKey) {
        case kRowTypeAdd:{
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"identifierOfAddPages"];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"identifierOfAddPages"];
            }
            cell.textLabel.text = @"Add ++++++ ";
            return cell;
        }
            break;
        case kRowTypeAppDelegate: {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"identifierOfAppDelegate"];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"identifierOfAppDelegate"];
            }
            cell.textLabel.text = self.appDelegate.name;
            return cell;
        }
            break;
        case kRowTypeRootPage: {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"identifierOfRootPages"];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"identifierOfRootPages"];
            }
            ACRAppPage *page = self.rootPages[row.rowSamesIndex];
            cell.textLabel.text = page.name;
            return cell;
        }
            break;
        case kRowTypePages: {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"identifierOfAppPages"];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"identifierOfAppPages"];
            }
            ACRAppPage *page = self.appPages[row.rowSamesIndex];
            cell.textLabel.text = page.name;
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
    switch (row.rowKey) {
        case kRowTypeAdd: {
            [self p_showAddAlert];
        }
            break;
        case kRowTypeAppDelegate: {

        }
            break;
        case kRowTypeRootPage: {
            ACRAppPage *page = self.rootPages[row.rowSamesIndex];
            ACRClassEditController *vc = [[ACRClassEditController alloc] init];
            vc.appPage = page;
            vc.appInfo = self.appInfo;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case kRowTypePages: {
            ACRAppPage *page = self.appPages[row.rowSamesIndex];
            ACRClassEditController *vc = [[ACRClassEditController alloc] init];
            vc.appPage = page;
            vc.appInfo = self.appInfo;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        default:
            break;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    SMRRow *row = [tableView rowWithIndexPath:indexPath];
    switch (row.rowKey) {
        case kRowTypeAdd: {
            return NO;
        }
            break;
        case kRowTypeAppDelegate:
        case kRowTypeRootPage:
        case kRowTypePages: {
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

- (void)p_askNeedsDeleteAppInfoInTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
    SMRRow *row = [tableView rowWithIndexPath:indexPath];
    
    if (row.rowKey == kRowTypeRootPage) {
        ACRAppPage *appPage = self.rootPages[row.rowSamesIndex];
        NSMutableArray *array = [self.rootPages mutableCopy];
        [array removeObjectAtIndex:row.rowSamesIndex];
        self.rootPages = [array copy];
        
        if (self.rootPages.count) {
            [tableView beginUpdates];
            [tableView smr_deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            [tableView endUpdates];
        } else {
            [tableView smr_reloadData];
        }
        [ACRAppDataBase deleteAppPageWithIdentifier:appPage.page_identifier];
    } else if (row.rowKey == kRowTypePages) {
        ACRAppPage *appPage = self.appPages[row.rowSamesIndex];
        NSMutableArray *array = [self.appPages mutableCopy];
        [array removeObjectAtIndex:row.rowSamesIndex];
        self.appPages = [array copy];
        
        if (self.appPages.count) {
            [tableView beginUpdates];
            [tableView smr_deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            [tableView endUpdates];
        } else {
            [tableView smr_reloadData];
        }
        [ACRAppDataBase deleteAppPageWithIdentifier:appPage.page_identifier];
    }
}

- (void)p_updateAppInfoWithIndexPath:(NSIndexPath *)indexPath {
    SMRRow *row = [self.tableView rowWithIndexPath:indexPath];
    if (row.rowKey == kRowTypeRootPage) {
        ACRAppPage *page = self.rootPages[row.rowSamesIndex];
        ACRPageInfoController *pageInfoVC = [[ACRPageInfoController alloc] init];
        pageInfoVC.delegate = self;
        pageInfoVC.page = page;
        pageInfoVC.isRoot = YES;
        [self.navigationController pushViewController:pageInfoVC animated:YES];
    } else if (row.rowKey == kRowTypePages) {
        ACRAppPage *page = self.appPages[row.rowSamesIndex];
        ACRPageInfoController *pageInfoVC = [[ACRPageInfoController alloc] init];
        pageInfoVC.delegate = self;
        pageInfoVC.page = page;
        pageInfoVC.isRoot = NO;
        [self.navigationController pushViewController:pageInfoVC animated:YES];
    }
}

- (void)p_showAddAlert {
    UIAlertController *alert = [[UIAlertController alloc] init];
    UIAlertAction *rootAction = [UIAlertAction actionWithTitle:@"Root" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        ACRPageInfoController *pageInfoVC = [[ACRPageInfoController alloc] init];
        pageInfoVC.delegate = self;
        pageInfoVC.page = nil;
        pageInfoVC.isRoot = YES;
        [self.navigationController pushViewController:pageInfoVC animated:YES];
    }];
    UIAlertAction *pageAction = [UIAlertAction actionWithTitle:@"Page" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        ACRPageInfoController *pageInfoVC = [[ACRPageInfoController alloc] init];
        pageInfoVC.delegate = self;
        pageInfoVC.page = nil;
        pageInfoVC.isRoot = NO;
        [self.navigationController pushViewController:pageInfoVC animated:YES];
    }];
    
    [alert addAction:rootAction];
    [alert addAction:pageAction];
    
    [self.navigationController presentViewController:alert animated:YES completion:nil];
}

#pragma mark - ACRPageInfoControllerDelegate

- (void)appPageInfoController:(ACRPageInfoController *)controller didRecvicedAppPage:(ACRAppPage *)appPage {
    if (controller.isRoot) {
        if (![self.rootPages containsObject:appPage]) {
            self.rootPages = [self.rootPages?:@[] arrayByAddingObject:appPage];
        }
        [self.tableView smr_reloadData];
        
        [ACRAppDataBase deleteAppPagesWithAppIdentifier:self.appInfo.app_identifier root:YES];
        [ACRAppDataBase insertOrReplaceAppPages:self.rootPages appIdentifier:self.appInfo.app_identifier root:YES];
        
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        if (![self.appPages containsObject:appPage]) {
            self.appPages =  [self.appPages?:@[] arrayByAddingObject:appPage];;
        }
        [self.tableView smr_reloadData];
        
        [ACRAppDataBase deleteAppPagesWithAppIdentifier:self.appInfo.app_identifier root:NO];
        [ACRAppDataBase insertOrReplaceAppPages:self.appPages appIdentifier:self.appInfo.app_identifier root:NO];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
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
