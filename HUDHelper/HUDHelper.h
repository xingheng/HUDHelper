//
//  HUDHelper.h
//  DragonSourceCommon
//
//  Created by WeiHan on 1/29/16.
//  Copyright © 2016 DragonSource. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MBProgressHUD/MBProgressHUD.h>

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

- (HUDHelper *(^)(UIView *))setCustomView;


#pragma mark - DEPRECATED METHODS

#pragma mark - Indicator

+ (MBProgressHUD *)showIndicatorToView:(UIView *)view DEPRECATED_ATTRIBUTE;

+ (MBProgressHUD *)showIndicatorToView:(UIView *)view text:(NSString *)text DEPRECATED_ATTRIBUTE;

+ (MBProgressHUD *)showHUDIndicatorInWindow DEPRECATED_ATTRIBUTE;

#pragma mark - HUD

+ (MBProgressHUD *)showHUDInView:(UIView *)view text:(NSString *)text DEPRECATED_ATTRIBUTE;

+ (MBProgressHUD *)showHUDInView:(UIView *)view text:(NSString *)text delay:(NSTimeInterval)delay DEPRECATED_ATTRIBUTE;

+ (MBProgressHUD *)showHUDTextInWindow:(NSString *)text DEPRECATED_ATTRIBUTE;

+ (void)showHUDInView:(UIView *)view completedText:(NSString *)text DEPRECATED_ATTRIBUTE;

#pragma mark - hidden

+ (void)hideHUDInView:(UIView *)view completedText:(NSString *)text DEPRECATED_ATTRIBUTE;

+ (void)hideHUDForView:(UIView *)view DEPRECATED_ATTRIBUTE;

+ (void)hideHUDForWindow DEPRECATED_ATTRIBUTE;

@end


#pragma mark - Helper Functions

HUDHelper * HUDToast(UIView *view);

HUDHelper * HUDToastInWindow();

HUDHelper * HUDIndicator(UIView *view);

HUDHelper * HUDIndicatorInWindow();

void HUDHide(UIView *view);

void HUDHideAnimated(UIView *view, BOOL animated);

void HUDHideInWindowAnimated(BOOL animated);

void HUDHideInWindow();
