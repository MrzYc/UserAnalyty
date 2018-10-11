//
//  ViewController.m
//  UserAnalyty
//
//  Created by zhYch on 2018/9/17.
//  Copyright © 2018年 zhaoyongchuang. All rights reserved.
//

#import "ViewController.h"
#import "NextViewController.h"

@interface ViewController ()


@end

@implementation ViewController

- (IBAction)pressOne:(id)sender {
    NSLog(@"按钮1点击事件");
}
- (IBAction)pressTwo:(id)sender {
    NSLog(@"按钮2点击事件");
}


- (IBAction)pressThr:(id)sender {
    NSLog(@"事件点击3");
}


- (IBAction)switchAction:(id)sender {
    
}

- (IBAction)pushAction:(id)sender {
    NextViewController *next = [[NextViewController alloc] init];
    [self.navigationController pushViewController:next animated:YES];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}














@end
