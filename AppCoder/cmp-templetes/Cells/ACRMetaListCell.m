//
//  ACRMetaListCell.m
//  AppCoder
//
//  Created by 丁治文 on 2018/11/20.
//  Copyright © 2018年 sumrise.com. All rights reserved.
//

#import "ACRMetaListCell.h"
#import "ACRAppModels.h"

@implementation ACRMetaListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

- (void)setContentWithMeta:(ACRTempleteMeta *)meta {
    _meta = meta;
    self.textLabel.text = meta.title;
    self.detailTextLabel.text = meta.des;
}

@end
