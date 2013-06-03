//
//  ViewController.m
//  OTCircleProgressViewDemo
//
//  Created by openthread on 6/3/13.
//  Copyright (c) 2013 openthread. All rights reserved.
//

#import "ViewController.h"
#import "OTCircleProgressView.h"

@interface ViewController ()

@end

@implementation ViewController
{
    OTCircleProgressView *_circleProgressView;
    NSTimer *_timer;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _circleProgressView = [[OTCircleProgressView alloc] initWithFrame:CGRectMake(120, 100, 80, 80)];
    _circleProgressView.roundedCorners = YES;
    _circleProgressView.beginPoint = 5 * M_PI_4;
    _circleProgressView.circleLength = 5 * M_PI_4;
    [self.view addSubview:_circleProgressView];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.5f
                                              target:self
                                            selector:@selector(changeProgress)
                                            userInfo:nil
                                             repeats:YES];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setTitle:@"indeterminate" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(indeterminate) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(100, 200, 120, 44);
    [self.view addSubview:button];
}

- (void)changeProgress
{
    CGFloat progress = _circleProgressView.progress;
    progress += 0.2;
    if (progress > 1)
    {
        progress = 0;
    }
    [_circleProgressView setProgress:progress animated:YES];
}

- (void)indeterminate
{
    _circleProgressView.indeterminate = !_circleProgressView.indeterminate;
}

@end
