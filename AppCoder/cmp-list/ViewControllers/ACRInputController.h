//
//  ACRInputController.h
//  AppCoder
//
//  Created by 丁治文 on 2018/11/17.
//  Copyright © 2018年 sumrise.com. All rights reserved.
//

#import "ACRBaseController.h"

@class ACRAppInfo;
@class ACRInputController;
@protocol ACRInputControllerDelegate <NSObject>

- (void)inputController:(ACRInputController *)controller didSaveBtnTouchedWithInfo:(ACRAppInfo *)info;

@end

@class ACRTempleteMeta;
@interface ACRInputController : ACRBaseController

@property (strong, nonatomic, readonly) ACRTempleteMeta *meta;
@property (strong, nonatomic, readonly) ACRAppInfo *info;
@property (weak  , nonatomic) id<ACRInputControllerDelegate> delegate;

- (void)setContentForAddWithMeta:(ACRTempleteMeta *)meta;
- (void)setContentForEditWithMeta:(ACRTempleteMeta *)meta info:(ACRAppInfo *)info;

@end
