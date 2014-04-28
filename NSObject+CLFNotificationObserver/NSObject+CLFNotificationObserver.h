//
//  NSObject+CLFNotificationObserver.h
//  CLFLibrary
//
//  Created by Chris Flesner on 4/25/14.
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

#import <Foundation/Foundation.h>


@interface NSObject (CLFNotificationObserver)

// Adding Observers

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



// Removing Observers

- (void)clf_releaseNotificationObserver:(id __strong *)observer;

@end
