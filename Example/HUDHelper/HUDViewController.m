//
//  HUDViewController.m
//  HUDHelper
//
//  Created by Wei Han on 12/13/2016.
//  Copyright (c) 2016 Wei Han. All rights reserved.
//

#import "HUDViewController.h"

@interface ExampleCase : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *descriptions;
@property (nonatomic, copy) void (^ block)(void);

@property (nonatomic, strong, readonly) NSAttributedString *attributeString;

@end

@implementation ExampleCase

+ (instancetype)caseTitle:(NSString *)title descriptions:(NSString *)descriptions block:(void (^)(void))block
{
    ExampleCase *item = [ExampleCase new];

    item.title = title;
    item.descriptions = descriptions;
    item.block = block;

    return item;
}

- (NSAttributedString *)attributeString
{
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:self.title attributes:@{
        NSFontAttributeName: [UIFont boldSystemFontOfSize:18],
        NSForegroundColorAttributeName: UIColor.blackColor,
    }];

    [attr appendAttributedString:[[NSAttributedString alloc] initWithString:[@"\n" stringByAppendingString:self.descriptions] attributes:@{
        NSFontAttributeName: [UIFont systemFontOfSize:16],
        NSForegroundColorAttributeName: UIColor.darkGrayColor,
    }]];

    [attr addAttributes:@{
        NSParagraphStyleAttributeName: ({
            NSMutableParagraphStyle *style = [NSMutableParagraphStyle new];

            style.lineSpacing = 4;
            style.paragraphSpacing = 6;
            style;
        })
    }
                  range:NSMakeRange(0, attr.length)];

    return attr;
}

@end


@interface HUDViewController ()

@property (nonatomic, strong) NSArray<ExampleCase *> *allCases;
@property (nonatomic, strong, readonly) NSArray<UIAction *> *allActions;
@property (nonatomic, strong, readonly) NSAttributedString *caseDescriptions;
@property (nonatomic, strong) UITextView *textview;

@end

@implementation HUDViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"HUDHelper Demo";
    self.view.backgroundColor = [UIColor whiteColor];

    UIBarButtonItem *leftBarbuttonItem = [[UIBarButtonItem alloc] initWithTitle:@"Examples" style:UIBarButtonItemStylePlain target:nil action:nil];
    UIMenu *menu = [UIMenu menuWithChildren:self.allActions];

    leftBarbuttonItem.primaryAction = nil;
    leftBarbuttonItem.menu = menu;

    self.navigationItem.leftBarButtonItem = leftBarbuttonItem;

    UIBarButtonItem *rightBarbuttonItem = [[UIBarButtonItem alloc] initWithTitle:@"Hide" style:UIBarButtonItemStylePlain target:self action:@selector(hudActionButtonTapped:)];

    self.navigationItem.rightBarButtonItem = rightBarbuttonItem;

    UITextView *textview = [UITextView new];

    textview.editable = NO;
    textview.font = [UIFont boldSystemFontOfSize:20];
    textview.attributedText = self.caseDescriptions;
    self.textview = textview;
    [self.view addSubview:textview];

    [textview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).inset(10);
    }];

    // Configure the common features for all HUDs.
    HUDHelper.preferences.configuration = ^(HUDHelper *_Nonnull hud) {
        hud.bezelView.color = [UIColor.grayColor colorWithAlphaComponent:0.8];
        hud.backgroundView.color = [UIColor.grayColor colorWithAlphaComponent:0.2];

        hud.contentColor = [UIColor.blackColor colorWithAlphaComponent:0.8];

        hud.label.font = [UIFont boldSystemFontOfSize:14];
        hud.detailsLabel.font = [[UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline] fontWithSize:11];

        if ([hud.context isEqual:self.view]) {
            // Add special configurations for specific HUD.
        }
    };
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action

- (void)hudActionButtonTapped:(id)sender
{
#if 1
    HUDHelper.lastest(nil).hide();
#else
    HUDHelper.hideAll(YES);
#endif

    self.textview.attributedText = self.caseDescriptions;
}

#pragma mark - Private

