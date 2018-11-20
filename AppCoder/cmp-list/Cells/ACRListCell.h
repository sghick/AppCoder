//
//  ACRListCell.h
//  AppCoder
//
//  Created by 丁治文 on 2018/11/17.
//  Copyright © 2018年 sumrise.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ACRAppInfo;
@class ACRListCell;
@protocol ACRListCellDelegate <NSObject>

- (void)listCell:(ACRListCell *)cell didEditBtnTouched:(ACRAppInfo *)info;

@end

@class ACRAppInfo;
@interface ACRListCell : UITableViewCell

@property (strong, nonatomic, readonly) ACRAppInfo *appInfo;
@property (weak  , nonatomic) id<ACRListCellDelegate> delegate;

- (void)setContentWithAppInfo:(ACRAppInfo *)appInfo;

@end
