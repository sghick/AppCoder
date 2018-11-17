//
//  ACRAppDataBase.h
//  AppCoder
//
//  Created by 丁治文 on 2018/11/2.
//  Copyright © 2018年 sumrise.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ACRTempleteMeta;
@interface ACRAppDataBase : NSObject

#pragma mark - ACRTempleteMeta

+ (void)insertOrReplaceMetas:(NSArray<ACRTempleteMeta *> *)metas;
+ (NSArray<ACRTempleteMeta *> *)selectMetasWithGroup:(NSString *)group;
+ (ACRTempleteMeta *)selectMetaWithIdentifier:(NSString *)identifier;
+ (BOOL)deleteMetaWithIdentifier:(NSString *)identifier;
+ (BOOL)deleteAllMetas;

@end
