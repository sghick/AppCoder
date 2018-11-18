//
//  ACRMetaInfoCell.h
//  AppCoder
//
//  Created by 丁治文 on 2018/11/18.
//  Copyright © 2018年 sumrise.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ACRMetaInfo;
@interface ACRMetaInfoCell : UITableViewCell

/// value值发生变化时,info.value值会被刷新
@property (strong, nonatomic) ACRMetaInfo *info;

@end
