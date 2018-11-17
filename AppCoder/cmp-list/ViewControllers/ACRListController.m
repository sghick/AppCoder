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
ACRInputControllerDelegate>

@property (strong, nonatomic) NSArray *infoList;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) ACRAddBtn *addBtn;
@property (strong, nonatomic) ACRSideMenu *sideMenu;
@property (strong, nonatomic) NSArray<ACRTempleteMeta *> *rootMetas;

@end

@implementation ACRListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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

#pragma mark - UITableViewDataSource, UITableViewDelegate

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    SMRRow *row = [tableView rowWithIndexPath:indexPath];
    switch (row.rowKey) {
        case kRowTypeList: {
            ACRListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierOfListCell];
            id info = self.infoList[row.rowSamesIndex];
            return cell;
        }
            break;
            
        default:
            break;
    }
    
    return nil;
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

#pragma mark - ACRSideMenuDelegate

- (CGFloat)sideMenuView:(ACRSideMenu *)menu heightOfItem:(UIView *)item atIndex:(NSInteger)index {
    return 30;
}

- (void)sideMenuView:(ACRSideMenu *)menu didTouchedItem:(UIView *)item atIndex:(NSInteger)index {
    [menu hide];
    ACRTempleteMeta *meta = self.rootMetas[index];
    [self pusthToInputControllerWithMeat:meta];
}

#pragma mark - Actions

- (void)addBtnAction:(UIButton *)sender {
    NSArray<ACRTempleteMeta *> *rootMetas = [ACRAppDataBase selectMetasWithGroup:@"root"];
    self.rootMetas = rootMetas;
    
    NSMutableArray *titles = [NSMutableArray array];
    for (ACRTempleteMeta *obj in rootMetas) {
        [titles addObject:obj.name];
    }
    NSArray *items = [ACRSideMenu menuItemsWithTitles:titles];
    CGPoint origin = CGPointMake(sender.frame.origin.x - 200 - 10, sender.frame.origin.y);
    [self.sideMenu loadMenuWithItems:items menuWidth:200 origin:origin];
    [self.sideMenu show];
}

#pragma mark - ACRInputControllerDelegate

- (void)inputController:(ACRInputController *)controller didSaveBtnTouchedWithInfo:(id)info {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - JumpLogical

- (void)pusthToInputControllerWithMeat:(ACRTempleteMeta *)meta {
    ACRInputController *inputVC = [[ACRInputController alloc] init];
    inputVC.mata = meta;
    inputVC.delegate = self;
    inputVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:inputVC animated:YES];
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