- (NSArray<ExampleCase *> *)allCases
{
    if (_allCases) {
        return _allCases;
    }

    NSString *strTitle = @"Got response successfully!";
    NSString *strSubtitle = @"There are some additional info you should know.\n\n1. code=1xx means...\n2. code=2xx means...\n3. code=3xx means...\n...";

#define TITLE(_t_)      [NSString stringWithFormat:@"%@ - Line %d", _t_, __LINE__]
#define TOAST_TITLE     TITLE(@"Toast")
#define INDICATOR_TITLE TITLE(@"Indicator")

    _allCases = @[
        // ------------------------------- Toast -------------------------------
        [ExampleCase caseTitle:TOAST_TITLE
                  descriptions:@"A simple toast"
                         block:^{
            HUDHelper.toast(self.view).title(strTitle).show();
        }],
        [ExampleCase caseTitle:TOAST_TITLE
                  descriptions:@"A toast with subtitles"
                         block:^{
            HUDHelper.toast(self.view).title(strTitle).subtitle(strSubtitle).show();
        }],
        [ExampleCase caseTitle:TOAST_TITLE
                  descriptions:@"A toast with specified time interval"
                         block:^{
            HUDHelper.toast(self.view).title(strTitle).interval(3).show();
        }],
        [ExampleCase caseTitle:TOAST_TITLE
                  descriptions:@"A toast with custom font and foreground color"
                         block:^{
            HUDHelper.toast(self.view).title(strTitle).titleFont([UIFont boldSystemFontOfSize:20]).titleColor(UIColor.blueColor).show();
        }],
        [ExampleCase caseTitle:TOAST_TITLE
                  descriptions:@"A toast with custom font and foreground color for both main title and secondary title"
                         block:^{
            HUDHelper.toast(self.view).title(strTitle).titleFont([UIFont boldSystemFontOfSize:20]).titleColor(UIColor.blueColor).subtitle(strSubtitle).subtitleFont([UIFont systemFontOfSize:15]).subtitleColor(UIColor.grayColor).show();
        }],
        [ExampleCase caseTitle:TOAST_TITLE
                  descriptions:@"A toast in the preconfigurd window."
                         block:^{
            HUDHelper.toastInWindow().title(strTitle).show();
        }],
        [ExampleCase caseTitle:TOAST_TITLE
                  descriptions:@"A toast could also block the current attaching view's interactions."
                         block:^{
            HUDHelper.toastInWindow().title(strTitle).interactionEnabled(YES).show();
        }],
        [ExampleCase caseTitle:TOAST_TITLE
                  descriptions:@"A toast could also reuse the mode options from MBProgressHUD."
                         block:^{
            HUDHelper *hud = HUDHelper.toastInWindow().title(strTitle).setMode(MBProgressHUDModeAnnularDeterminate).interval(5).show();

            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                for (NSUInteger i = 0; i < 100; i++) {
                    [NSThread sleepForTimeInterval:0.05];
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        hud.progress += 0.01;
                    });
                }
            });
        }],
        [ExampleCase caseTitle:TOAST_TITLE
                  descriptions:@"A toast could also have a custom view."
                         block:^{
            UIImageView *imageView = [UIImageView new];
            imageView.image = [UIImage systemImageNamed:@"heart.circle"];
            HUDHelper.toastInWindow().title(strTitle).setCustomView(imageView).interval(3).show();
        }],
        [ExampleCase caseTitle:TOAST_TITLE
                  descriptions:@"A toast could also have its own one-time configuration."
                         block:^{
            HUDHelper.toastInWindow().title(strTitle).configuration(^(HUDHelper *hud) {
                hud.bezelView.color = [UIColor.blackColor colorWithAlphaComponent:0.5];
                hud.backgroundView.color = [UIColor.blackColor colorWithAlphaComponent:0.5];
                hud.contentColor = [UIColor.redColor colorWithAlphaComponent:0.8];
            }).show();
        }],
        [ExampleCase caseTitle:TOAST_TITLE
                  descriptions:@"A toast could also have a custom view."
                         block:^{
            HUDHelper.toastInWindow().title(strTitle).context(self).interval(10).show();
        }],
        [ExampleCase caseTitle:TOAST_TITLE
                  descriptions:@"A toast could also bind with a context key which is accessable in the preferences' global configuration."
                         block:^{
            HUDHelper.toastInWindow().title(strTitle).context(self).show();
        }],

        // ----------------------------- Indicator -----------------------------

        [ExampleCase caseTitle:INDICATOR_TITLE
                  descriptions:@"A simple indicator which won't dismiss automatically."
                         block:^{
            HUDHelper.indicator(self.view).title(strTitle).show();
        }],
        [ExampleCase caseTitle:INDICATOR_TITLE
                  descriptions:@"An indicator with subtitles, of course."
                         block:^{
            HUDHelper.indicator(self.view).title(strTitle).subtitle(strSubtitle).show();
        }],
        [ExampleCase caseTitle:INDICATOR_TITLE
                  descriptions:@"An indicator with the same features with toast."
                         block:^{
            HUDHelper.indicatorInWindow().title(strTitle).titleFont([UIFont boldSystemFontOfSize:20]).titleColor(UIColor.blueColor).subtitle(strSubtitle).subtitleFont([UIFont systemFontOfSize:15]).subtitleColor(UIColor.grayColor).show();
        }],
        [ExampleCase caseTitle:INDICATOR_TITLE
                  descriptions:@"An indicator with custom action button."
                         block:^{
            HUDHelper.indicatorInWindow().title(strTitle).subtitle(strSubtitle).actionButton(^(UIButton *button) {
                [button setTitle:@"Dismiss" forState:UIControlStateNormal];
                [button addEventBlock:^(id sender) {
                    HUDHelper.lastest(nil).hide();
                }
                     forControlEvents:UIControlEventTouchUpInside];
            }).show();
        }],
        [ExampleCase caseTitle:INDICATOR_TITLE
                  descriptions:@"An indicator with custom mode."
                         block:^{
            HUDHelper *hud = HUDHelper.indicatorInWindow().title(strTitle).interactionEnabled(YES).setMode(MBProgressHUDModeDeterminateHorizontalBar).show();

            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                for (NSUInteger i = 0; i < 100; i++) {
                    [NSThread sleepForTimeInterval:0.1];
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        hud.progress += 0.01;

                        if (hud.progress > 0.99999) {
                            hud.hide();
                        }
                    });
                }
            });
        }],
    ];

    return _allCases;
}

- (NSArray<UIAction *> *)allActions
{
    NSMutableArray<UIAction *> *actions = [NSMutableArray new];

    for (ExampleCase *item in self.allCases) {
        [actions addObject:[UIAction actionWithTitle:item.title image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
            self.textview.attributedText = item.attributeString;
            !item.block ? : item.block();
        }]];
    }

    return actions;
}

- (NSAttributedString *)caseDescriptions
{
    NSMutableAttributedString *string = [NSMutableAttributedString new];

    for (ExampleCase *item in self.allCases) {
        [string appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n\n" attributes:nil]];
        [string appendAttributedString:item.attributeString];
    }

    return string;
}

@end
