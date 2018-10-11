//
//  UITableView+userStatistics.m
//  UserAnalyty
//
//  Created by zhYch on 2018/10/11.
//  Copyright © 2018年 zhaoyongchuang. All rights reserved.
//

#import "UITableView+userStatistics.h"
#import <objc/runtime.h>

@implementation UITableView (userStatistics)

//设置delegate hook 方式

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method  originMethod = class_getInstanceMethod([self class], @selector(setDelegate:));
        Method newMethod = class_getInstanceMethod([self class], @selector(tab_setDelegate:));
        
        IMP newIMP = method_getImplementation(newMethod);
        BOOL isAdd = class_addMethod([self class], @selector(tab_setDelegate:), newIMP, method_getTypeEncoding(newMethod));
        if (isAdd) {
            //replace
            class_replaceMethod([self class], @selector(setDelegate:), newIMP, method_getTypeEncoding(newMethod));
        }else {
            //exchange
            method_exchangeImplementations(originMethod, newMethod);
        }
    });
}

- (void)tab_setDelegate:(id<UITableViewDelegate>)delegate {
    SEL oldSelector = @selector(tableView:didSelectRowAtIndexPath:);
    SEL newSelector = @selector(tab_tableView:didSelectRowAtIndexPath:);
    Method oldMethod_del = class_getInstanceMethod([delegate class], oldSelector);
    Method oldMethod_self = class_getInstanceMethod([self class], oldSelector);
    Method newMethod = class_getInstanceMethod([self class], newSelector);
    
    // 若未实现代理方法，则先添加代理方法
    BOOL isSuccess = class_addMethod([delegate class], oldSelector, class_getMethodImplementation([self class], newSelector), method_getTypeEncoding(newMethod));
    if (isSuccess) {
        class_replaceMethod([delegate class], newSelector, class_getMethodImplementation([self class], oldSelector), method_getTypeEncoding(oldMethod_self));
    } else {
        // 若已实现代理方法，则添加 hook 方法并进行交换
        BOOL isVictory = class_addMethod([delegate class], newSelector, class_getMethodImplementation([delegate class], oldSelector), method_getTypeEncoding(oldMethod_del));
        if (isVictory) {
            class_replaceMethod([delegate class], oldSelector, class_getMethodImplementation([self class], newSelector), method_getTypeEncoding(newMethod));
        }
    }
    [self tab_setDelegate:delegate];
}



- (void)tab_tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"hook了 代理方法 tableView:didSelectRowAtIndexPath:");
    [self tab_tableView:tableView didSelectRowAtIndexPath:indexPath];
}




@end
