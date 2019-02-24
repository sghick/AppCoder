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

@implementation ACRMetaInfo

@end

@implementation ACRMetaProperty 

@end

@implementation ACRTempleteMeta

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"inputs": ACRMetaProperty.class};
}

@end

@implementation ACRAppInfo

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"inputs": ACRMetaProperty.class};
}

- (NSString *)infoTitle {
    // 寻找title的property,使用第1个作为title
    return self.inputs.firstObject.value;
}

- (NSString *)infoDescription {
    // 寻找des的property,使用第2个作为des
    if (self.inputs.count > 1) {
        return self.inputs[1].value;
    }
    return nil;
}

@end
