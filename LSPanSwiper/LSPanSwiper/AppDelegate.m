//
//  AppDelegate.m
//  LSPanSwiper
//
//  Created by liusong on 2018/2/23.
//  Copyright © 2018年 liusong. All rights reserved.
//

#import "AppDelegate.h"
#import "LSNavigationController.h"
#import "FirstViewController.h"
#import "SecondViewController.h"

@interface AppDelegate ()
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
#if 0
    FirstViewController *rootNavController = [[FirstViewController alloc] initWithNibName:NSStringFromClass([FirstViewController class]) bundle:nil];
    LSNavigationController *nav = [[LSNavigationController alloc] initWithRootViewController:rootNavController];
    self.window.rootViewController = nav;
#else
    self.window.rootViewController =  [self customTabbar];
    
#endif
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (UITabBarController *)customTabbar
{
    FirstViewController *vc1 = [[FirstViewController alloc] initWithNibName:NSStringFromClass([FirstViewController class]) bundle:nil];
    LSNavigationController *nav1 = [[LSNavigationController alloc] initWithRootViewController:vc1];
    
    SecondViewController *vc2 = [[SecondViewController alloc] initWithNibName:NSStringFromClass([SecondViewController class]) bundle:nil];
    LSNavigationController *nav2 = [[LSNavigationController alloc] initWithRootViewController:vc2];
    
    FirstViewController *vc3 = [[FirstViewController alloc] initWithNibName:NSStringFromClass([FirstViewController class]) bundle:nil];
    LSNavigationController *nav3 = [[LSNavigationController alloc] initWithRootViewController:vc3];
    
    
    UITabBarController *tabbarController = [[UITabBarController alloc] init];
    tabbarController.viewControllers = [NSArray arrayWithObjects:nav1,nav2,nav3, nil];
    NSArray *items = tabbarController.tabBar.items;
    for (int i = 0;i < items.count;i++) {
        UITabBarItem *item = items[i];
        item.title = [NSString stringWithFormat:@"第 %@ 个",@(i)];
    }
    
    return tabbarController;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
