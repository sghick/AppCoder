//
//  ACRInputController.h
//  AppCoder
//
//  Created by 丁治文 on 2018/11/17.
//  Copyright © 2018年 sumrise.com. All rights reserved.
//

#import "ACRBaseController.h"

@class ACRInputController;
@protocol ACRInputControllerDelegate <NSObject>

- (void)inputController:(ACRInputController *)controller didSaveBtnTouchedWithInfo:(id)info;

@end

@class ACRTempleteMeta;
@interface ACRInputController : ACRBaseController

@property (strong, nonatomic) ACRTempleteMeta *mata;
@property (weak  , nonatomic) id<ACRInputControllerDelegate> delegate;

@end
