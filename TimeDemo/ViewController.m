//
//  ViewController.m
//  TimeDemo
//
//  Created by 樊琳琳 on 16/1/15.
//  Copyright © 2016年 fll. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    UILabel *num;
    UIButton *timeButton;
    
    NSTimer *myTimer;
    int timeTick;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    timeButton=[[UIButton alloc] initWithFrame:CGRectMake(100, 200, 200, 100)];
    timeButton.backgroundColor=[UIColor redColor];
    [timeButton setTitle:@"点击开始" forState:UIControlStateNormal];
    [timeButton addTarget:self action:@selector(timeClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:timeButton];
    

    num=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 100)];
    num.backgroundColor=[UIColor orangeColor];
    num.textAlignment=NSTextAlignmentCenter;
    [timeButton addSubview:num];
}
//页面将要进入前台，开启定时器
-(void)viewWillAppear:(BOOL)animated
{
    //开启定时器
    [myTimer setFireDate:[NSDate distantPast]];
}

//页面消失，进入后台不显示该页面，关闭定时器
-(void)viewDidDisappear:(BOOL)animated
{
    //关闭定时器
    [myTimer setFireDate:[NSDate distantFuture]];
}
-(void)timeClick
{
    NSLog(@"点击开始");
    
    //方法一
    //[self startSendidentifyingCodewithBtn:timeButton andTime:60];

    //方法二
    myTimer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES];

    
    timeTick = 61;//60秒倒计时

    //不重复，只调用一次。timer运行一次就会自动停止运行
}
-(void)timeFireMethod
{
    
    timeTick--;
    if(timeTick==0){
        [myTimer invalidate];
        timeButton.enabled = YES;
        [timeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    }else
    {
        NSString *str = [NSString stringWithFormat:@"%d秒",timeTick];
        [timeButton setTitle:str forState:UIControlStateNormal];
    }
}

- (void)startSendidentifyingCodewithBtn:(UIButton *)btn andTime:(NSUInteger)time
{
    __block NSUInteger timeout = time;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_timer, ^{
        
        if(timeout<=0)
        {
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                [btn setTitle:@"重新发送" forState:UIControlStateNormal];
                [btn setBackgroundColor:[UIColor whiteColor]];
                btn.userInteractionEnabled = YES;
            });
            
        } else {
            
            int seconds = timeout % 61;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                [btn setTitle:[NSString stringWithFormat:@"%@S后重新获取",strTime] forState:UIControlStateNormal];
                [btn setBackgroundColor:[UIColor whiteColor]];
                btn.userInteractionEnabled = NO;
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
