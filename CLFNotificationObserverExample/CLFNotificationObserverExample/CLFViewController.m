//
//  CLFViewController.m
//  CLFNotificationObserverExample
//
//  Created by Chris Flesner on 4/28/14.
//  Copyright (c) 2014 Chris Flesner
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
//  documentation files (the "Software"), to deal in the Software without restriction, including without limitation the
//  rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to
//  permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of
//  the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO
//  THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
//  TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

#import "CLFViewController.h"
#import "NSObject+CLFNotificationObserver.h"



/******
 How to use this example project:

 Run the app in Xcode, and see that the background color of this view controller is white. Then return to the home screen,
 and re-open the app. The background color will change to a random color after UIApplicationWillEnterForegroundNotification
 is received.
 
 Repeat the process of returning to the home screen and re-opening the app as desired to see different random background 
 colors.
 
 ******/



@interface CLFViewController ()
{
    // Our observer for UIApplicationWillEnterForegroundNotification.
    // There's no need to make it a property because it will never be accessed via a setter or getter, so we'll
    // just make it an instance variable.

    id _applicationWillEnterForegroundObserver;
}

@end



@implementation CLFViewController

- (void)viewDidLoad
{
    [super viewDidLoad];


    // Get our notification observer from [NSNotificationCenter defaultCenter], and have its block run on the main queue.

    [self clf_getNotificationObserver:&_applicationWillEnterForegroundObserver
                              forName:UIApplicationWillEnterForegroundNotification
                  mainQueueUsingBlock:^(NSNotification *note, __typeof(self) strongSelf)
    {
        strongSelf.view.backgroundColor = [strongSelf randomBackgroundColor];
    }];


    // _applicationWillEnterForegroundObserver is now set.
}


- (void)dealloc
{
    // Get rid of our notification observer. Because the category handles the strongSelf/weakSelf dance for us we
    // don't have to worry about dealloc never being called due to a retain loop.

    [self clf_releaseNotificationObserver:&_applicationWillEnterForegroundObserver];

    // [NSNotificationCenter defaultCenter] has now removed the observer, and
    // _applicationWillEnterForegroundObserver is now nil.
}


// Called from the block that is run when our observer gets the UIApplicationWillEnterForegroundNotification

- (UIColor *)randomBackgroundColor
{
    NSArray *colorNames =
        @[ @"red", @"green", @"blue", @"cyan", @"yellow", @"magenta", @"orange", @"purple", @"brown" ];

    NSString *colorName = colorNames[arc4random_uniform(colorNames.count)];
    SEL colorSelector = NSSelectorFromString([colorName stringByAppendingString:@"Color"]);

    return [UIColor performSelector:colorSelector];
}

@end
