//
//  ACRMetaListCell.h
//  AppCoder
//
//  Created by 丁治文 on 2018/11/20.
//  Copyright © 2018年 sumrise.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ACRTempleteMeta;
@interface ACRMetaListCell : UITableViewCell

@property (strong, nonatomic, readonly) ACRTempleteMeta *meta;

- (void)setContentWithMeta:(ACRTempleteMeta *)meta;

@end
