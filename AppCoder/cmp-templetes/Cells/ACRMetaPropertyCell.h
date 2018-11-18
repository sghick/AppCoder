//
//  ACRMetaPropertyCell.h
//  AppCoder
//
//  Created by 丁治文 on 2018/11/18.
//  Copyright © 2018年 sumrise.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ACRMetaProperty;
@interface ACRMetaPropertyCell : UITableViewCell

/// value值发生变化时,input.value值会被刷新
@property (strong, nonatomic) ACRMetaProperty *input;

@end
