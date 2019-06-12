//
//  HUDHelper.h
//  DragonSourceCommon
//
//  Created by WeiHan on 1/29/16.
//  Copyright © 2016 DragonSource. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MBProgressHUD/MBProgressHUD.h>

@class HUDHelper;

typedef void (*HUDHelperConfigurationHandler)(HUDHelper *);
typedef void (^HUDHelperConfigurationBlock)(HUDHelper *);
typedef void (^HUDHelperButtonActionBlock)(UIButton *);

typedef void * const HUDHelperContextKey;


@interface HUDHelper : MBProgressHUD

@property (nonatomic, assign, readonly) HUDHelperContextKey contextKey;

- (HUDHelper *(^)(void))show;

- (HUDHelper *(^)(void))hide;

- (HUDHelper *(^)(BOOL))animation;

- (HUDHelper *(^)(NSTimeInterval))delay;

- (HUDHelper *(^)(MBProgressHUDCompletionBlock))completion;

- (HUDHelper *(^)(NSString *))title;

- (HUDHelper *(^)(UIFont *))titleFont;

- (HUDHelper *(^)(UIColor *))titleColor;

- (HUDHelper *(^)(NSString *))subtitle;

- (HUDHelper *(^)(UIFont *))subtitleFont;

- (HUDHelper *(^)(UIColor *))subtitleColor;

- (HUDHelper *(^)(BOOL))interactionEnabled;

- (HUDHelper *(^)(MBProgressHUDMode))setMode;

- (HUDHelper *(^)(HUDHelperButtonActionBlock))actionButton;

- (HUDHelper *(^)(UIView *))setCustomView;

- (HUDHelper *(^)(HUDHelperContextKey))context;

- (HUDHelper *(^)(HUDHelperConfigurationBlock))customConfiguration;

@end


#pragma mark - Helper Functions

void SetupHUDHelperConfiguration(HUDHelperConfigurationHandler handler, UIWindow *containerWindow);

HUDHelper * HUDToast(UIView *view);

HUDHelper * HUDToastInWindow(void);

HUDHelper * HUDIndicator(UIView *view);

HUDHelper * HUDIndicatorInWindow(void);

void HUDHide(UIView *view);

void HUDHideAnimated(UIView *view, BOOL animated);

void HUDHideInWindowAnimated(BOOL animated);

void HUDHideInWindow(void);

void HUDHideAllToasts(BOOL animated);

void HUDHideAllIndicators(BOOL animated);

void HUDHideAll(BOOL animated);
