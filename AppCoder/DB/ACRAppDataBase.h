//
//  ACRAppDataBase.h
//  AppCoder
//
//  Created by 丁治文 on 2018/11/2.
//  Copyright © 2018年 sumrise.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ACRAppInfo;
@interface ACRAppDataBase : NSObject

#pragma mark - ACRAppInfo

+ (void)insertOrReplaceAppInfos:(NSArray<ACRAppInfo *> *)appInfos;
+ (NSArray<ACRAppInfo *> *)selectAllAppInfos;
+ (BOOL)deleteAppInfoWithIdentifier:(NSString *)identifier;
+ (BOOL)deleteAllAppInfos;

@end
