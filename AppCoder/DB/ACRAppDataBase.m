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

#pragma mark - ACRTempleteMeta

+ (void)insertOrReplaceMetas:(NSArray<ACRTempleteMeta *> *)metas {
    [ACRTempleteMeta insertOrReplace:metas];
}
+ (NSArray<ACRTempleteMeta *> *)selectMetasWithGroup:(NSString *)group {
    if (!group) {
        return nil;
    }
    NSString *where = @"WHERE meta_group=(?)";
    return [ACRTempleteMeta selectWhere:where paramsArray:@[group]];
}
+ (ACRTempleteMeta *)selectMetaWithIdentifier:(NSString *)identifier {
    if (!identifier) {
        return nil;
    }
    NSString *where = @"WHERE identifier=(?)";
    return [ACRTempleteMeta selectFirstObjectWhere:where paramsArray:@[identifier]];
}
+ (BOOL)deleteMetaWithIdentifier:(NSString *)identifier {
    if (!identifier) {
        return NO;
    }
    NSString *where = @"WHERE identifier=(?)";
    return [ACRTempleteMeta deleteWhere:where paramsArray:@[identifier]];
}
+ (BOOL)deleteAllMetas {
    return [ACRTempleteMeta deleteAll];
}

#pragma mark - ACRAppInfo

+ (void)insertOrReplaceAppInfos:(NSArray<ACRAppInfo *> *)appInfos {
    [ACRAppInfo insertOrReplace:appInfos];
}
+ (NSArray<ACRAppInfo *> *)selectRootAppInfos {
    NSString *where = @"WHERE is_root=1";
    return [ACRAppInfo selectWhere:where];
}
+ (NSArray<ACRAppInfo *> *)selectAppInfosWithSuperIdentifier:(NSString *)superIdentifier {
    if (!superIdentifier) {
        return nil;
    }
    NSString *where = @"WHERE super_identifier=(?)";
    return [ACRAppInfo selectWhere:where paramsArray:@[superIdentifier]];
}
+ (BOOL)deleteAppInfoWithIdentifier:(NSString *)identifier {
    if (!identifier) {
        return nil;
    }
    NSString *where = @"WHERE identifier=(?)";
    return [ACRAppInfo deleteWhere:where paramsArray:@[identifier]];
}
+ (BOOL)deleteRootAppInfos {
    NSString *where = @"WHERE is_root=1";
    return [ACRAppInfo deleteWhere:where];
}
+ (BOOL)deleteAppInfosWithSuperIdentifier:(NSString *)superIdentifier {
    if (!superIdentifier) {
        return nil;
    }
    NSString *where = @"WHERE super_identifier=(?)";
    return [ACRAppInfo deleteWhere:where paramsArray:@[superIdentifier]];
}

@end
