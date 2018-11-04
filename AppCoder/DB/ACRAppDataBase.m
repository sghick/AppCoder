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
    NSString *where = @"WHERE app_identifier=(?)";
    return [ACRAppInfo deleteWhere:where paramsArray:@[identifier]];
}
+ (BOOL)deleteAllAppInfos {
    return [ACRAppInfo deleteAll];
}

@end
