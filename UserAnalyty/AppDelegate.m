//
//  AppDelegate.m
//  UserAnalyty
//
//  Created by zhYch on 2018/9/17.
//  Copyright © 2018年 zhaoyongchuang. All rights reserved.
//

#import "AppDelegate.h"

#import <UMCommon/UMCommon.h>
#import <UMAnalytics/MobClick.h>
#import <UMCommonLog/UMCommonLogHeaders.h>
#import <UMAnalytics/MobClick.h>


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [UMCommonLogManager setUpUMCommonLogManager];
    [UMConfigure setLogEnabled:YES];//设置打开日志
    NSString *appkey = @"5b2c7f3e*******0e000027";
    [UMConfigure initWithAppkey:appkey channel:nil];
    [MobClick setScenarioType:E_UM_NORMAL|E_UM_DPLUS];
    
    [MobClick setCrashReportEnabled:YES];
    
    //此函数在UMCommon.framework版本1.4.2及以上版本，在UMConfigure.h的头文件中加入。
    //如果用户用组件化SDK,需要升级最新的UMCommon.framework版本。
    NSString* deviceID =  [UMConfigure deviceIDForIntegration];
    NSLog(@"集成测试的deviceID:%@",deviceID);
    
    
    
    
    return YES;
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
