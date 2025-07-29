//
//  Weather_ForecastUITestsLaunchTests.m
//  Weather ForecastUITests
//
//  Created by xiaoli pop on 2025/7/17.
//

#import <XCTest/XCTest.h>

@interface Weather_ForecastUITestsLaunchTests : XCTestCase

@end

@implementation Weather_ForecastUITestsLaunchTests

+ (BOOL)runsForEachTargetApplicationUIConfiguration {
    return YES;
}

- (void)setUp {
    self.continueAfterFailure = NO;
}

- (void)testLaunch {
    XCUIApplication *app = [[XCUIApplication alloc] init];
    [app launch];

    // Insert steps here to perform after app launch but before taking a screenshot,
    // such as logging into a test account or navigating somewhere in the app

    XCTAttachment *attachment = [XCTAttachment attachmentWithScreenshot:XCUIScreen.mainScreen.screenshot];
    attachment.name = @"Launch Screen";
    attachment.lifetime = XCTAttachmentLifetimeKeepAlways;
    [self addAttachment:attachment];
}

@end
