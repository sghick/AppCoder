//
//  ACRAppModels.h
//  AppCoder
//
//  Created by 丁治文 on 2018/11/1.
//  Copyright © 2018年 sumrise.com. All rights reserved.
//

#import "SMRModel.h"

@interface ACRAppModels : NSObject

@end

@interface ACRMetaInfo : NSObject

@property (copy  , nonatomic) NSString *property_name; // 属性名
@property (copy  , nonatomic) NSString *title; ///< 标题
@property (copy  , nonatomic) NSString *type; // 类型
@property (copy  , nonatomic) NSString *value; // 内容
@property (assign, nonatomic) BOOL required; // 必填项,value不能为空

@end

@interface ACRMetaProperty : NSObject

@property (copy  , nonatomic) NSString *title; ///< 标题
@property (copy  , nonatomic) NSString *type; // 类型
@property (copy  , nonatomic) NSString *des; ///< 描述
@property (copy  , nonatomic) NSString *symbols; ///< 标记

@property (copy  , nonatomic) NSString *value; // 内容

@end

@interface ACRTempleteMeta : NSObject

@property (copy  , nonatomic) NSString *identifier; ///< 模版唯一标识
@property (copy  , nonatomic) NSString *super_identifier; ///< 唯一标识

@property (assign, nonatomic) BOOL is_root; ///< 根模版
@property (copy  , nonatomic) NSString *title; ///< 模版名称
@property (copy  , nonatomic) NSString *des; ///< 描述
@property (copy  , nonatomic) NSString *rem; ///< 注释
@property (copy  , nonatomic) NSString *code; ///< 代码

@property (copy  , nonatomic) NSArray<ACRMetaProperty *> *inputs; ///< 输入元素


@end

@interface ACRAppInfo : NSObject

@property (copy  , nonatomic) NSString *identifier; ///< 唯一标识
@property (copy  , nonatomic) NSString *super_identifier; ///< 唯一标识

@property (assign, nonatomic) BOOL is_root; ///< 根信息

@property (copy  , nonatomic) NSArray<ACRMetaProperty *> *inputs; ///< 输入元素
@property (strong, nonatomic) NSString *meta_identifier;

- (NSString *)infoTitle;
- (NSString *)infoDescription;

@end

