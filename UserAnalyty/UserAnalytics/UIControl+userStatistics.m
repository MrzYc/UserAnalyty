//
//  UIControl+userStatistics.m
//  UserAnalyty
//
//  Created by zhYch on 2018/9/17.
//  Copyright © 2018年 zhaoyongchuang. All rights reserved.
//

#import "UIControl+userStatistics.h"
#import "ClassHook.h"
#import "UserStatistics.h"
@implementation UIControl (userStatistics)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL originalSelector = @selector(sendAction:to:forEvent:);
        SEL swizzledSelector = @selector(swiz_sendAction:to:forEvent:);
        [ClassHook swizzlingInClass:[self class] originalSelector:originalSelector swizzledSelector:swizzledSelector];
    });
}

- (void)swiz_sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event {
    //插入埋点代码
    [self performUserStastisticsAction:action to:target forEvent:event];
    [self swiz_sendAction:action to:target forEvent:    event];
}


- (void)performUserStastisticsAction:(SEL)action to:(id)target forEvent:(UIEvent *)event {
    NSString *eventID = nil;
    NSString *actionString = NSStringFromSelector(action);
    NSString *targetName = NSStringFromClass([target class]);
    NSDictionary *configDict = [self dictionaryFromUserStatisticsConfigPlist];
    NSDictionary *userDic = configDict[targetName];
    eventID = userDic[actionString];
    if (eventID != nil) {
        [UserStatistics sendEventToServer:eventID];
    } 
}


- (NSDictionary *)dictionaryFromUserStatisticsConfigPlist
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"UserConfiguer" ofType:@"plist"];
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:filePath];
    return dic;
}


@end
