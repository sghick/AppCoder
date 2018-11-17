//
//  ACRAppInfoController.h
//  AppCoder
//
//  Created by 丁治文 on 2018/11/2.
//  Copyright © 2018年 sumrise.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ACRAppInfo;
@class ACRAppInfoController;
@protocol ACRAppInfoControllerDelegate <NSObject>

- (void)appInfoController:(ACRAppInfoController *)controller didRecvicedAppInfo:(ACRAppInfo *)appInfo;

@end

@interface ACRAppInfoController : UIViewController

@property (strong, nonatomic) ACRAppInfo *appInfo;///< 如果需要编辑,传这个参数
@property (weak  , nonatomic) id<ACRAppInfoControllerDelegate> delegate;


@end
