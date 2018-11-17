//
//  ACRAddBtn.m
//  AppCoder
//
//  Created by 丁治文 on 2018/11/17.
//  Copyright © 2018年 sumrise.com. All rights reserved.
//

#import "ACRAddBtn.h"

@implementation ACRAddBtn

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.cornerRadius = 25;
        self.backgroundColor = [UIColor yellowColor];
        self.titleLabel.font = [UIFont boldSystemFontOfSize:80];
        [self setTitle:@"+" forState:UIControlStateNormal];
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    return self;
}

+ (CGSize)generalSize {
    return CGSizeMake(50, 50);
}

@end
