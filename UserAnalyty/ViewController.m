//
//  ViewController.m
//  UserAnalyty
//
//  Created by zhYch on 2018/9/17.
//  Copyright © 2018年 zhaoyongchuang. All rights reserved.
//

#import "ViewController.h"
#import "NextViewController.h"

@interface ViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textTf;
@property (nonatomic, assign) NSInteger textLocation;//这里声明一个全局属性，用来记录输入位置


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

- (void)samllAnimatate {
    UILabel *animationLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 550, 150, 30)];
    animationLabel.text = @"小动画";
    [self.view addSubview:animationLabel];
    
    CALayer *layer = [[CALayer alloc] init];
    layer.frame = CGRectMake(0, 0, animationLabel.frame.size.width, animationLabel.frame.size.height);
    layer.backgroundColor = [UIColor lightGrayColor].CGColor;
    layer.anchorPoint = CGPointMake(0, 0);
    layer.position = CGPointMake(0, 0);
    
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"transform.scale.x"];
    anim.removedOnCompletion = NO;
    anim.duration = 0.5;
    anim.autoreverses = YES;              // 往返都有动画
    anim.repeatCount = MAXFLOAT;          // 执行次数
    anim.toValue = @0.6;
    [layer addAnimation:anim forKey:@"scaleAnimation"];
    
    [animationLabel.layer addSublayer:layer];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self samllAnimatate];
    
    
    self.textTf.delegate = self;
    
    [[[self.textTf textInputMode] primaryLanguage] isEqualToString:@"emoji"];
    
    [self.textTf addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];

}

- (void)textFieldDidChange:(UITextField *)textField{
    if ([self stringContainsEmoji:textField.text]) {
        textField.text =  [self converStrEmoji:textField.text];
    }
    UITextRange *selectedRange = textField.markedTextRange;
    UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
    if (!position) {
        // 2. 截取
        if (self.textTf.text.length >= 11) {
            self.textTf.text = [self.textTf.text substringToIndex:11];
        }
    } else {
        // 有高亮选择的字 不做任何操作
    }
}

-(NSString *)converStrEmoji:(NSString *)emojiStr
{
    NSString *tempStr = [[NSString alloc]init];
    NSMutableString *kksstr = [[NSMutableString alloc]init];
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:10];
    NSMutableString *strMu = [[NSMutableString alloc]init];
    for(int i =0; i < [emojiStr length]; i++){
        tempStr = [emojiStr substringWithRange:NSMakeRange(i, 1)];
        [strMu appendString:tempStr];
        if ([self stringContainsEmoji:strMu]) {
            strMu = [[strMu substringToIndex:([strMu length]-2)] mutableCopy];
            [array removeLastObject];
            continue;
        }else
            [array addObject:tempStr];
    }
    for (NSString *strs in array) {
        [kksstr appendString:strs];
    }
    return kksstr;
}

//是否含有表情
- (BOOL)stringContainsEmoji:(NSString *)string
{
    __block BOOL returnValue = NO;
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length])
                               options:NSStringEnumerationByComposedCharacterSequences
                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                const unichar hs = [substring characterAtIndex:0];
                                if (0xd800 <= hs && hs <= 0xdbff) {
                                    if (substring.length > 1) {
                                        const unichar ls = [substring characterAtIndex:1];
                                        const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                                        if (0x1d000 <= uc && uc <= 0x1f77f) {
                                            returnValue = YES;
                                        }
                                    }
                                } else if (substring.length > 1) {
                                    const unichar ls = [substring characterAtIndex:1];
                                    if (ls == 0x20e3 || ls == 0xfe0f) {
                                        returnValue = YES;
                                    }
                                } else {
                                    if (0x2100 <= hs && hs <= 0x27ff) {
                                        returnValue = YES;
                                    } else if (0x2B05 <= hs && hs <= 0x2b07) {
                                        returnValue = YES;
                                    } else if (0x2934 <= hs && hs <= 0x2935) {
                                        returnValue = YES;
                                    } else if (0x3297 <= hs && hs <= 0x3299) {
                                        returnValue = YES;
                                    } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                                        returnValue = YES;
                                    }
                                }
                            }];
    
    return returnValue;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSString *uniStr = [NSString stringWithUTF8String:[string UTF8String]];
    NSData *uniData = [uniStr dataUsingEncoding:NSNonLossyASCIIStringEncoding];
    NSString *goodStr = [[NSString alloc] initWithData:uniData encoding:NSUTF8StringEncoding] ;
    NSLog(@"%@", goodStr);
    
    
    //不支持系统表情的输入
    if ([[[UITextInputMode currentInputMode ] primaryLanguage] isEqualToString:@"emoji"]) {
        return NO;
    }
    if (textField.text.length >= 11) {
        if ([string isEqualToString:@""""]) {
            return YES;
        }else {
            return NO;
        }
    }
    return YES;
}












@end
