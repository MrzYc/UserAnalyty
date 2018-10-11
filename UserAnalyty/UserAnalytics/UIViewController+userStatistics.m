//
//  UIViewController+userStatistics.m
//  UserAnalyty
//
//  Created by zhYch on 2018/9/17.
//  Copyright © 2018年 zhaoyongchuang. All rights reserved.
//

#import "UIViewController+userStatistics.h"
#import "ClassHook.h"
#import "UserStatistics.h"
#import <objc/runtime.h>


@implementation UIViewController (userStatistics)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL originalSelector = @selector(viewDidAppear:);
        SEL swizzledSelector = @selector(swiz_viewDidAppear:);
        [ClassHook swizzlingInClass:[self class] originalSelector:originalSelector swizzledSelector:swizzledSelector];
        
        SEL originalSelector2 = @selector(viewDidDisappear:);
        SEL swizzledSelector2 = @selector(swiz_viewDidDisappear:);
        [ClassHook swizzlingInClass:[self class] originalSelector:originalSelector2 swizzledSelector:swizzledSelector2];
        
    });
}

#pragma mark - Method Swizzling



- (void)swiz_viewDidAppear:(BOOL)animated {
    if ([self userStatisticsisAppear:YES]) {
        [UserStatistics enterPageViewWithPageID:[self userStatisticsisAppear:YES]];
    }
    [self swiz_viewDidAppear:animated];
}

- (void)swiz_viewDidDisappear:(BOOL)animated {
    [UserStatistics enterPageViewWithPageID:[self userStatisticsisAppear:NO]];
    [self swiz_viewDidDisappear:animated];
}


- (NSString *)userStatisticsisAppear:(BOOL)isAppear {
    NSDictionary *configDict = [self dictionaryFromUserStatisticsConfigPlist];
    NSString *className = NSStringFromClass([self class]);
    return configDict[className][isAppear ? @"controllerEnter":@"controllerLeave"];
}

- (NSString *)userStatisticsis {
    NSDictionary *configDict = [self dictionaryFromUserStatisticsConfigPlist];
    NSString *className = NSStringFromClass([self class]);
    return configDict[className][@"tableView:didSelectRowAtIndexPath:"];
}


- (NSDictionary *)dictionaryFromUserStatisticsConfigPlist
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"UserConfiguer" ofType:@"plist"];
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:filePath];
    return dic;
}

                     


@end
