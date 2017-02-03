//
//  AppDelegate.m
//  ChineseColor
//
//  Created by Amon on 16/4/17.
//  Copyright © 2016年 GodPlace. All rights reserved.
//

#import "AppDelegate.h"
#import "AppMacro.h"
#import "ViewController.h"

#import <SVProgressHUD/SVProgressHUD.h>

@interface AppDelegate ()

@end

NSString *appFontName;

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [self test];
    
    [self config];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    //  去掉返回按钮上的文字
    //    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
    //                                                         forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTintColor:UIColorFromRGB(0x39394a)];
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                           UIColorFromRGB(0x39394a), NSForegroundColorAttributeName,
                                                           SYSTEMFONT(15), NSFontAttributeName, nil]];
    
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    
    
    
    ViewController *vc = [[ViewController alloc] init];
    self.window.rootViewController = vc;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)config
{
    appFontName = @"Wyue-GutiFangsong-NC";
}

- (void)test
{
    for (NSString *str in [UIFont familyNames]) {
//        if ([str hasPrefix:@"Times"]) {
//            NSLog(@"####%@",str);
            for (NSString *substr in [UIFont fontNamesForFamilyName:str]) {
                NSLog(@"####%@",substr);
            }
//        }
        
    }
}


@end
