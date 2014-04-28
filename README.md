NSObject+CLFNotificationObserver
================================

A category on NSObject for creating NSNotification observers that handle the weakSelf/strongSelf dance for you.

## Motivation
I wanted a better way of creating notification observers that use blocks, that didn't include as much typing, as much reading, or the requirement of always doing a weakSelf/strongSelf dance.

Before:
```objective-c

- (void)setupObserver
{
    __weak __typeof(self) weakSelf = self;

    self.observer = [[NSNotificationCenter defaultCenter] addObserverForName:CLFSomethingHappenedNotification
                                                                      object:nil
                                                                       queue:[NSOperationQueue mainQueue]
                                                                  usingBlock:^(NSNotification *note) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;

        [strongSelf doSomething];
        [strongSelf doSomethingElse];
    }];
}


- (void)tearDownObserver
{
    [[NSNotificationCenter defaultCenter] removeObserver:self.observer];
    self.observer = nil;
} 

```

After:
```objective-c
- (void)setupObserver
{
    [self clf_getNotificationObserver:&_observer
                              forName:CLFSomethingHappenedNotification
                  mainQueueUsingBlock:^(NSNotification *note, __typeof(self) strongSelf)
    {
        [strongSelf doSomething];
        [strongSelf doSomethingElse];
    }];
}


- (void)tearDownObserver
{
    [self clf_releaseNotificationObserver:&_observer];
}
```


## API
The following three methods can be used to get a notification observer from [NSNotificationCenter defaultCenter]. The first one allows you to set all of the same parameters you would set using addObserverForName:object:queue:usingBlock: except the block's signature is changed to include the strongSelf from the weakSelf/strongSelf dance. The second two are provided for convenience and set the queue parameter to [NSOperationQueue mainQueue].
```objective-c
- (void)clf_getNotificationObserver:(id __strong *)observer
                            forName:(NSString *)name
                             object:(id)object
                              queue:(NSOperationQueue *)queue
                         usingBlock:(void (^)(NSNotification *note, id strongSelf))block;


- (void)clf_getNotificationObserver:(id __strong *)observer
                            forName:(NSString *)name
                             object:(id)object
                mainQueueUsingBlock:(void (^)(NSNotification *note, id strongSelf))block;


- (void)clf_getNotificationObserver:(id __strong *)observer
                            forName:(NSString *)name
                mainQueueUsingBlock:(void (^)(NSNotification *note, id strongSelf))block;
```

When you're done listening for notifications, remove the observer using this method. It will remove the observer from [NSNotificationCenter defaultCenter] then set the observer variable to nil.
```objective-c
- (void)clf_releaseNotificationObserver:(id __strong *)observer;
```

## Example Usage
```objective-c
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
    // Get rid of our notification observer. Because the category handles the weakSelf/strongSelf dance for us we
    // don't have to worry about dealloc never being called due to a retain loop.

    [self clf_releaseNotificationObserver:&_applicationWillEnterForegroundObserver];

    // [NSNotificationCenter defaultCenter] has now removed the observer, and
    // _applicationWillEnterForegroundObserver is now nil.
}

@end
```

## Tips
When you call one of the getNotificationObserver methods, the block signature will start as ^(NSNotification *note, id strongSelf). At that point you can optionally edit the strongSelf's type to __typeof(self) to help with autocompletion and the use of dot syntax inside of the block. It's not necessary by any means to do so, but I personally prefer that the compiler knows what type strongSelf will be, so I always change it.

You may even want to create a snippet for each of the methods that has strongSelf's type already changed, which makes it so you don't ever have to think about it again.


## License Info
Released under an MIT License.

Copyright (c) 2014 Chris Flesner

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

