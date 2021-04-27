//
//  HUDHelper.h
//
//  Created by WeiHan on 1/29/16.
//  Copyright © 2016-2021 Wei Han. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MBProgressHUD/MBProgressHUD.h>

NS_ASSUME_NONNULL_BEGIN

@class HUDHelper;

typedef __weak id HUDHelperContext;
typedef void (^HUDHelperConfiguration)(HUDHelper *hud);


@interface HUDHelperPreferences : NSObject

/// Window as HUD container used to show.
@property (nonatomic, strong) UIWindow *window;

/// User reading rate, used to control the toast's show time according the total length
/// of main title text and secondary title text.
/// Defaults to 0 means do nothing.
@property (nonatomic, assign) CGFloat readingRate;

/// Whether allow multiple HUDs could be attached to a same UIView or not.
/// Defaults to YES.
@property (nonatomic, assign) BOOL allowMultipleHUDsInSameView;

/// HUD configuration for all instances when initializing.
/// This block allow you to define your custom HUD features without inheriting.
@property (nonatomic, copy) HUDHelperConfiguration configuration;

@end


@interface HUDHelper : MBProgressHUD

/// The context when initializing.
@property (nonatomic, weak, readonly) HUDHelperContext contextInfo;

@end


@interface HUDHelper (Initializer)

/// HUD configuration for all the instances.
@property (nonatomic, copy, class, null_resettable) HUDHelperPreferences *preferences;

/// Initialize a toast with specified view.
+ (HUDHelper * (^)(UIView *))toast;

/// Initialize a toast with default window.
+ (HUDHelper * (^)(void))toastInWindow;

/// Initialize an indicator with specified view.
+ (HUDHelper * (^)(UIView *))indicator;

/// Initialize an indicator with default window.
+ (HUDHelper * (^)(void))indicatorInWindow;

/// Return the latest HUD be shown.
+ (HUDHelper * (^)(UIView * _Nullable))lastest;

@end


@interface HUDHelper (Configuration)

/// Completion block when HUD get dismissed.
- (HUDHelper * (^)(MBProgressHUDCompletionBlock))completion;

/// Main title text configuration.
- (HUDHelper * (^)(NSString *))title;

/// Main title font configuration.
- (HUDHelper * (^)(UIFont *))titleFont;

/// Main title foreground color configuration.
- (HUDHelper * (^)(UIColor *))titleColor;

/// Secondary title text configuration.
- (HUDHelper * (^)(NSString *))subtitle;

/// Secondary title font configuration.
- (HUDHelper * (^)(UIFont *))subtitleFont;

/// Secondary title foreground color configuration.
- (HUDHelper * (^)(UIColor *))subtitleColor;

/// Accept the user interaction or not for the whole HUD when displaying.
- (HUDHelper * (^)(BOOL))interactionEnabled;

/// Mode configuration from MBProgressHUD.
- (HUDHelper * (^)(MBProgressHUDMode))setMode;

/// Action button from MBProgressHUD configuration.
- (HUDHelper * (^)(void (^)(UIButton *)))actionButton;

/// Custom view from MBProgressHUD.
- (HUDHelper * (^)(UIView *))setCustomView;

/// HUD configuration for current instance.
- (HUDHelper * (^)(HUDHelperConfiguration))configuration;

/// Return the existing HUD which has the same context key defined before, otherwise,
/// bind the context info to current receiving instance.
///
/// HUDHelper won't retain the context key inside.
- (HUDHelper * (^)(HUDHelperContext))context;

@end


@interface HUDHelper (State)

/// Use animation or not when `show` and `hide`.
/// Defaults to YES.
- (HUDHelper *(^)(BOOL))animation;

/// Show specified time interval for toast instance only when calling `show` or `hide`.
///
/// For `show` method, it indicates the HUD's show duration, only used for toast.
/// For `hide` method, it indicates the HUD delay duration to hide, only used for indicator.
- (HUDHelper * (^)(NSTimeInterval))interval;

/// Show HUD immediately.
- (HUDHelper * (^)(void))show;

/// Hide HUD immediately.
- (HUDHelper * (^)(void))hide;

/// Hide all the indicator instances with animation.
+ (void (^)(BOOL))hideAll;

@end

NS_ASSUME_NONNULL_END
