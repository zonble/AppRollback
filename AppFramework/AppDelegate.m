//
//  AppDelegate.m
//  AppRollback
//
//  Created by zonble on 2/2/17.
//  Copyright © 2017 KKBOX Taiwan Co., Ltd. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"

@interface AppDelegate ()
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
	ViewController *vc = [[ViewController alloc] initWithStyle:UITableViewStylePlain];
	UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];
	self.window.rootViewController = nvc;
	[self.window makeKeyAndVisible];
	return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
}

- (void)applicationWillTerminate:(UIApplication *)application
{
}

@end
