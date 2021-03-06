//
//  BNRAppDelegate.m
//  Hypnosister
//
//  Created by manit on 13/1/2558.
//  Copyright (c) พ.ศ. 2558 golf. All rights reserved.
//

#import "BNRAppDelegate.h"
#import "BNRHypnosisView.h"

@interface BNRAppDelegate() <UIScrollViewDelegate>

@property (nonatomic , strong) BNRHypnosisView * hrv;

@end

@implementation BNRAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // Create CGRects for frames
    CGRect screenRect = self.window.bounds;
    CGRect bigRect = screenRect;
    bigRect.size.width *= 2.0;
    //bigRect.size.height *= 2.0;
    
    // Create a screen-sized scroll view and add it to the window
    UIScrollView * scrollView = [[UIScrollView alloc] initWithFrame:screenRect];
    
    scrollView.delegate = self;
    scrollView.pagingEnabled = NO;
    // Tell the scroll view how big its content area is
    scrollView.contentSize = bigRect.size;
    
    // scrollView's Maximun Zoom
    scrollView.maximumZoomScale = 2.5;
    
    // scrollView's minimum Zoom
    scrollView.minimumZoomScale = 0.5;
    
    [self.window addSubview:scrollView];
    
    
    // Create a screen-sized hypnosis view and add it to the scroll view
    self.hrv = [[BNRHypnosisView alloc] initWithFrame:screenRect];
    [scrollView addSubview:self.hrv];
    
    /// Add a second screen-sized hypnosis view just off screen to the right
    //screenRect.origin.x += screenRect.size.width;
    //BNRHypnosisView * anotherView = [[BNRHypnosisView alloc] initWithFrame:screenRect];
    //[scrollView addSubview:anotherView];
    
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

// Method that retunrs the view of the scrollView
-(UIView *)viewForZoomingInScrollView:(UIScrollView *) scrollView
{
    // Return a BNRHypnosisView
    NSLog(@"Zoom");
    return self.hrv;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
