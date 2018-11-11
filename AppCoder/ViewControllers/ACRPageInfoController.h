//
//  ACRPageInfoController.h
//  AppCoder
//
//  Created by 丁治文 on 2018/11/11.
//  Copyright © 2018年 sumrise.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ACRAppPage;
@class ACRPageInfoController;
@protocol ACRPageInfoControllerDelegate <NSObject>

- (void)appPageInfoController:(ACRPageInfoController *)controller didRecvicedAppPage:(ACRAppPage *)appPage;

@end

@class ACRAppInfo;
@class ACRAppPage;
@interface ACRPageInfoController : UIViewController

@property (strong, nonatomic) ACRAppPage *page;
@property (assign, nonatomic) BOOL isRoot;

@property (weak  , nonatomic) id<ACRPageInfoControllerDelegate> delegate;

@end
