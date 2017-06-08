//
//  ShoppyTests.m
//  ShoppyTests
//
//  Created by Admin Dev on 6/6/17.
//  Copyright © 2017 Kinetic Bytes. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ViewController.h"

@interface ShoppyTests : XCTestCase

@end

@implementation ShoppyTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testLoadItems {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"collection_vc"];
    [vc view]; // Loads the view hierarchy
    [vc viewDidLoad];

    [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:5.0]];
    NSUInteger num = [vc collectionView:vc.collectionView numberOfItemsInSection:0];
    XCTAssert(num >= 48);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
