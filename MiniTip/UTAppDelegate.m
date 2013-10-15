//
//  UTAppDelegate.m
//  UltraTip
//
//  Created by IFAN CHU on 11/23/12.
//  Copyright (c) 2012 IFAN CHU. All rights reserved.
//

#import "UTAppDelegate.h"

#import "UTViewController.h"
#import "MTMainViewController.h"
#import "ICFormatHelper.h"
#import "Appirater.h"

@implementation UTAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    MTMainViewController *mainController = [[MTMainViewController alloc] initWithNibName:@"MTMainViewController" bundle:nil];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:mainController];
//    self.centerController = [[UTViewController alloc] initWithNibName:@"UTViewController" bundle:nil];
    self.window.rootViewController = navController;
    [self.window makeKeyAndVisible];
    // set window background imge, then set each view background to clear
    self.window.backgroundColor = [ICFormatHelper getBackgroundColor];
    [self.window setFrame:[[UIScreen mainScreen] bounds]];
    // Appirater settings
    [Appirater setAppId:APPLE_ID];
    [Appirater setDaysUntilPrompt:1];
    [Appirater setUsesUntilPrompt:10];
    [Appirater setSignificantEventsUntilPrompt:-1];
    [Appirater setTimeBeforeReminding:2];
    [Appirater appLaunched:YES];
    return YES;
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
    [Appirater appEnteredForeground:YES];
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
