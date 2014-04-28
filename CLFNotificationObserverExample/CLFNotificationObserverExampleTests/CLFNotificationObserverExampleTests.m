//
//  CLFNotificationObserverExampleTests.m
//  CLFNotificationObserverExampleTests
//
//  Created by Chris Flesner on 4/28/14.
//  Copyright (c) 2014 Chris Flesner. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NSObject+CLFNotificationObserver.h"


@interface CLFNotificationObserverExampleTests : XCTestCase

@end



@implementation CLFNotificationObserverExampleTests

- (void)setUp
{
    [super setUp];
}


- (void)tearDown
{
    [super tearDown];
}


- (void)testObserving
{
    NSString * const testNotification = @"testNotification";
    id observer;

    __block NSInteger counter = 0;

    // Add observer
    [self clf_getNotificationObserver:&observer
                              forName:testNotification
                  mainQueueUsingBlock:^(NSNotification *note, __typeof(self) strongSelf)
    {
        counter++;
    }];

    XCTAssert(counter == 0, @"counter should still be 0");

    // Post notification
    [[NSNotificationCenter defaultCenter] postNotificationName:testNotification object:self];
    XCTAssert(counter == 1, @"counter should now be 1");

    // Post notification again
    [[NSNotificationCenter defaultCenter] postNotificationName:testNotification object:self];
    XCTAssert(counter == 2, @"counter should now be 2");

    // Remove observer
    [self clf_releaseNotificationObserver:&observer];

    // Post notification again
    [[NSNotificationCenter defaultCenter] postNotificationName:testNotification object:self];
    XCTAssert(counter == 2, @"counter should still be 2");
}


- (void)testObservingObject
{
    NSString * const testNotification = @"testNotification";
    id observer;

    NSObject *poster1 = [[NSObject alloc] init];
    NSObject *poster2 = [[NSObject alloc] init];

    __block NSInteger counter = 0;

    [self clf_getNotificationObserver:&observer
                              forName:testNotification
                               object:poster1
                  mainQueueUsingBlock:^(NSNotification *note, __typeof(self) strongSelf)
    {
        counter++;
    }];

    XCTAssert(counter == 0, @"counter should still be 0");

    // Post notification from poster1
    [[NSNotificationCenter defaultCenter] postNotificationName:testNotification object:poster1];
    XCTAssert(counter == 1, @"counter should now be 1");

    // Post notification from poster2
    [[NSNotificationCenter defaultCenter] postNotificationName:testNotification object:poster2];
    XCTAssert(counter == 1, @"counter should still be 1");

    [self clf_releaseNotificationObserver:&observer];
}

@end
