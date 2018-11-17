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

@interface ACRMetaProperty : NSObject

@property (copy  , nonatomic) NSString *name;
@property (copy  , nonatomic) NSString *value;
@property (copy  , nonatomic) NSString *type;

@end

@interface ACRTempleteMeta : NSObject

@property (copy  , nonatomic) NSString *identifier; ///< 模版唯一标识
@property (copy  , nonatomic) NSString *name; ///< 模版名称
@property (copy  , nonatomic) NSString *meta_group; ///< 分组
@property (copy  , nonatomic) NSString *rem; ///< 注释
@property (copy  , nonatomic) NSString *code; ///< 代码
@property (copy  , nonatomic) NSArray<ACRMetaProperty *> *inputs; ///< 输入元素
@property (copy  , nonatomic) NSArray<NSString *> *subTempletes; ///< 子模板的id


@end

