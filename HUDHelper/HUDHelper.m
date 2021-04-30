//
//  HUDHelper.m
//
//  Created by WeiHan on 1/29/16.
//  Copyright © 2016-2021 Wei Han. All rights reserved.
//

#import <objc/runtime.h>
#import "HUDHelper.h"

static NSMutableArray<HUDHelper *> *allHUDs;
static HUDHelperPreferences *currentPreferences;

#pragma mark - HUDHelperPreferences

@implementation HUDHelperPreferences

@end

#pragma mark -

@interface UIView (HUDHelper)

@property (nonatomic, strong, readonly) NSMutableSet<HUDHelper *> *HUDs;

@end

@implementation UIView (HUDHelper)

- (NSMutableSet<HUDHelper *> *)HUDs
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)addHUDInstance:(HUDHelper *)hud
{
    NSMutableSet *set = self.HUDs;

    if (!set) {
        set = [NSMutableSet set];
        objc_setAssociatedObject(self, _cmd, set, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }

    [set addObject:hud];
}

@end

#pragma mark - HUDHelper

@interface HUDHelper () <MBProgressHUDDelegate>

@property (nonatomic, weak) UIView *m_containerView;
@property (nonatomic, weak) HUDHelperContext m_context;

@property (nonatomic, assign) BOOL m_isIndicator;
@property (nonatomic, assign) BOOL m_animation;
@property (nonatomic, assign) NSTimeInterval m_interval;

@property (nonatomic, strong, readonly, class) HUDHelper *reservedHUD;

@end

@implementation HUDHelper

+ (void)initialize
{
    if (!allHUDs) {
        allHUDs = [NSMutableArray new];
    }
}

- (instancetype)initWithView:(UIView *)view
{
    if (self = [super initWithView:view]) {
        self.userInteractionEnabled = NO;
        self.removeFromSuperViewOnHide = YES;
        self.m_animation = YES;
        self.m_containerView = view;

        if (self.class.preferences.configuration) {
            self.class.preferences.configuration(self);
        }
    }

    return self;
}

#pragma mark - Property

- (void)setm_containerView:(UIView *)m_containerView
{
    _m_containerView = m_containerView;

    [m_containerView.HUDs addObject:self];
}

- (HUDHelperContext)contextInfo
{
    return self.m_context;
}

+ (HUDHelper *)reservedHUD
{
    return [HUDHelper new];
}

#pragma mark - Override

- (void)removeFromSuperview
{
    [allHUDs removeObject:self];
    [super removeFromSuperview];
}

#pragma mark - Private

+ (HUDHelper *)_HUDInView:(UIView *)view match:(BOOL (^)(HUDHelper *))block
{
    for (HUDHelper *hud in view.HUDs) {
        if (![hud isKindOfClass:self]) {
            continue;
        }

        if (block) {
            if (block(hud)) {
                return hud;
            }
        }

        return hud;
    }

    return nil;
}

#pragma mark - MBProgressHUDDelegate

- (void)hudWasHidden:(MBProgressHUD *)hud
{
    [allHUDs removeObject:(HUDHelper *)hud];
}

@end


#pragma mark - HUDHelper (Initializer)

@implementation HUDHelper (Initializer)

+ (HUDHelperPreferences *)preferences
{
    if (!currentPreferences) {
        currentPreferences = [HUDHelperPreferences new];
        currentPreferences.window = UIApplication.sharedApplication.keyWindow;
        currentPreferences.readingRate = 0.05;
        currentPreferences.allowMultipleHUDsInSameView = YES;
    }

    return currentPreferences;
}

+ (void)setPreferences:(HUDHelperPreferences *)preferences
{
    currentPreferences = preferences;
}

+ (HUDHelper * (^)(UIView *))toast
{
    return ^id (UIView *view) {
        if (!self.preferences.allowMultipleHUDsInSameView) {
            HUDHelper *hud = [self _HUDInView:view match:^BOOL(HUDHelper *hud) {
                return !hud.m_isIndicator;
            }];

            if (hud) {
                return hud;
            }
        }

        return [[self alloc] initWithView:view];
    };
}

+ (HUDHelper * (^)(void))toastInWindow
{
    return ^id {
        return self.toast(self.preferences.window);
    };
}

+ (HUDHelper * (^)(UIView *))indicator
{
    return ^id (UIView *view) {
        if (!self.preferences.allowMultipleHUDsInSameView) {
            HUDHelper *hud = [self _HUDInView:view match:^BOOL(HUDHelper *hud) {
                return hud.m_isIndicator;
            }];

            if (hud) {
                return hud;
            }
        }

        HUDHelper *hud = [[self alloc] initWithView:view];

        hud.m_isIndicator = YES;
        return hud;
    };
}

+ (HUDHelper * (^)(void))indicatorInWindow
{
    return ^id {
        return self.indicator(self.preferences.window);
    };
}

+ (HUDHelper * (^)(UIView *))lastest
{
    return ^id (UIView *view) {
        HUDHelper *hud = [self _HUDInView:view match:nil];
        return hud ? : allHUDs.lastObject ? : self.reservedHUD;
    };
}

@end

#pragma mark - HUDHelper (Configuration)

@implementation HUDHelper (Configuration)

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
        self.mode = self.m_isIndicator ? MBProgressHUDModeIndeterminate : MBProgressHUDModeText;
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
        self.mode = self.m_isIndicator ? MBProgressHUDModeIndeterminate : MBProgressHUDModeText;
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

- (HUDHelper *(^)(void (^)(UIButton *)))actionButton
{
    return ^id (void (^ block)(UIButton *)) {
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

- (HUDHelper *(^)(HUDHelperConfiguration))configuration
{
    return ^id (HUDHelperConfiguration configBlock) {
        if (configBlock) {
           configBlock(self);
        }

        return self;
    };
}

- (HUDHelper *(^)(HUDHelperContext))context
{
    return ^id (HUDHelperContext context) {
        if (context) {
            for (HUDHelper *hud in allHUDs) {
                if ([hud.contextInfo isEqual:context]) {
                    return hud;
                }
            }
        }

        self.m_context = context;
        return self;
    };
}

@end

#pragma mark - HUDHelper (State)

@implementation HUDHelper (State)

- (HUDHelper *(^)(BOOL))animation
{
    return ^id (BOOL animation) {
        self.m_animation = animation;
        return self;
    };
}

- (HUDHelper *(^)(NSTimeInterval))interval
{
    return ^id (NSTimeInterval interval) {
        self.m_interval = interval;
        return self;
    };
}

- (HUDHelper *(^)(void))show
{
    return ^id () {
        [self.m_containerView addSubview:self];
        [self showAnimated:self.m_animation];

        [allHUDs addObject:self];

        if (!self.m_isIndicator) {
            NSTimeInterval interval = self.m_interval;
            CGFloat rate = self.class.preferences.readingRate;

            if (interval <= 0 && rate > 0) {
                interval = (self.label.text.length + self.detailsLabel.text.length) * rate;
            }

            [self hideAnimated:self.m_animation afterDelay:interval];
            self.m_interval = 0; // Reset it because the interval is valid one time only by design.
        }
        return self;
    };
}

- (HUDHelper *(^)(void))hide
{
    return ^id () {
        if (self.m_isIndicator && self.m_interval > 0) {
            [self hideAnimated:self.m_animation afterDelay:self.m_interval];
            self.m_interval = 0;
        } else {
            [self hideAnimated:self.m_animation];
        }

        return self;
    };
}

+ (void (^)(BOOL))hideAll
{
    return ^(BOOL animated) {
        [allHUDs makeObjectsPerformSelector:@selector(hideAnimated:) withObject:@(animated)];
    };
}

@end
