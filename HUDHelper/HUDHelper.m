//
//  HUDHelper.m
//  DragonSourceCommon
//
//  Created by WeiHan on 1/29/16.
//  Copyright © 2016 DragonSource. All rights reserved.
//

#import "HUDHelper.h"

#define kROOTVIEW_WINDOW [UIApplication sharedApplication].delegate.window.rootViewController.view

static NSMutableSet<HUDHelper *> *allHUDs;


@interface HUDHelper () <MBProgressHUDDelegate>

@property (nonatomic, assign) BOOL isIndicator;
@property (nonatomic, assign) BOOL displayAnimated;
@property (nonatomic, assign) NSTimeInterval delayInterval;
@property (nonatomic, strong) UIView *containerView;

@end

@implementation HUDHelper

+ (void)initialize
{
    if (!allHUDs) {
        allHUDs = [NSMutableSet new];
    }
}

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
               [self showAnimated:self.displayAnimated];

               [allHUDs addObject:self];

               if (!self.isIndicator) {
                   NSTimeInterval delay = self.delayInterval;

                   if (delay <= 0) {
                       delay = (self.label.text.length + self.detailsLabel.text.length) * 0.2f;
                   }

                   [self hideAnimated:self.displayAnimated afterDelay:delay];
               }

               return self;
    };
}

- (HUDHelper *(^)())hide
{
    return ^id () {
               [self hideAnimated:self.displayAnimated];
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
               self.label.text = title;
               self.mode = self.isIndicator ? MBProgressHUDModeIndeterminate : MBProgressHUDModeText;
               return self;
    };
}

- (HUDHelper *(^)(UIFont *))titleFont
{
    return ^id (UIFont *titleFont) {
               self.label.font = titleFont;
               return self;
    };
}

- (HUDHelper *(^)(UIColor *))titleColor
{
    return ^id (UIColor *titleColor) {
               self.label.textColor = titleColor;
               return self;
    };
}

- (HUDHelper *(^)(NSString *))subTitle
{
    return ^id (NSString *subTitle) {
               self.detailsLabel.text = subTitle;
               self.mode = self.isIndicator ? MBProgressHUDModeIndeterminate : MBProgressHUDModeText;
               return self;
    };
}

- (HUDHelper *(^)(UIFont *))subTitleFont
{
    return ^id (UIFont *subTitleFont) {
               self.detailsLabel.font = subTitleFont;
               return self;
    };
}

- (HUDHelper *(^)(UIColor *))subTitleColor
{
    return ^id (UIColor *subTitleColor) {
               self.detailsLabel.textColor = subTitleColor;
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
               self.mode = MBProgressHUDModeCustomView;
               self.customView = customView;
               return self;
    };
}

#pragma mark - MBProgressHUDDelegate

- (void)hudWasHidden:(MBProgressHUD *)hud
{
    [allHUDs removeObject:(HUDHelper *)hud];
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
    for (HUDHelper *hud in allHUDs) {
        if ([hud.superview isEqual:view]) {
            hud.animation(animated).hide();
        }
    }
}

void HUDHide(UIView *view)
{
    HUDHideAnimated(view, YES);
}

void HUDHideInWindowAnimated(BOOL animated)
{
    HUDHideAnimated(kROOTVIEW_WINDOW, animated);
}

void HUDHideInWindow()
{
    HUDHideInWindowAnimated(YES);
}

void HUDHideAll(BOOL animated)
{
    for (HUDHelper *hud in allHUDs) {
        hud.animation(animated).hide();
    }
}
