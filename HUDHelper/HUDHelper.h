//
//  HUDHelper.h
//  DragonSourceCommon
//
//  Created by WeiHan on 1/29/16.
//  Copyright © 2016 DragonSource. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MBProgressHUD/MBProgressHUD.h>

typedef void (*HUDHelperConfigurationHandler)(MBProgressHUD *);
typedef void (^HUDHelperConfigurationBlock)(MBProgressHUD *);
typedef void (^HUDHelperButtonActionBlock)(UIButton *);


@interface HUDHelper : MBProgressHUD

- (HUDHelper *(^)())show;

- (HUDHelper *(^)())hide;

- (HUDHelper *(^)(BOOL))animation;

- (HUDHelper *(^)(NSTimeInterval))delay;

- (HUDHelper *(^)(MBProgressHUDCompletionBlock))completion;

- (HUDHelper *(^)(NSString *))title;

- (HUDHelper *(^)(UIFont *))titleFont;

- (HUDHelper *(^)(UIColor *))titleColor;

- (HUDHelper *(^)(NSString *))subTitle;

- (HUDHelper *(^)(UIFont *))subTitleFont;

- (HUDHelper *(^)(UIColor *))subTitleColor;

- (HUDHelper *(^)(BOOL))interactionEnabled;

- (HUDHelper *(^)(MBProgressHUDMode))setMode;

- (HUDHelper *(^)(HUDHelperButtonActionBlock))actionButton;

- (HUDHelper *(^)(UIView *))setCustomView;

- (HUDHelper *(^)(HUDHelperConfigurationBlock))customConfiguration;

@end


#pragma mark - Helper Functions

void SetupHUDHelperConfiguration(HUDHelperConfigurationHandler handler, UIWindow *containerWindow);

HUDHelper * HUDToast(UIView *view);

HUDHelper * HUDToastInWindow();

HUDHelper * HUDIndicator(UIView *view);

HUDHelper * HUDIndicatorInWindow();

void HUDHide(UIView *view);

void HUDHideAnimated(UIView *view, BOOL animated);

void HUDHideInWindowAnimated(BOOL animated);

void HUDHideInWindow();

void HUDHideAllToasts(BOOL animated);

void HUDHideAllIndicators(BOOL animated);

void HUDHideAll(BOOL animated);
