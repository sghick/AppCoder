//
//  ACRTempleteController.h
//  AppCoder
//
//  Created by 丁治文 on 2018/11/17.
//  Copyright © 2018年 sumrise.com. All rights reserved.
//

#import "ACRBaseController.h"

@class ACRTempleteMeta;
@class ACRTempleteController;
@protocol ACRTempleteControllerDelegate <NSObject>

- (void)tempController:(ACRTempleteController *)controller didSaveBtnTouchedWithMeta:(ACRTempleteMeta *)meta;
- (void)tempController:(ACRTempleteController *)controller didDeleteBtnTouchedWithMeta:(ACRTempleteMeta *)meta;

@end

@interface ACRTempleteController : ACRBaseController

@property (strong, nonatomic, readonly) ACRTempleteMeta *meta;
@property (weak  , nonatomic) id<ACRTempleteControllerDelegate> delegate;

@property (assign, nonatomic) BOOL default_is_root;///< 设置默认info.is_root属性

- (void)setContentForAdd;
- (void)setContentForEditWithMeta:(ACRTempleteMeta *)meta;
- (void)setContentForCopyWithMeta:(ACRTempleteMeta *)meta;

@end
