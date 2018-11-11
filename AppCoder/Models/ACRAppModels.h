//
//  ACRAppModels.h
//  AppCoder
//
//  Created by 丁治文 on 2018/11/1.
//  Copyright © 2018年 sumrise.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ACRAppModels : NSObject

@end

@interface ACRAppInfo : NSObject

@property (copy  , nonatomic) NSString *app_identifier;
@property (copy  , nonatomic) NSString *name;

@end

@interface ACRAppMethod : NSObject

@property (copy  , nonatomic) NSString *method_dentifier;
@property (copy  , nonatomic) NSString *name;
@property (copy  , nonatomic) NSString *content;

@end

@interface ACRAppClass : NSObject

@property (copy  , nonatomic) NSString *class_identifier;
@property (copy  , nonatomic) NSString *name;
@property (copy  , nonatomic) NSArray<ACRAppMethod *> *method_list;

@end

@interface ACRAppPage : NSObject

@property (copy  , nonatomic) NSString *page_identifier;
@property (copy  , nonatomic) NSString *name;

@property (copy  , nonatomic) NSArray<ACRAppPage *> *pages;

// 拓展
@property (copy  , nonatomic) NSString *app_identifier;
@property (assign, nonatomic) BOOL root_page;

@end

@interface ACRAppDelegate : NSObject

@property (copy  , nonatomic) NSString *delegate_identifier;
@property (copy  , nonatomic) NSString *name;

// 拓展
@property (copy  , nonatomic) NSString *app_identifier;

@end


