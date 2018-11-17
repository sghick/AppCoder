//
//  ACRAppModels.m
//  AppCoder
//
//  Created by 丁治文 on 2018/11/1.
//  Copyright © 2018年 sumrise.com. All rights reserved.
//

#import "ACRAppModels.h"

@implementation ACRAppModels

@end

@implementation ACRMetaProperty 

@end

@implementation ACRTempleteMeta

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"inputs": ACRMetaProperty.class};
}

@end

@implementation ACRAppInfo

@end
