//
//  ACRSubmetaSelectController.h
//  AppCoder
//
//  Created by 丁治文 on 2018/11/19.
//  Copyright © 2018 sumrise.com. All rights reserved.
//

#import "ACRBaseController.h"

@class ACRSubmetaSelectController;
@class ACRTempleteMeta;
@protocol ACRSubmetaSelectControllerDelegate <NSObject>

- (void)submetaSelectController:(ACRSubmetaSelectController *)controller didSelectedMeta:(ACRTempleteMeta *)meta;

@end

@interface ACRSubmetaSelectController : ACRBaseController

@property (weak  , nonatomic) id<ACRSubmetaSelectControllerDelegate> delegate;

@end

