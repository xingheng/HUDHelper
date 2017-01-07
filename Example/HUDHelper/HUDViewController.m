//
//  HUDViewController.m
//  HUDHelper
//
//  Created by Wei Han on 12/13/2016.
//  Copyright (c) 2016 Wei Han. All rights reserved.
//

#import "HUDViewController.h"

void CustomHUDConfigurationHandler(MBProgressHUD *hud)
{
    hud.bezelView.color = [[UIColor grayColor] colorWithAlphaComponent:0.8];
    hud.backgroundView.color = [[UIColor grayColor] colorWithAlphaComponent:0.2];

    hud.contentColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];

    hud.label.font = [UIFont boldSystemFontOfSize:14];
    hud.detailsLabel.font = [[UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline] fontWithSize:11];
}

@interface HUDViewController ()

@end

@implementation HUDViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"HUDHelper Demo";
    self.view.backgroundColor = [UIColor whiteColor];

    [self _buildSubview:self.view];

    SetupHUDHelperConfiguration(CustomHUDConfigurationHandler);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action

- (void)hudActionButtonTapped:(id)sender
{
    HUDHide(self.view);
}

- (void)btnToastTapped:(id)sender
{
    NSTimeInterval delay = 3;
    NSString *strSubTitle = [NSString stringWithFormat:@"The toast will dismiss automatically after %.0f second(s).", delay];

    HUDToast(self.view).title(@"Got response successfully!").subTitle(strSubTitle).delay(delay).show();
}

- (void)btnIndicatorTapped:(id)sender
{
    HUDIndicator(self.view).title(@"Processing").subTitle(@"The indicator won't dismiss automatically, you should hide it manually. (At this time, it will dismiss when the dummy network request finished.)").show().actionButton(^ (UIButton *button) {
        [button setTitle:@"Dismiss" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(hudActionButtonTapped:) forControlEvents:UIControlEventAllEvents];
    });

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        sleep(10); // To simulate the (netowrk) processing.

        dispatch_async(dispatch_get_main_queue(), ^{
            HUDHide(self.view);
        });
    });
}

#pragma mark - Private

- (void)_buildSubview:(UIView *)containerView
{
    UIButton *btnToast = [UIButton buttonWithType:UIButtonTypeSystem];

    [btnToast setTitle:@"Show Toast" forState:UIControlStateNormal];
    [btnToast addTarget:self action:@selector(btnToastTapped:) forControlEvents:UIControlEventTouchUpInside];

    UIButton *btnIndicator = [UIButton buttonWithType:UIButtonTypeSystem];
    [btnIndicator setTitle:@"Show Indicator" forState:UIControlStateNormal];
    [btnIndicator addTarget:self action:@selector(btnIndicatorTapped:) forControlEvents:UIControlEventTouchUpInside];

    [containerView addSubview:btnToast];
    [containerView addSubview:btnIndicator];

    [btnToast mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(containerView.centerX);
        make.centerY.equalTo(containerView.centerY).multipliedBy(2.0 / 3.0);
    }];

    [btnIndicator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(containerView.centerX);
        make.centerY.equalTo(containerView.centerY).multipliedBy(3.0 / 2.0);
    }];
}

@end
