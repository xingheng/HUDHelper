# HUDHelper

[![CI Status](http://img.shields.io/travis/xingheng/HUDHelper.svg?style=flat)](https://travis-ci.org/xingheng/HUDHelper)
[![Version](https://img.shields.io/cocoapods/v/HUDHelper.svg?style=flat)](http://cocoapods.org/pods/HUDHelper)
[![License](https://img.shields.io/cocoapods/l/HUDHelper.svg?style=flat)](http://cocoapods.org/pods/HUDHelper)
[![Platform](https://img.shields.io/cocoapods/p/HUDHelper.svg?style=flat)](http://cocoapods.org/pods/HUDHelper)



HUDHelper defines `Indicator` and `Toast` based on [MBProgressHUD](https://github.com/jdg/MBProgressHUD), the indicator acts as the default behaviour of MBProgressHUD, it won’t hide until calling `hide` method explicitly, but the toast will hide automatically, that is, `indicator` is designed for progress to wait, `toast` is designed for showing tips.



## Usage

#### Toast

Show a simple toast:

```objective-c
HUDHelper.toast(self.view).title(@"Got response successfully!").show();
```

with subtitles:

```objective-c
HUDHelper.toast(self.view).title(@"Got response successfully!").subtitle(@"There are some additional info you should know...").show();
```

By default, its show time depends on the *main title* and *secondary title*’s length, distinguished by different languages’ and common users’ reading speed, you could configure it in the `HUDHelperPreferences`, or specify the constant interval for a single HUD:

```objective-c
HUDHelper.toast(self.view).title(@"...").interval(3).show();
```

Changing the main title or secondary title’s features may be a independent for some cases, so you could change configure their font and foreground color:

```objective-c
HUDHelper.toast(self.view).title(@"...").titleFont([UIFont boldSystemFontOfSize:20]).titleColor(UIColor.blueColor).show();
```

Or uniform the default HUDs’ feature in a global place without inheriting:

```objective-c
// Make sure it executed before initializing all the HUDs.
HUDHelper.preferences.configuration = ^(HUDHelper *_Nonnull hud) {
    // ...
};
```

Not only for the common `UIView`, there are also a default global `UIWindow` retained in `HUDHelperPreferences` class, its default value is the current application’s `keyWindow`, you could attach the HUD there:

```objective-c
HUDHelper.toastInWindow().title(@"...").show();
```

By default, the HUD won’t block the user interactions below the HUD views, but if you want:

```objective-c
HUDHelper.toastInWindow().title(@"...").interactionEnabled(YES).show();
```

We don’t suppress the original functional from `MBProgressHUD`, actually, the main class `HUDHelper` is a subclass of `MBProgressHUD`, you could custom any native features including `mode`, `progress`, `customView`, etc.

#### Indicator

Show a simple indicator:

```objective-c
HUDHelper.indicator(self.view).title(@"Processing...").show();
```

Of course, `subtitle`, `titleFont`, `titleColor`, `actionButton` are available for indicators, too. The key differences is `hide`:

If the `hud` instance is available in both showing and hiding situations:

```objective-c
HUDHelper *hud = HUDHelper.indicatorInWindow().title(@"...").show();
// some asyn operations or related...
hud.hide();
```

This is the most direct solution to hide it, if the state changes happen in different method or class, you could get the showing one by:

```objective-c
HUDHelper.lastest(nil).hide();
// Passing the containing view if you know it:
HUDHelper.lastest(self.view).hide();
```

Or if want to hide all the HUDs directly:

```objective-c
HUDHelper.hideAll(YES);
```



## Example

To run the example project, clone the repo, and run `pod install` from the Example directory and run the only app scheme, or you could check out more code examples from [here](https://github.com/xingheng/HUDHelper/blob/master/Example/HUDHelper/HUDViewController.m).



## Installation

HUDHelper is available through [CocoaPods](http://cocoapods.org). To install it, simply add the following line to your Podfile:

```ruby
pod "HUDHelper"
```



## Author

[Will Han](mailto://xingheng.hax@qq.com)



## License

HUDHelper is available under the MIT license. See the LICENSE file for more info.
