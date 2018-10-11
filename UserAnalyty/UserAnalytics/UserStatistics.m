//
//  UserStatistics.m
//  UserAnalyty
//
//  Created by zhYch on 2018/9/17.
//  Copyright © 2018年 zhaoyongchuang. All rights reserved.
//

#import "UserStatistics.h"
#import <UMCommon/UMCommon.h>
#import <UMAnalytics/MobClick.h>

@implementation UserStatistics

+ (void)configure {
}

+ (void)enterPageViewWithPageID:(NSString *)pageID
{
    //进入页面
    NSLog(@"***模拟发送[进入页面]事件给服务端，页面ID:%@", pageID);
}

+ (void)leavePageViewWithPageID:(NSString *)pageID
{
    //离开页面
    NSLog(@"***模拟发送[离开页面]事件给服务端，页面ID:%@", pageID);
}

//control事件统计
+ (void)sendEventToServer:(NSString *)eventId
{
    [MobClick event:eventId];
    //在这里发送event统计信息给服务端
    NSLog(@"***模拟发送统计事件给服务端，事件ID: %@", eventId);
}


@end
