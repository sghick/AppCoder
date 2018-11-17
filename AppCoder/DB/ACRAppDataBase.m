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

@end
