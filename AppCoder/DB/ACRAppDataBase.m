//
//  ACRAppDataBase.m
//  AppCoder
//
//  Created by 丁治文 on 2018/11/2.
//  Copyright © 2018年 sumrise.com. All rights reserved.
//

#import "ACRAppDataBase.h"
#import "SMRDB.h"
#import "ACRAppModels.h"

@implementation ACRAppDataBase

#pragma mark - ACRAppInfo

+ (void)insertOrReplaceAppInfos:(NSArray<ACRAppInfo *> *)appInfos {
    [ACRAppInfo insertOrReplace:appInfos];
}
+ (NSArray<ACRAppInfo *> *)selectAllAppInfos {
    return [ACRAppInfo selectAll];
}
+ (BOOL)deleteAppInfoWithIdentifier:(NSString *)identifier {
    if (!identifier) {
        return NO;
    }
    NSString *where = @"WHERE app_identifier=(?)";
    return [ACRAppInfo deleteWhere:where paramsArray:@[identifier]];
}
+ (BOOL)deleteAllAppInfos {
    return [ACRAppInfo deleteAll];
}

#pragma mark - ACRAppPage

+ (void)insertOrReplaceAppPages:(NSArray<ACRAppPage *> *)appPages appIdentifier:(NSString *)appIdentifier root:(BOOL)root {
    if (!appIdentifier) {
        return;
    }
    NSDictionary *genParam = @{@"app_identifier":appIdentifier,
                               @"root_page":@(root)};
    [ACRAppPage insertOrReplace:appPages generalParam:genParam];
}
+ (NSArray<ACRAppPage *> *)selectAppPagesWithAppIdentifier:(NSString *)appIdentifier root:(BOOL)root {
    if (!appIdentifier) {
        return nil;
    }
    NSString *where = @"WHERE app_identifier=(?) AND root_page=(?)";
    return [ACRAppPage selectWhere:where paramsArray:@[appIdentifier, @(root)]];
}
+ (BOOL)deleteAppPageWithIdentifier:(NSString *)identifier {
    if (!identifier) {
        return NO;
    }
    NSString *where = @"WHERE page_identifier=(?)";
    return [ACRAppPage deleteWhere:where paramsArray:@[identifier]];
}
+ (BOOL)deleteAppPagesWithAppIdentifier:(NSString *)appIdentifier root:(BOOL)root {
    if (!appIdentifier) {
        return NO;
    }
    NSString *where = @"WHERE app_identifier=(?) AND root_page=(?)";
    return [ACRAppPage deleteWhere:where paramsArray:@[appIdentifier, @(root)]];
}

@end
