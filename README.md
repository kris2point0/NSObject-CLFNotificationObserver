NSObject-CLFNotificationObserver
================================

A category on NSObject for creating NSNotification observers that handle the weakSelf/strongSelf dance for you.

I will provide instructions for use and an example project tomorrow. Right now I need to get to bed :)


Example Usage:
```objective-c
@interface CLFViewController ()
{
    id _applicationWillEnterForegroundObserver;
}

@end



@implementation CLFViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self clf_getNotificationObserver:&_applicationWillEnterForegroundObserver
                              forName:UIApplicationWillEnterForegroundNotification
                  mainQueueUsingBlock:^(NSNotification *note, __typeof(self) strongSelf)
    {
        strongSelf.view.backgroundColor = [strongSelf randomBackgroundColor];
    }];
}


- (void)dealloc
{
    [self clf_releaseNotificationObserver:&_applicationWillEnterForegroundObserver];
}


- (UIColor *)randomBackgroundColor
{
    NSArray *colorNames =
        @[ @"red", @"green", @"blue", @"cyan", @"yellow", @"magenta", @"orange", @"purple", @"brown" ];

    NSString *colorName = colorNames[arc4random() % colorNames.count];
    SEL colorSelector = NSSelectorFromString([colorName stringByAppendingString:@"Color"]);

    return [UIColor performSelector:colorSelector];
}

@end
```
