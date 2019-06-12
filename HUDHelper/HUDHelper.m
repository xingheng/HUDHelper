//
//  HUDHelper.m
//  DragonSourceCommon
//
//  Created by WeiHan on 1/29/16.
//  Copyright © 2016 DragonSource. All rights reserved.
//

#import "HUDHelper.h"

static NSMutableSet<HUDHelper *> *allHUDs;

static UIWindow *theWindow;
static HUDHelperConfigurationHandler hudConfigurationHandler;

static UIWindow * GetTheWindow(void);


@interface HUDHelper () <MBProgressHUDDelegate>

@property (nonatomic, assign) BOOL isIndicator;
@property (nonatomic, assign) BOOL displayAnimated;
@property (nonatomic, assign) NSTimeInterval delayInterval;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, assign) HUDHelperContextKey contextKey;

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

        if (hudConfigurationHandler) {
            hudConfigurationHandler(self);
        }
    }

    return self;
}

- (HUDHelper *(^)(void))show
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

- (HUDHelper *(^)(void))hide
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

- (HUDHelper *(^)(NSString *))subtitle
{
    return ^id (NSString *subtitle) {
               self.detailsLabel.text = subtitle;
               self.mode = self.isIndicator ? MBProgressHUDModeIndeterminate : MBProgressHUDModeText;
               return self;
    };
}

- (HUDHelper *(^)(UIFont *))subtitleFont
{
    return ^id (UIFont *subtitleFont) {
               self.detailsLabel.font = subtitleFont;
               return self;
    };
}

- (HUDHelper *(^)(UIColor *))subtitleColor
{
    return ^id (UIColor *subtitleColor) {
               self.detailsLabel.textColor = subtitleColor;
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

- (HUDHelper *(^)(HUDHelperButtonActionBlock))actionButton
{
    return ^id (HUDHelperButtonActionBlock block) {
               if (block) {
                   self.userInteractionEnabled = YES;
                   block(self.button);
                   block = nil;
               }

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

- (HUDHelper *(^)(HUDHelperContextKey))context
{
    return ^id (HUDHelperContextKey context) {
        self.contextKey = context;
        return self;
    };
}

- (HUDHelper *(^)(HUDHelperConfigurationBlock))customConfiguration
{
    return ^id (HUDHelperConfigurationBlock configBlock) {
               if (configBlock) {
                   configBlock(self);
                   configBlock = nil;
               }

               return self;
    };
}

#pragma mark - Override

- (void)removeFromSuperview
{
    [allHUDs removeObject:self];
    [super removeFromSuperview];
}

#pragma mark - MBProgressHUDDelegate

- (void)hudWasHidden:(MBProgressHUD *)hud
{
    [allHUDs removeObject:(HUDHelper *)hud];
}

@end


#pragma mark - Helper Functions

void SetupHUDHelperConfiguration(HUDHelperConfigurationHandler handler, UIWindow *containerWindow)
{
    hudConfigurationHandler = handler;
    theWindow = containerWindow;
}

static UIWindow * GetTheWindow(void)
{
    return theWindow ? : [UIApplication sharedApplication].keyWindow;
}

HUDHelper * HUDToast(UIView *view)
{
    HUDHelper *hud = [[HUDHelper alloc] initWithView:view];

    hud.containerView = view;
    return hud;
}

HUDHelper * HUDToastInWindow()
{
    return HUDToast(GetTheWindow());
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
    return HUDIndicator(GetTheWindow());
}

static void HUDHideWhen(BOOL animated, BOOL (^condition)(HUDHelper *hud))
{
    NSSet *set = [allHUDs copy];

    for (HUDHelper *hud in set) {
        if (condition(hud)) {
            hud.animation(animated).hide();
        }
    }
}

void HUDHideAnimated(UIView *view, BOOL animated)
{
    HUDHideWhen(animated, ^BOOL (HUDHelper *hud) {
        return [hud.superview isEqual:view];
    });
}

void HUDHide(UIView *view)
{
    HUDHideAnimated(view, YES);
}

void HUDHideInWindowAnimated(BOOL animated)
{
    HUDHideAnimated(GetTheWindow(), animated);
}

void HUDHideInWindow()
{
    HUDHideInWindowAnimated(YES);
}

void HUDHideAllToasts(BOOL animated)
{
    HUDHideWhen(animated, ^BOOL (HUDHelper *hud) {
        return !hud.isIndicator;
    });
}

void HUDHideAllIndicators(BOOL animated)
{
    HUDHideWhen(animated, ^BOOL (HUDHelper *hud) {
        return hud.isIndicator;
    });
}

void HUDHideAll(BOOL animated)
{
    HUDHideWhen(animated, ^BOOL (HUDHelper *hud) {
        return YES;
    });
}
