//
//  ACRSideMenu.h
//  AppCoder
//
//  Created by 丁治文 on 2018/11/17.
//  Copyright © 2018年 sumrise.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ACRSideMenu;
@protocol ACRSideMenuDelegate <NSObject>

@required
- (CGFloat)sideMenuView:(ACRSideMenu *)menu heightOfItem:(UIView *)item atIndex:(NSInteger)index;
@optional
- (void)sideMenuView:(ACRSideMenu *)menu didTouchedItem:(UIView *)item atIndex:(NSInteger)index;
- (void)sideMenuViewWillDismiss:(ACRSideMenu *)menu;///< 菜单即将消失时的回调

@end

@interface ACRSideMenu : UIView

@property (nonatomic, weak  ) id<ACRSideMenuDelegate> delegate;
@property (nonatomic, strong, readonly) NSArray<UIView *> *menuItems;
@property (nonatomic, assign, readonly) CGFloat menuWidth;
@property (nonatomic, assign) CGFloat maxHeightOfContent;///< view.height
@property (nonatomic, assign) BOOL scrollEnabled;///< default:YES

- (void)loadMenuWithItems:(NSArray<UIView *> *)menuItems menuWidth:(CGFloat)menuWidth origin:(CGPoint)origin;

- (void)show;
- (void)showInView:(UIView *)view;
- (void)hide;

+ (NSArray<UIView *> *)menuItemsWithTitles:(NSArray<NSString *> *)titles;

@end
