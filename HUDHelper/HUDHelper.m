//
//  HUDHelper.m
//  DragonSourceCommon
//
//  Created by WeiHan on 1/29/16.
//  Copyright © 2016 DragonSource. All rights reserved.
//

#import "HUDHelper.h"

#define kROOTVIEW_WINDOW [UIApplication sharedApplication].delegate.window.rootViewController.view

@interface HUDHelper ()

@property (nonatomic, assign) BOOL isIndicator;
@property (nonatomic, assign) BOOL displayAnimated;
@property (nonatomic, assign) NSTimeInterval delayInterval;
@property (nonatomic, strong) UIView *containerView;

@end

@implementation HUDHelper
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = NO;
        self.displayAnimated = YES;
    }

    return self;
}

- (HUDHelper *(^)())show
{
    return ^id () {
               self.removeFromSuperViewOnHide = YES;
               [self.containerView addSubview:self];
               [self show:self.displayAnimated];

               if (!self.isIndicator) {
                   NSTimeInterval delay = self.delayInterval;

                   if (delay <= 0) {
                       delay = (self.labelText.length + self.detailsLabelText.length) * 0.2f;
                   }

                   [self hide:self.displayAnimated afterDelay:delay];
               }

               return self;
    };
}

- (HUDHelper *(^)())hide
{
    return ^id () {
               [self hide:self.displayAnimated];
               return self;
    };
}

- (HUDHelper *(^)(BOOL))animation
{
    return ^id (BOOL animation) {
               self.displayAnimated = animation;
               return self;
    };
}

- (HUDHelper *(^)(NSTimeInterval))delay
{
    return ^id (NSTimeInterval interval) {
               self.delayInterval = interval;
               return self;
    };
}

- (HUDHelper *(^)(MBProgressHUDCompletionBlock))completion
{
    return ^id (MBProgressHUDCompletionBlock block) {
               self.completionBlock = block;
               return self;
    };
}

- (HUDHelper *(^)(NSString *))title
{
    return ^id (NSString *title) {
               self.labelText = title;
               self.mode = self.isIndicator ? MBProgressHUDModeIndeterminate : MBProgressHUDModeText;
               return self;
    };
}

- (HUDHelper *(^)(UIFont *))titleFont
{
    return ^id (UIFont *titleFont) {
               self.labelFont = titleFont;
               return self;
    };
}

- (HUDHelper *(^)(UIColor *))titleColor
{
    return ^id (UIColor *titleColor) {
               self.labelColor = titleColor;
               return self;
    };
}

- (HUDHelper *(^)(NSString *))subTitle
{
    return ^id (NSString *subTitle) {
               self.detailsLabelText = subTitle;
               self.mode = self.isIndicator ? MBProgressHUDModeIndeterminate : MBProgressHUDModeText;
               return self;
    };
}

- (HUDHelper *(^)(UIFont *))subTitleFont
{
    return ^id (UIFont *subTitleFont) {
               self.detailsLabelFont = subTitleFont;
               return self;
    };
}

- (HUDHelper *(^)(UIColor *))subTitleColor
{
    return ^id (UIColor *subTitleColor) {
               self.detailsLabelColor = subTitleColor;
               return self;
    };
}

- (HUDHelper *(^)(BOOL))interactionEnabled
{
    return ^id (BOOL enabled) {
               self.userInteractionEnabled = enabled;
               return self;
    };
}

- (HUDHelper *(^)(MBProgressHUDMode))setMode
{
    return ^id (MBProgressHUDMode mode) {
               self.mode = mode;
               return self;
    };
}

- (HUDHelper *(^)(UIView *))setCustomView
{
    return ^id (UIView *customView) {
               self.customView = customView;
               return self;
    };
}

#pragma mark - Indicator

+ (MBProgressHUD *)showIndicatorToView:(UIView *)view
{
    return [MBProgressHUD showHUDAddedTo:view animated:YES];
}

+ (MBProgressHUD *)showIndicatorToView:(UIView *)view text:(NSString *)text
{
    MBProgressHUD *hud = [self showIndicatorToView:view];

    hud.labelText = text;
    hud.mode = MBProgressHUDModeIndeterminate;
    return hud;
}

+ (MBProgressHUD *)showHUDIndicatorInWindow
{
    return [self showIndicatorToView:kROOTVIEW_WINDOW];
}

#pragma mark - HUD

+ (MBProgressHUD *)showHUDInView:(UIView *)view text:(NSString *)text
{
    return [self showHUDInView:view text:text delay:text.length * 0.2f];
}

+ (MBProgressHUD *)showHUDInView:(UIView *)view text:(NSString *)text delay:(NSTimeInterval)delay
{
    MBProgressHUD *hud = [self showIndicatorToView:view];

    hud.userInteractionEnabled = NO;
    hud.labelText = text;
    hud.mode = MBProgressHUDModeText;
    hud.margin = 15.f;
    [hud hide:YES afterDelay:delay];
    return hud;
}

+ (MBProgressHUD *)showHUDTextInWindow:(NSString *)text
{
    return [self showHUDInView:kROOTVIEW_WINDOW text:text];
}

+ (void)showHUDInView:(UIView *)view completedText:(NSString *)text
{
    MBProgressHUD *hud = [self showIndicatorToView:view];

    hud.userInteractionEnabled = NO;
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = text;
    [hud hide:YES afterDelay:1];
}

#pragma mark - hidden

+ (void)hideHUDInView:(UIView *)view completedText:(NSString *)text
{
    MBProgressHUD *hud = [MBProgressHUD HUDForView:view];

    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = text;
    [hud hide:YES afterDelay:1];
}

+ (void)hideHUDForView:(UIView *)view
{
    [MBProgressHUD hideAllHUDsForView:view animated:YES];
}

+ (void)hideHUDForWindow
{
    [MBProgressHUD hideAllHUDsForView:kROOTVIEW_WINDOW animated:YES];
}

@end


#pragma mark - Helper Functions

HUDHelper * HUDToast(UIView *view)
{
    HUDHelper *hud = [[HUDHelper alloc] initWithView:view];

    hud.containerView = view;
    return hud;
}

HUDHelper * HUDToastInWindow()
{
    return HUDToast(kROOTVIEW_WINDOW);
}

HUDHelper * HUDIndicator(UIView *view)
{
    HUDHelper *hud = [[HUDHelper alloc] initWithView:view];

    hud.isIndicator = YES;
    hud.containerView = view;
    return hud;
}

HUDHelper * HUDIndicatorInWindow()
{
    return HUDIndicator(kROOTVIEW_WINDOW);
}

void HUDHideAnimated(UIView *view, BOOL animated)
{
    [MBProgressHUD hideAllHUDsForView:view animated:animated];
}

void HUDHide(UIView *view)
{
    HUDHideAnimated(view, YES);
}

void HUDHideInWindowAnimated(BOOL animated)
{
    [MBProgressHUD hideAllHUDsForView:kROOTVIEW_WINDOW animated:animated];
}

void HUDHideInWindow()
{
    HUDHideInWindowAnimated(YES);
}
